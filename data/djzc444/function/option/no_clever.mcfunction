scoreboard players reset @s djzc.option
tellraw @s {translate:"djzc.msg.no_clever",fallback:"不要想着用我们的神奇喵喵工具一键胜利喵！捅似你喵！捅似你喵！",color:red}
#捅你喵！
damage @s 75
#捅似了就不捅了
execute if score @s djzc.count_die1 matches 1 run tellraw @s {translate:"djzc.msg.no_clever_after",fallback:"捅似你了喵！下次不要再这么做了喵！",color:red}
execute if score @s djzc.count_die1 matches 1 run schedule clear djzc444:option/no_clever