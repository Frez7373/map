-- Настройка API для Minecraft
-- Предположим, что у вас есть объект 'mc' с методами:
-- mc.getPlayerPos() -> возвращает x, y, z
-- mc.getHeight(x, z) -> возвращает высоту
-- mc.getBlock(x, y, z) -> возвращает id блока
-- Также предполагается, что есть таблица block с id блоков

local MAP_SIZE = 20

-- Получение позиции игрока
function get_player_position()
    local x, y, z = mc.getPlayerPos()
    return x, y, z
end

-- Создание карты
function create_map(center_x, center_z, size)
    local half = math.floor(size / 2)
    local map_data = {}

    for dx = -half, half - 1 do
        local row = {}
        for dz = -half, half - 1 do
            local block_x = center_x + dx
            local block_z = center_z + dz
            local block_y = mc.getHeight(block_x, block_z)
            local block_id = mc.getBlock(block_x, block_y - 1, block_z)
            table.insert(row, block_id)
        end
        table.insert(map_data, row)
    end

    return map_data
end

-- Визуализация карты в консоли
function display_map(map_data)
    for _, row in ipairs(map_data) do
        local line = ""
        for _, block_id in ipairs(row) do
            if block_id == block.AIR then
                line = line .. " "
            elseif block_id == block.WATER then
                line = line .. "~"
            elseif block_id == block.GRASS then
                line = line .. '"'
            elseif block_id == block.STONE then
                line = line .. "#"
            else
                line = line .. "?"
            end
        end
        print(line)
    end
end

-- Основной цикл
function main()
    while true do
        local x, y, z = get_player_position()
        local map_data = create_map(x, z, MAP_SIZE)
        display_map(map_data)
        print("Обновление карты через 5 секунд...")
        os.execute("sleep 5")
    end
end

main()
