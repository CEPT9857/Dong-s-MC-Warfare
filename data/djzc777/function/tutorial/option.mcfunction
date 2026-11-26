#新手教程 dialog 按钮的 trigger 消费（djzc.option 100-199 号段）
#每个号段匹配后一次性清 trigger、执行功能、推进阶段，避免清零后条件失效

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
