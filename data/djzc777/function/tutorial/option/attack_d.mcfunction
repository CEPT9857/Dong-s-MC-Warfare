#进攻D点：清教程 trigger + 触发 T 队步话机"进攻D点！"+ 一键占领C点 + 推进阶段
#设置 djzc.tmsg=12，下一 tick 由 game_teammsg 消费，走标准步话机流程（tellraw + 音效）
scoreboard players reset @s djzc.option
scoreboard players set @s djzc.tmsg 12
#一键占领C点：T_SC 倒计时归零，交给每 tick 的 x_point(c_point) 走正常占领流程
scoreboard players set T_SC djzc.time3 0
function djzc777:tutorial/advance
