#设定地图代码
execute as @a at @s if score @s djzc.map matches 1 run scoreboard players set map djzc.map 1
execute as @a at @s if score @s djzc.map matches 2 run scoreboard players set map djzc.map 2
#重置trigger，防止BUG
scoreboard players reset @s djzc.map
#联动地图切换器
function djzc888:map_swich