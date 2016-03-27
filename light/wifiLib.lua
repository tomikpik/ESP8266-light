local this = _G
module("wifiLib")

local m = nil
local print = this.print
local wifi = this.wifi

function init() 
    wifi.setphymode(wifi.PHYMODE_B)
    wifi.setmode(wifi.STATIONAP)
    
    wifi.sta.config("FialkaNet", "mamamelemasoa")
    --wifi.sta.config("Turris", "zettor11")
end

function setupListeners(mqttLib)

    wifi.sta.eventMonReg(wifi.STA_CONNECTING, function() 
        print("STATION_CONNECTING") 
        mqttLib.clear()
    end)
    
    wifi.sta.eventMonReg(wifi.STA_GOTIP, function() 
        print("STATION_GOT_IP") 
        mqttLib.connect(function(a)
            --print("connected ok "..this.tostring(a==true))
        end)
    end)
    
    wifi.sta.eventMonStart()
end
