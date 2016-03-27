l = file.list();
for k,v in pairs(l) do
    print(k,v)
end


state = {}
state.client_name = "ESP_chipid" 
state.version = "0.1" 
state.increment = 1
state.power = 0

ok, json = pcall(cjson.encode,state)
if ok then
  print(json)
else
  print("failed to encode!")
end


a=cjson.decode('{"power":0,"increment":1,"version":"0.1","client_name":"ESP_chipid"}')
print(a)