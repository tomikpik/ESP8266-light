require("mqttLib")
require("wifiLib")
require("gpioLib")

node.setcpufreq(node.CPU160MHZ)

client_id = string.format("%X%X",node.chipid(),node.flashid())
client_name = string.format("ESP_%s",client_id)
print(client_name)

gpioLib.init()

mqttLib.init(client_id,gpioLib)
wifiLib.init()
wifiLib.setupListeners(mqttLib)
