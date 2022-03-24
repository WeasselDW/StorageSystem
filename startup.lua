--==========VARIABLES============ --
-- Constant
modemChannel = 6969




--==========INITIATING============ --
print("initiating StorageSystem")
os.loadAPI("StorageSystemAPI")

-- Websocket init
print("Starting websocket")
--ws, err = http.websocket("localhost:8080")
if ws then
    print("Websocket initiated")
end

print("Starting Modem")
modem = peripheral.wrap("bottom")
modem.open(modemChannel)
if modem.isOpen(modemChannel) then
    print("Modem initialized")
end

--==========CODE============ --
system = StorageSystemAPI.StorageSystem:create(256,100,25,10)
print(system.position.x)
x = read()
y = read()
z = read()
system:Move(x,y,z)
