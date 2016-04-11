--Wifi Library
local this = _G
module("wifiLib")

local m = nil
local print = this.print
local wifi = this.wifi

--[[
This method setups wifi
]]
function init() 
    --set wifi mode to 802.11b 
    wifi.setphymode(wifi.PHYMODE_B)
    --set wifi to combined mode Station+AP
    wifi.setmode(wifi.STATIONAP)
    
    --setup AP to connect
    wifi.sta.config("FialkaNet", "mamamelemasoa")
    -- wifi.sta.config("Turris", "zettor11")
end

--[[
This method setups wifi listeners
]]
function setupListeners(mqttLib)

    --close mqtt client when connecting 
    wifi.sta.eventMonReg(wifi.STA_CONNECTING, function() 
        print("STATION_CONNECTING") 
        mqttLib.clear()
    end)

    --try to connect to broker when got IP
    wifi.sta.eventMonReg(wifi.STA_GOTIP, function() 
        print("STATION_GOT_IP") 
        mqttLib.connect(function(a)
            --print("connected ok "..this.tostring(a==true))
        end)
    end)

    --start listeners
    wifi.sta.eventMonStart()
end
