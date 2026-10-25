#陆战-冬季战场特有的内容

#彩蛋：在地图map_djzc中，通过清除红石块联动地图
#A点：setblock -395 27 -768 minecraft:air
#B点：setblock -398 27 -768 minecraft:air
#C点：setblock -395 27 -754 minecraft:air
#D点：setblock -398 27 -754 minecraft:air

#彩蛋：在地图map_djzc中，通过放红石块联动地图
#A点：setblock -395 27 -768 minecraft:redstone_block
#B点：setblock -398 27 -768 minecraft:redstone_block
#C点：setblock -395 27 -754 minecraft:redstone_block
#D点：setblock -398 27 -754 minecraft:redstone_block

#开局时（A=0，B=0），被flow_begin调用
#填平dz_djzc D点大坑
execute if score A djzc.gameflow matches 0 if score B djzc.gameflow matches 0 run fill -467 62 -764 -469 62 -758 netherite_block

#C点启动器阶段（B+=1），被flow_a_b调用
#execute if score B+ djzc.gameflow matches 1 run say B+

#C点激活（C123=3），被point/c_starter调用
#execute if score C123 djzc.gameflow matches 3 run say C123

#D点启动器阶段（C+=1，D123=0），被flow_c_d调用
#execute if score C+ djzc.gameflow matches 1 if score D123 djzc.gameflow matches 0 run say C+

#D点激活（D123=3），被point/d_starter调用
#打开D点盖子
execute if score D123 djzc.gameflow matches 3 run fill -467 62 -764 -469 62 -758 air

#结束阶段（D=2），被flow_end调用
#execute if score D djzc.gameflow matches 2 run say end

#A点被T占领（A=1）
execute if score A djzc.gameflow matches 1 run setblock -395 27 -768 minecraft:redstone_block
#A点被CT占领（A=0）
execute if score A djzc.gameflow matches 0 run setblock -395 27 -768 minecraft:air

#B点被T占领（B=1）
execute if score B djzc.gameflow matches 1 run setblock -398 27 -768 minecraft:redstone_block
#B点被CT占领（B=0）
execute if score B djzc.gameflow matches 0 run setblock -398 27 -768 minecraft:air

#C点被T占领（C=2）
execute if score C djzc.gameflow matches 2 run setblock -395 27 -754 minecraft:redstone_block
#C点被CT占领（C=0）
execute if score C djzc.gameflow matches 0 run setblock -395 27 -754 minecraft:air

#D点被T占领（D=2）
execute if score D djzc.gameflow matches 2 run setblock -398 27 -754 minecraft:redstone_block
#D点被CT占领（D=0）
execute if score D djzc.gameflow matches 0 run setblock -398 27 -754 minecraft:air