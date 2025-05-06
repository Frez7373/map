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

-- Функция для постройки одной стены
local function buildWall(length, height)
    for h = 1, height do
        for l = 1, length do
            placeBlock()
            if l < length then
                safeForward()
            end
        end
        if h < height then
            safeUp()
            turtle.turnRight()
            turtle.turnRight()
            for l = 1, length - 1 do
                safeForward()
            end
            turtle.turnRight()
            turtle.turnRight()
        end
    end
end

-- Функция для постройки прямоугольной коробки (4 стены)
local function buildBox(width, depth, height)
    for i = 1, 2 do
        buildWall(width, height)
        turtle.turnRight()
        buildWall(depth, height)
        turtle.turnRight()
    end
end

-- Основная функция для постройки дома
local function buildHouse(floors, width, depth, floorHeight)
    for floor = 1, floors do
        buildBox(width, depth, floorHeight)
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
