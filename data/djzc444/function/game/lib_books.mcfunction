execute as @s[team=T,predicate=djzc444:select_msg] run dialog show @s djzc444:tmsg
execute as @s[team=CT,predicate=djzc444:select_msg] run dialog show @s djzc444:ctmsg
#检测书的标签,展示步话机
execute as @s[predicate=djzc444:select_userbook] run function djzc444:dialog/user_dialog
#检测书的标签，展示成员用书
execute as @s[predicate=djzc444:select_opbook] run function djzc444:dialog/op_dialog
#检测书的标签，展示成员用书
scoreboard players reset @s djzc.r_click7
#重置分数