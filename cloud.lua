-- CLIENT CODE: Place on user computer
local MODEM_SIDE = "back" -- Change to your modem side
rednet.open(MODEM_SIDE)

local server_id = rednet.lookup("cc_cloud", "main_server")
if not server_id then
    error("Server not found! Check modems.")
end

write("Username: ")
local username = read()
write("Password: ")
local password = read("*")

local function send_cmd(payload)
    payload.protocol = "v1"
    payload.username = username
    payload.password = password
    rednet.send(server_id, payload, "cc_cloud")
    local id, res = rednet.receive("cc_cloud", 5)
    if not res then return {status = "error", message = "Timeout"} end
    return res
end

while true do
    print("\n--- Cloud Drive: " .. username .. " ---")
    print("1. List files")
    print("2. Download file (Read)")
    print("3. Upload file (Write)")
    print("4. Delete file")
    print("5. Exit")
    write("Choose option: ")
    local choice = read()

    if choice == "1" then
        local res = send_cmd({command = "list"})
        if res.status == "ok" then
            print("Files:")
            for _, v in ipairs(res.data) do print("- " .. v) end
        else
            print("Error: " .. res.message)
        end

    elseif choice == "2" then
        write("Remote filename to read: ")
        local r_file = read()
        local res = send_cmd({command = "read", filename = r_file})
        if res.status == "ok" then
            print("Content:\n" .. res.data)
            write("Save locally? (y/n): ")
            if read() == "y" then
                write("Local filename: ")
                local l_file = read()
                local f = fs.open(l_file, "w")
                f.write(res.data)
                f.close()
                print("Saved locally.")
            end
        else
            print("Error: " .. res.message)
        end

    elseif choice == "3" then
        write("Local filename to upload: ")
        local l_file = read()
        if fs.exists(l_file) and not fs.isDir(l_file) then
            local f = fs.open(l_file, "r")
            local content = f.readAll()
            f.close()

            write("Remote filename: ")
            local r_file = read()
            local res = send_cmd({command = "write", filename = r_file, data = content})
            print(res.message or res.status)
        else
            print("Local file does not exist.")
        end

    elseif choice == "4" then
        write("Filename to delete: ")
        local r_file = read()
        local res = send_cmd({command = "delete", filename = r_file})
        print(res.message or res.status)

    elseif choice == "5" then
        break
    end
end
