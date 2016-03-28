local this = _G
module("gpioLib")

local print = this.print
local gpio = this.gpio
local pwm = this.pwm

local digitalPin = 2
local pwmPin = 7
local pwmClock = 120

function init()
    gpio.mode(digitalPin, gpio.OUTPUT)
    pwm.setup(pwmPin,pwmClock,0)
end

function setPower(state,power)
    if(power>=0)then
        if(power<256)then
            state.power=power*4
            print("setting power to "..state.power) 


            value=0
            if(state.power>0)then
                value=value+1
            end
            gpio.write(digitalPin,value)
            pwm.setduty(pwmPin,state.power)
            
            return true
        end   
    end
    return false
end
