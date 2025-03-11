local pion = require "pion"
local timer = require "timer"
local math = require "math"

local radius = 1.0
local altitude = 2.0
local duration = 300

local function takeoff(target_altitude)
    pion.set_mode("GUIDED")
    pion.arm()
    pion.takeoff(target_altitude)
    while pion.get_altitude() < target_altitude * 0.95 do
        timer.sleep(1)
    end
end

local function figure_eight(radius, duration)
    local start_time = timer.get_time()
    local angle = 0
    while timer.get_time() - start_time < duration do
        local north = radius * math.sin(angle)
        local east = radius * math.sin(2 * angle)
        pion.set_position(north, east, -altitude)
        angle = angle + 0.1
        if angle >= 2 * math.pi then
            angle = 0
        end
        timer.sleep(0.1)
    end
end

local function smooth_land()
    local current_altitude = pion.get_altitude()
    while current_altitude > 0.2 do
        current_altitude = current_altitude - 0.1
        pion.set_position(0, 0, -current_altitude)
        timer.sleep(0.2)
    end
    pion.set_mode("LAND")
    while pion.is_armed() do
        timer.sleep(1)
    end
end

takeoff(altitude)
figure_eight(radius, duration)
smooth_land()
