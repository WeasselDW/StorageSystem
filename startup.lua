StorageSystem = {}
redstoneOutput = {}
function StorageSystem:create(speed, length, width, height)
    StorageSystem.speed = speed

    StorageSystem.length = length
    StorageSystem.width = width
    StorageSystem.height = height
end

function StorageSystem:Move(x, y)
    
end

system = StorageSystem:create(256,100,25,10)



function redstoneOutput:create()

    redstoneOutput.clutch = true
    redstoneOutput.gearshift = false
    redstoneOutput.gantry1 = false
    redstoneOutput.gantry2 = false
    redstoneOutput.sticker = false
end
    --[[redstone.setAnalogOutput("right", clutch)
    redstone.setAnalogOutput("left", gearshift)
    redstone.setAnalogOutput("top", g1)
    redstone.setAnalogOutput("back", sticker)
    redstone.setAnalogOutput("front", g2)]]


print(system.width)
