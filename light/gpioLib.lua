local this = _G
module("gpioLib")

local print = this.print

function setPower(state,power)
    if(power>=0)then
        if(power<256)then
            state.power=power
            print("setting power to "..power) 
            return true
        end   
    end
    return false
end