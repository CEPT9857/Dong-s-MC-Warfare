#设定地图代码
execute if score @s djzc.map matches 1 run scoreboard players set map djzc.map 1
execute if score @s djzc.map matches 2 run scoreboard players set map djzc.map 2
#重置trigger，防止BUG
#只要没有叫"map"的玩家在服务器中，就不会干扰到地图选择
#后续考虑一下给所有计分板变量用“.”做前缀，保护起来
scoreboard players set @a djzc.map 0
#联动地图切换器
function djzc888:map_swich