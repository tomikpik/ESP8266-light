print(node.setcpufreq(node.CPU160MHZ))

wifi.setmode(wifi.STATIONAP)
wifi.sta.config("Turris", "zettor11")

wifi.sta.eventMonReg(wifi.STA_GOTIP, function() 
    print(wifi.sta.getip())
    print("STATION_GOT_IP") 

    m = mqtt.Client("LightESP:"..node.chipid(), 120, "user", "password")
    
    m:lwt("/lwt", "lwt offline", 0, 0)
    
    m:on("connect", function(client) 
        print ("con connected") 
    end)
    
    m:on("offline", function(client) 
        print ("offline offline") 
    end)
    
    m:on("message", function(client, topic, data) 
        print(topic .. ":" ) 
        if data ~= nil then
            print(data)
        end
    end)

    m:connect("192.168.1.163", 41235, 0, 
        function(client) 
            print("connected") 
        end, 
        function(client, reason) 
            print("failed reason: "..reason) 
        end
    )

    if not tmr.alarm(0, 2000, tmr.ALARM_AUTO, 
        function() 
            message = node.chipid()..":1:1:1:1:0:0"
            m:publish("/ESP8266V2/ALL/HEARTBEAT",message,1,0, 
                function(client) 
                    print("heartbeat sent")
                end
            )
        end) 
    then 
        print("whoopsie") 
    end
    
    
end)

pwm.setup(7, 60, 512)
pwm.start(7)
pwm.setduty(7,1023)

wifi.sta.eventMonStart()




