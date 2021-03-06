--==========VARIABLES============ --
-- Constant
modemChannel = 6969




--==========INITIATING============ --
print("initiating StorageSystem")
os.loadAPI("StorageSystemAPI")

-- Websocket init
print("Starting websocket")
ws, err = http.websocket("localhost:8080")
if ws then
    print("Websocket initiated")
end


-- Modem init
print("Starting Modem")
modem = peripheral.wrap("bottom")
modem.open(modemChannel)
if modem.isOpen(modemChannel) then
    print("Modem initialized")
end
-- CLUTCH init
redstone.setOutput("right", true)

--==========CODE============ --
system = StorageSystemAPI.StorageSystem:create(256,17,11,11)
x = tonumber(read())
y = tonumber(read())
z = tonumber(read())
system:Move(x,y,z)
