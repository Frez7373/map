-- Функция для размещения блока черепашкой
local function placeBlock()
    if turtle.detectDown() then
        return
    end
    while not turtle.placeDown() do
        turtle.select((turtle.getSelectedSlot() % 16) + 1)
    end
end

-- Функция для постройки одного этажа
local function buildFloor(width, depth, height)
    for y = 1, height do
        for z = 1, depth do
            for x = 1, width do
                placeBlock()
                if x < width then
                    turtle.forward()
                end
            end
            if z < depth then
                if z % 2 == 1 then
                    turtle.turnRight()
                    turtle.forward()
                    turtle.turnRight()
                else
                    turtle.turnLeft()
                    turtle.forward()
                    turtle.turnLeft()
                end
            end
        end
        -- Возвращаемся к началу уровня
        if depth % 2 == 1 then
            turtle.turnRight()
            for i = 1, width - 1 do
                turtle.forward()
            end
            turtle.turnRight()
        else
            for i = 1, depth - 1 do
                turtle.forward()
            end
        end
        if y < height then
            turtle.up()
        end
    end
end

-- Основная функция для постройки дома
local function buildHouse(floors, width, depth, floorHeight)
    for floor = 1, floors do
        buildFloor(width, depth, floorHeight)
        if floor < floors then
            for i = 1, floorHeight do
                turtle.up()
            end
        end
    end
end

-- Настройки дома
local floors = 3      -- Количество этажей
local width = 12      -- Ширина дома
local depth = 6       -- Глубина дома
local floorHeight = 4 -- Высота одного этажа

-- Запуск постройки дома
buildHouse(floors, width, depth, floorHeight)
