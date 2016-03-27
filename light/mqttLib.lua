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


function init(cid,gpl)
    client_id=cid
    gpioLib=gpl
 
    m = mqtt.Client(this.client_name, 120, "user", "password")
    
    m:lwt("/lwt", "lwt offline", 0, 0)
    
    m:on("offline", function(client) 
        print ("mqtt offline") 
        tmr.stop(0)
    end)
    
    m:on("message", function(client, topic, data) 
        json=nil
        ok, stateIn = pcall(cjson.decode,data)
        if ok then
            if(stateIn.power~=nil)then
                if(stateIn.reqID~=nil)then
                    if(gpioLib.setPower(state,stateIn.power))then
                        sendHeartbeat(stateIn.reqID)    
                    end   
                end
            end    
        else
            print("sumthink went wrong")
        end       
        
    end)
    
end

function connect(cb)    
   

    m:connect("10.0.0.17", 41235, 0,1, function(client) 
        print("mqtt connect")
        
        topic1="/ESP8266V2/ALL"
        topic2="/ESP8266V2/"..client_id
       
        m:subscribe({[topic1]=1,[topic2]=1}, function(conn) 
            print("subscribe success") 
        end)

        startHeartbeat()
        cb(true)
    end, 
    function(client, reason) 
        print("mqtt connection failed reason: "..reason) 
        tmr.stop(0)
        cb(false)
    end)     
end

function clear() 
    print("clear")
    tmr.stop(0)
    print(m)
    print(m~=nil)
    if(m~=nil)then
        m:close()
    end
           
end

function sendHeartbeat(reqID)
    state.reqID=reqID
    ok, json = pcall(cjson.encode,state)
    if ok then
        --print(json)
        status=m:publish("/ESP8266V2/ALL/HEARTBEAT",json,1,0)
    end

    state.increment=state.increment+1;
    if(state.increment>10000)then
        state.increment=0
    end
end

function startHeartbeat()

    print("starting heartbeat")
    
    state.clientid = client_id 
    state.version = "0.2.0" 
    state.increment = 0
    state.power = 0
        
    tmr.register(0, heartbeat_delay, tmr.ALARM_AUTO, function() 
        --print("sending heartbeat")
        sendHeartbeat("")
    end)
    tmr.start(0)
    
    

    
end

