#填写分数，表示结束
execute as @s run scoreboard players set @s djzc.tutorial -1
#修改地图到冬季战场，防止有人在新手教程结束后直接在新手教程地图开局
scoreboard players set map djzc.map 1
#拉起队伍选择对话框
execute as @s run dialog show @s djzc444:team_selection
#点此开一局
execute as @s run tellraw @s [{translate:"djzc777.tutorial.end.complete",fallback:"点此准备开一局",color:"red",hover_event:{action:"show_text",value:{translate:"djzc.msg.play_again.desc",fallback:"进入准备状态"}},click_event:{action:"run_command",command:"trigger djzc.prepare set 1"}}]