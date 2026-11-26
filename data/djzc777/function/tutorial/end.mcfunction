#填写分数，表示结束
execute as @s run scoreboard players set @s djzc.tutorial -1
#调整出生点，并传送到配装处
execute if entity @s[team=T] run spawnpoint @s -397 30 -809
execute if entity @s[team=CT] run spawnpoint @s -405 30 -809
execute if entity @s[team=T] run tp @s -397 30 -809
execute if entity @s[team=CT] run tp @s -405 30 -809
#点此开一局
execute as @s run tellraw @s [{translate:"djzc777.tutorial.end.complete",fallback:"点此准备开一局",color:"red",hover_event:{action:"show_text",value:{translate:"djzc.msg.play_again.desc",fallback:"进入准备状态"}},click_event:{action:"run_command",command:"trigger djzc.prepare set 1"}}]