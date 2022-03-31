Test = {}
Test.__index = Test

function Test:create(amogus)
    local obj = {}
    setmetatable(obj, Test)
    
    return obj
    
end

function Test:moveX(aa)

    function Test:printss(obama)
        print(obama)
    end

end

function Test:johnny()
    Test:printss("bidomer")

end

object = Test:create()
object:johnny()
