--GPIO library
local this = _G
module("gpioLib")

local print = this.print
local gpio = this.gpio
local pwm = this.pwm

--Constants
local digitalPin = 2
local pwmPin = 7
local pwmClock = 250

--[[
This method initializes digital pin and PWM pin.
Also set up pwm (clock, duty cycle etc.)
]]
function init()
    --set digital pin
    gpio.mode(digitalPin, gpio.OUTPUT)
    --setup PWM pin
    pwm.setup(pwmPin,pwmClock,1000)
    pwm.setduty(pwmPin,1000)
end

--[[
This method checks power value and sets power if it's correct.
For debugging puroses the max power is limited to approx. 30%
]]
function setPower(state,power)
    if(power>=0)then
        if(power<256)then
            state.power=power
            print("setting power to "..state.power) 


            value=0
            if(state.power>0)then
                value=value+1
            end
            gpio.write(digitalPin,value)
            pwm.setduty(pwmPin,768+state.power)
            
            return true
        end   
    end
    return false
end
