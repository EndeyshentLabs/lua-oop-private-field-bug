---@class Person
Person = {}

function Person:new(name)
    local private = {}
    private.age = 18

    local public = {}
    public.name = name

    function Person:getName()
        return "My name is " .. self.name
    end

    function Person:getAge() -- The bug is triggered, when private field is accessed through method that belongs to Class itself, not `public` table
        return "I'm " .. private.age .. " years old"
    end

    function public:getAgeCORRECT() -- This method is method of `public`, not class itself!
        return "I'm " .. private.age .. " years old"
    end

    function Person:setAge(age)
        private.age = age
    end

    setmetatable(public, self)
    self.__index = self
    return public
end

local walter = Person:new("Walter")
walter:setAge(65)

local jesse = Person:new("Jesse")
jesse:setAge(39)

-- Must be
-- Walter: 65
-- Jesse: 39
print(("----------\nINCORRECT\nWalter: %s\nJesse: %s"):format(walter:getAge(), jesse:getAge()))
print(("----------\nCORRECT\nWalter: %s\nJesse: %s"):format(walter:getAgeCORRECT(), jesse:getAgeCORRECT()))
