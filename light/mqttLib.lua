--MQTT library
local this = _G
module("mqttLib")

local m = nil
local mqtt = this.mqtt
local print = this.print
local tmr = this.tmr
local cjson = this.cjson
local pcall = this.pcall

local client_id 
local heartbeat_delay = 1000
local gpioLib = nil
local state = {}

--Initializes MQTT client
function init(cid,gpl)
    client_id=cid
    gpioLib=gpl

    --sets name
    m = mqtt.Client(this.client_name, 120, "user", "password")
    --sets LWT
    m:lwt("/lwt", "lwt offline", 0, 0)
    --sets offline listener
    m:on("offline", function(client) 
        print ("mqtt offline") 
        tmr.stop(0)
    end)
    --sets on message listener
    m:on("message", function(client, topic, data) 
        json=nil
        ok, stateIn = pcall(cjson.decode,data)
        if ok then
            if(stateIn.power~=nil)then
                if(stateIn.reqID~=nil)then
                    --set power
                    if(gpioLib.setPower(state,stateIn.power))then
                        sendHeartbeat(stateIn.reqID)    
                    else 
                        sendHeartbeat(stateIn.reqID)   
                    end   
                end
            end    
        else
            print("sumthink went wrong")
        end       
    end)
end

--Method for connecting to the MQTT broker
function connect(cb)    
    --broker details address and port
    m:connect("10.0.0.17", 41235, 0,1, function(client) 
        print("mqtt connect")
        
        topic1="/ESP8266V2/ALL"
        topic2="/ESP8266V2/"..client_id

        --subscribe to the topics above
        m:subscribe({[topic1]=1,[topic2]=1}, function(conn) 
            print("subscribe success") 
        end)

        --start sending heartbeat packets
        startHeartbeat()
        cb(true)
    end, 
    function(client, reason) 
        print("mqtt connection failed reason: "..reason) 
        tmr.stop(0)
        cb(false)
    end)     
end

--clears MQTT client and disconnects
function clear() 
    print("clear")
    tmr.stop(0)
    print(m)
    print(m~=nil)
    if(m~=nil)then
        m:close()
    end
           
end

--sends Heartbeat packet
function sendHeartbeat(reqID)
    state.reqID=reqID
    --pack state to cjson
    ok, json = pcall(cjson.encode,state)
    if ok then
        --print(json)
        --publish
        status=m:publish("/ESP8266V2/ALL/HEARTBEAT",json,1,0)
    end
    --increment
    state.increment=state.increment+1;
    if(state.increment>10000)then
        state.increment=0
    end
end

--start sending heartbeat packets periodically
function startHeartbeat()

    print("starting heartbeat")
    
    state.clientid = client_id 
    state.version = "0.2.0" 
    state.increment = 0
    state.power = 240
        
    tmr.register(0, heartbeat_delay, tmr.ALARM_AUTO, function() 
        --print("sending heartbeat")
        sendHeartbeat("")
    end)
    tmr.start(0)

    --gpioLib.setPower(state,240)
    

    
end

