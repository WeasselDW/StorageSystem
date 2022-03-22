--[[
right   clutch
left    gearshift
top     g1
front   g2
back    sticker
--]]

--constants
height = 5
speed = 256

firstBox = 6

--variablese
boxX = 1
boxY = 1
boxLane = 1

targetX = 0 
targetY = 0
targetZ = 0

currentX = 0
currentY = 0
currentX = 0

commandQueue = {}

-- Alles uit
redstone.setAnalogOutput("right", 15)
redstone.setAnalogOutput("left", 0)
redstone.setAnalogOutput("top", 0)
redstone.setAnalogOutput("back", 0)
redstone.setAnalogOutput("front", 0)


-- Websocket init
ws, err = http.websocket("localhost:8080")
if ws then
    ws.send(textutils.serialiseJSON({"machine"}))
end

-- Modem init
modem = peripheral.wrap("bottom")
modem.open(6969)

-- Functions
    --LogPosition
        function logposition()
            local event, modemSide, senderChannel, replyChannel, message, senderDistance = os.pullEvent("modem_message")

            local t={}
                for str in string.gmatch(message, "([^".."%p".."]+)") do
                    table.insert(t, str)
                end 
                currentX = t[1] - 1
                currentY = t[2] - 1
                currentZ = t[3]

                currentLane = math.ceil((currentZ-firstBox)/4 + 1)
                targetLane = math.ceil((targetZ-firstBox)/4 + 1)
        end
    -- MoveXYZ
        function moveX(newX)
            logposition()
            local deltaX = newX - currentX
            if deltaX ~= 0 then     
                local X = math.abs(deltaX)
    
                if deltaX < 0 then
                redstone.setAnalogOutput("left", 15)
                else
                redstone.setAnalogOutput("left", 0)
                end
        
            redstone.setAnalogOutput("right", 0)
            redstone.setAnalogOutput("front", 15)
            sleep(51.2/speed+25.6/speed*(X+1/60*X))
            redstone.setAnalogOutput("right", 15)
            redstone.setAnalogOutput("front", 0)
            --sleep(0.1)
            redstone.setAnalogOutput("left", 0)
            logposition()
            end
        end
    
        function moveY(newY)
            logposition()
            local deltaY = newY - currentY
            if deltaY ~= 0 then
                local Y = math.abs(deltaY)
            
                if deltaY < 0 then
                    redstone.setAnalogOutput("left", 15)    
                else
                    redstone.setAnalogOutput("left", 0)
                end
            redstone.setAnalogOutput("top", 15)
            redstone.setAnalogOutput("right", 0)
            sleep(51.2/speed+25.6/speed*(Y+1/60*Y))
            redstone.setAnalogOutput("right", 15)
            redstone.setAnalogOutput("top", 0)
            --sleep(0.1)
            redstone.setAnalogOutput("left", 0)
            logposition()
            end
        end
    
        function moveZ(newZ)
            logposition()
            local deltaZ = newZ - currentZ
            if deltaZ ~= 0 then
                local Z = math.abs(deltaZ)
    
                if deltaZ < 0 then
                    redstone.setAnalogOutput("left", 15)
                else
                    redstone.setAnalogOutput("left", 0)
                end
            redstone.setAnalogOutput("right", 0)
            sleep(51.2/speed+25.6/speed*(Z+1/60*Z))
            redstone.setAnalogOutput("right", 15)
            --sleep(0.1)
            redstone.setAnalogOutput("left", 0)
            logposition()
            end
        end
    
        function movePosition(X, Y, Z)
            --print("moveposition("..X..","..Y..","..Z..")")
            targetX = X
            targetY = Y
            targetZ = Z
            logposition()
            sleep(0.01)
            if currentLane == targetLane then
                moveZ(targetZ)
                --sleep(0.1)
                moveX(targetX)
                --sleep(0.1)
                moveY(targetY)
                positionCheck()
            else
                moveY(height)
                moveZ(targetZ)
                moveX(targetX)
                moveY(targetY)
                positionCheck()
            end
            
        end
    -- PositionCheck
        function positionCheck()
            logposition()
            sleep(0.1)
            if currentX ~= targetX or currentY ~= targetY or currentZ + 0 ~= targetZ then
                logposition()
                sleep(0.1)
                movePosition(targetX, targetY, targetZ)
                positionCheck()
            else
                currentLane = math.ceil((currentZ - firstBox)/4 + 1)
                currentBox = {currentX - 2, currentY + 1}
            end
        end
    --use box
        function use()
            moveZ(targetZ+1)
            redstone.setAnalogOutput("back", 15)
            sleep(0.1)
            redstone.setAnalogOutput("back", 0)
            moveZ(targetZ)
        end
        function sticker()
            redstone.setAnalogOutput("back", 15)
            sleep(0.1)
            redstone.setAnalogOutput("back", 0)
        end


--movePosition(0,0,0)


function events()
    while true do
        local event, url, contents = os.pullEvent()
        if event == "websocket_message" then
            data = textutils.unserialiseJSON(contents)
            print(contents)
        --function getPickupLocation()
            --get pickup location
                if data[2] ~= nil then
                    coords={}
                    for str in string.gmatch(data[2], "([^".."%p".."]+)") do
                        table.insert(coords, str)
                    end
                    boxLane = coords[1]*4 
                    boxY = coords[3]-1  
                end
                    --remove middle gap
                    if tonumber(coords[2]) > 11 then
                        boxX = coords[2] + 6
                    else
                        boxX = coords[2] + 2
                    end
                
        --end
            --order
                if data[1] == "withdraw" then
                    --[[movePosition(boxX,boxY,boxLane)
                    use()
                    movePosition(5,0,0)
                    use()]]                      
                    local lBoxX,lBoxY,lBoxLane= boxX,boxY,boxLane
                    table.insert(commandQueue,function() return movePosition(lBoxX,lBoxY,lBoxLane)end) 

                    table.insert(commandQueue,function() return use() end)
                    table.insert(commandQueue,function() return movePosition(5,0,0) end)
                    table.insert(commandQueue,function() return use() end)
                    
                elseif data[1] == "deposit" then  
                    --[[movePosition(boxX,boxY,boxLane)
                    use()
                    movePosition(2,0,0)
                    use()]]
                    print(boxX,boxY,boxLane)
                    local lBoxX,lBoxY,lBoxLane= boxX,boxY,boxLane
                    table.insert(commandQueue,function() return movePosition(lBoxX,lBoxY,lBoxLane) end )             
                    table.insert(commandQueue,function() return use() end)
                    table.insert(commandQueue,function() return movePosition(2,0,0) end)
                    table.insert(commandQueue,function() return use() end)


                elseif data[1] == "withdraw done" then 
                    --[[movePosition(5,0,0)
                    use()
                    movePosition(boxX,boxY,boxLane)
                    use()]]
                    table.insert(commandQueue,function() return movePosition(5,0,0) end)
                    table.insert(commandQueue,function() return use()  end)
                    local lBoxX,lBoxY,lBoxLane= boxX,boxY,boxLane
                    table.insert(commandQueue,function() return movePosition(lBoxX,lBoxY,lBoxLane)end) 
                    table.insert(commandQueue,function() return use() end)

                elseif data[1] == "deposit done" then    
                    --[[movePosition(2,0,0)
                    use()
                    movePosition(boxX,boxY,boxLane)
                    use()]]
                    print(boxX,boxY,boxLane)
                    table.insert(commandQueue,function() return movePosition(2,0,0) end)
                    table.insert(commandQueue,function() return use() end)
                    local lBoxX,lBoxY,lBoxLane= boxX,boxY,boxLane
                    table.insert(commandQueue,function() return movePosition(lBoxX,lBoxY,lBoxLane)end) 
                    table.insert(commandQueue,function() return use() end)

                end
        end
    end

end
function queue()
    while true do
     --eerstvolgende command uit array uitvoeren
        -- too long w/o yield fix
        --os.queueEvent("randomEvent")
        --os.pullEvent()
        sleep(0.05)
        
        -- pop function uit de array
        
        if table.getn(commandQueue) > 0 then 
            nextFunction = table.remove(commandQueue, 1)
            nextFunction()

        end
    end
end
parallel.waitForAll(queue, events)
