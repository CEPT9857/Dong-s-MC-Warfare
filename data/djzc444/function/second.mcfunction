#每秒执行一次的命令
kill @e[type=minecraft:item]
#清理掉落物

#把时间塞进命令存储，在对话框里可以调用
execute store result storage djzc:time minute int 1 run scoreboard players get 分 djzc.time
execute store result storage djzc:time second int 1 run scoreboard players get 秒 djzc.time
#时间的存储
execute store result storage djzc:type_manage minute int 1 run scoreboard players get 分 djzc.time
execute store result storage djzc:type_manage second int 1 run scoreboard players get 秒 djzc.time
#兵种管理系统的存储

#机场补给系统
execute as @a run function djzc444:points/airport_x with storage djzc:map airport_ct
execute as @a run function djzc444:points/airport_x with storage djzc:map airport_t