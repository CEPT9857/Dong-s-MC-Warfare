#新手教程的 trigger （djzc.option 100-199 号段）

#100 一键占领A点：占领倒计时归零，交给 x_point 下个 tick 走正常占领流程
execute as @a at @s if score @s djzc.option matches 100 run function djzc777:tutorial/option/a
#101 一键占领B点：同上
execute as @a at @s if score @s djzc.option matches 101 run function djzc777:tutorial/option/b
#102 进攻C点：触发 T 队步话机"进攻C点！"（djzc.tmsg=11）+ 推进阶段
execute as @a at @s if score @s djzc.option matches 102 run function djzc777:tutorial/option/attack_c
#103 进攻D点：触发 T 队步话机"进攻D点！"（djzc.tmsg=12）+ 推进阶段
execute as @a at @s if score @s djzc.option matches 103 run function djzc777:tutorial/option/attack_d
#104 进入配装教学：传送到配装处 + 拉起 tutorial_gui1 + 推进阶段
execute as @a at @s if score @s djzc.option matches 104 run function djzc777:tutorial/option/gui1
#105 无视风险结束教程：调用 djzc777:tutorial/end
execute as @a at @s if score @s djzc.option matches 105 run function djzc777:tutorial/option/finish
#106 启动新手教程
execute as @a at @s if score @s djzc.option matches 106 run function djzc777:tutorial/start
#107 在team_selection选择CT
execute as @a at @s if score @s djzc.option matches 107 run function djzc777:tutorial/option/join_ct
#108 在team_selection选择T
execute as @a at @s if score @s djzc.option matches 108 run function djzc777:tutorial/option/join_t