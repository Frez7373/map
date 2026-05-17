-- SERVER CODE: Place on the main central computer
local MODEM_SIDE = "top" -- Change to your modem side
rednet.open(MODEM_SIDE)
rednet.host("cc_cloud", "main_server")

-- User database: [username] = {password = "pass", drive = "drive_name"}
-- Example: drive_0 is the side or network name of the disk drive
local users = {
    admin = {password = "1234", drive = "disk"},
    player1 = {password = "my_password", drive = "drive_0"}
}

print("Cloud Server started...")

local function authenticate(user, pass)
    if users[user] and users[user].password == pass then
        return true
    end
    return false
end

local function get_user_path(user, filename)
    local drive = users[user].drive
    local mount_path = disk.getMountPath(drive)
    if not mount_path then return nil end
    if filename then
        return fs.combine(mount_path, filename)
    end
    return mount_path
end

while true do
    local id, msg = rednet.receive("cc_cloud")
    if type(msg) == "table" and msg.protocol == "v1" then
        local cmd = msg.command
        local user = msg.username
        local pass = msg.password

        if not authenticate(user, pass) then
            rednet.send(id, {status = "error", message = "Auth failed"}, "cc_cloud")
        else
            local root = get_user_path(user)
            if not root then
                rednet.send(id, {status = "error", message = "Drive not found"}, "cc_cloud")
            else
                if cmd == "list" then
                    local files = fs.list(root)
                    rednet.send(id, {status = "ok", data = files}, "cc_cloud")

                elseif cmd == "read" then
                    local path = get_user_path(user, msg.filename)
                    if fs.exists(path) and not fs.isDir(path) then
                        local f = fs.open(path, "r")
                        local content = f.readAll()
                        f.close()
                        rednet.send(id, {status = "ok", data = content}, "cc_cloud")
                    else
                        rednet.send(id, {status = "error", message = "File not found"}, "cc_cloud")
                    end

                elseif cmd == "write" then
                    local path = get_user_path(user, msg.filename)
                    local f = fs.open(path, "w")
                    f.write(msg.data)
                    f.close()
                    rednet.send(id, {status = "ok", message = "Saved"}, "cc_cloud")

                elseif cmd == "delete" then
                    local path = get_user_path(user, msg.filename)
                    if fs.exists(path) then
                        fs.delete(path)
                        rednet.send(id, {status = "ok", message = "Deleted"}, "cc_cloud")
                    else
                        rednet.send(id, {status = "error", message = "File not found"}, "cc_cloud")
                    end
                end
            end
        end
    end
end
