--load modules
require("mqttLib")
require("wifiLib")
require("gpioLib")

--set CPU frequency to 160MHz
node.setcpufreq(node.CPU160MHZ)

--generate client id and client name
client_id = string.format("%X%X",node.chipid(),node.flashid())
client_name = string.format("ESP_%s",client_id)
print(client_name)

--initialize GPIO
gpioLib.init()
--initialize MQTT
mqttLib.init(client_id,gpioLib)
--initialize WiFi
wifiLib.init()
--setup WiFi listeners
wifiLib.setupListeners(mqttLib)
