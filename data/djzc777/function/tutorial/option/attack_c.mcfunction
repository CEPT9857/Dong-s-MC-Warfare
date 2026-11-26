#进攻C点：清教程 trigger + 触发 T 队步话机"进攻C点！"+ 推进阶段
#设置 djzc.tmsg=11，下一 tick 由 game_teammsg 消费，走标准步话机流程（tellraw + 音效）
scoreboard players reset @s djzc.option
scoreboard players set @s djzc.tmsg 11
function djzc777:tutorial/advance
