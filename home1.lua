-- Функция для размещения блока черепашкой
local function placeBlock()
    while not turtle.placeDown() do
        turtle.select((turtle.getSelectedSlot() % 16) + 1)
    end
end

-- Функция для перемещения черепашки вперед с проверкой препятствий
local function safeForward()
    while not turtle.forward() do
        turtle.dig()
    end
end

-- Функция для перемещения черепашки вверх с проверкой препятствий
local function safeUp()
    while not turtle.up() do
        turtle.digUp()
    end
end

-- Функция для перемещения черепашки вниз с проверкой препятствий
local function safeDown()
    while not turtle.down() do
        turtle.digDown()
    end
end

-- Функция для постройки одного этажа
local function buildFloor(width, depth)
    for z = 1, depth do
        for x = 1, width do
            placeBlock()
            if x < width then
                safeForward()
            end
        end
        if z < depth then
            if z % 2 == 1 then
                turtle.turnRight()
                safeForward()
                turtle.turnRight()
            else
                turtle.turnLeft()
                safeForward()
                turtle.turnLeft()
            end
        end
    end
    -- Возвращаемся к начальной позиции
    if depth % 2 == 1 then
        turtle.turnRight()
        for i = 1, width - 1 do
            safeForward()
        end
        turtle.turnRight()
    else
        for i = 1, depth - 1 do
            safeForward()
        end
        turtle.turnLeft()
        turtle.turnLeft()
    end
end

-- Основная функция для постройки дома
local function buildHouse(floors, width, depth, floorHeight)
    for floor = 1, floors do
        buildFloor(width, depth)
        if floor < floors then
            for i = 1, floorHeight do
                safeUp()
            end
        end
    end
    -- Возвращаемся вниз после постройки дома
    for i = 1, (floors - 1) * floorHeight do
        safeDown()
    end
end

-- Настройки дома
local floors = 3      -- Количество этажей
local width = 12      -- Ширина дома
local depth = 6       -- Глубина дома
local floorHeight = 4 -- Высота одного этажа

-- Запуск постройки дома
buildHouse(floors, width, depth, floorHeight)
