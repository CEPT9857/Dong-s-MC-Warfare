scoreboard players reset @s djzc.option
scoreboard players set @s djzc.map 0
tellraw @s {translate:"djzc.msg.no_map",fallback:"系统拒绝了你的要求，对局中改地图会出BUG。",color:red}