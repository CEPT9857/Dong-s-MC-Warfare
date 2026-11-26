#进入配装教学：清教程 trigger + 传送到配装处 + 推进阶段 + 拉起成员用书说明页
#注意：advance 内含 dialog clear，必须在 dialog show 之前调用，否则新开的 gui1 会被立刻关掉
scoreboard players reset @s djzc.option
tp @s -380 20 -748
function djzc777:tutorial/advance
dialog show @s djzc777:tutorial/tutorial_gui1
