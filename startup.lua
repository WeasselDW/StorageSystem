StorageSystem = {}
redstoneOutput = {}
function StorageSystem:create(speed, length, width, height)
    local obj = {}
    setmetatable(obj, StorageSystem)

    StorageSystem.speed = speed

    StorageSystem.length = length
    StorageSystem.width = width
    StorageSystem.height = height
    return obj
end

function StorageSystem:Move(x, y)
    
end

system = StorageSystem:create(256,100,25,10)



function redstoneOutput:create()
    local obj = {}
    setmetatable(obj, redstoneOutput)
    redstoneOutput.clutch = true
    redstoneOutput.gearshift = false
    redstoneOutput.gantry1 = false
    redstoneOutput.gantry2 = false
    redstoneOutput.sticker = false
    return obj
end
    --[[redstone.setAnalogOutput("right", clutch)
    redstone.setAnalogOutput("left", gearshift)
    redstone.setAnalogOutput("top", g1)
    redstone.setAnalogOutput("back", sticker)
    redstone.setAnalogOutput("front", g2)]]


print(system.width)
