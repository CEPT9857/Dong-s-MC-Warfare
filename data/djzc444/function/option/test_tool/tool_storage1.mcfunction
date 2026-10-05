#地图元数据示例：陆战-冬季战场
#向storage djzc444:map_djzc中写入地图元数据
data merge storage djzc444:map_djzc {a_point:{x:-306,y:63,z:-857,dx:23,dy:7,dz:4,glass_x:-304,glass_y:68,glass_z:-855,NAME:A,name:a,gameflow:1}}
data merge storage djzc444:map_djzc {b_point:{x:-257,y:57,z:-784,dx:-16,dy:8,dz:15,glass_x:-259,glass_y:61,glass_z:-772,NAME:B,name:b,gameflow:1}}
data merge storage djzc444:map_djzc {c_point:{x:-385,y:66,z:-768,dx:16,dy:7,dz:15,glass_x:-366,glass_y:65,glass_z:-759,NAME:C,name:c,gameflow:2}}
data merge storage djzc444:map_djzc {d_point:{x:-469,y:61,z:-764,dx:2,dy:1,dz:7,glass_x:-458,glass_y:60,glass_z:-761,NAME:D,name:d,gameflow:2}}
data merge storage djzc444:map_djzc {airport_ct:{x:-445,y:73,z:-535,dx:-6,dy:3,dz:-13}}
data merge storage djzc444:map_djzc {airport_t:{x:-36,y:68,z:-844,dx:-12,dy:3,dz:6}}
data merge storage djzc444:map_djzc {}
#写入测试模板，检测读取是否正常
function djzc444:option/test_tool/tool_storage2 with storage djzc444:map_djzc a_point
function djzc444:option/test_tool/tool_storage2 with storage djzc444:map_djzc b_point
function djzc444:option/test_tool/tool_storage2 with storage djzc444:map_djzc c_point
function djzc444:option/test_tool/tool_storage2 with storage djzc444:map_djzc d_point
function djzc444:option/test_tool/tool_storage2 with storage djzc444:map_djzc airport_ct
function djzc444:option/test_tool/tool_storage2 with storage djzc444:map_djzc airport_t