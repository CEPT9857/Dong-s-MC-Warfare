#地图特殊事件
$function djzc888:$(name)/unique
execute if score D djzc.gameflow matches 2 run function djzc444:game/end_t
#T胜利
execute if score 分 djzc.time < 0 djzc.time3 run function djzc444:game/end_ct
#CT胜利