execute if score game djzc.gameflow matches 0 as @a unless score @s djzc.map matches 0 run function djzc888:game_map_selection
execute if score game djzc.gameflow matches 1 as @a unless score @s djzc.map matches 0 run function djzc444:option/no_map
#基础教程地图（map=2）的每 tick 教程检测
execute if score map djzc.map matches 2 run function djzc888:jc_basic/unique_tick
