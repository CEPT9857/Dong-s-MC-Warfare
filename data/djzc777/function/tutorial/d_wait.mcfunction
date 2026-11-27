#D点占领等待期间的滚动提示
#由 unique_tick 每 tick 调用，计时挂在 djzc.time2 的虚拟玩家 d_tip 上
#每100刻（5秒）换一条，10条覆盖约50秒
execute if score d_tip djzc.time2 matches 1 run title @s actionbar {translate:"djzc.dialog.tutorial_d.wait1",fallback:"为了防止你在进攻D点的时候没事干，我们随便写了一些东西！",color:"yellow"}
execute if score d_tip djzc.time2 matches 101 run title @s actionbar {translate:"djzc.dialog.tutorial_d.wait2",fallback:"按G打开成员用书，里面写着兵种和步话机的用法。",color:"yellow"}
execute if score d_tip djzc.time2 matches 201 run title @s actionbar {translate:"djzc.dialog.tutorial_d.wait3",fallback:"步话机能给队友发快捷消息，比如「进攻D点！」。",color:"yellow"}
execute if score d_tip djzc.time2 matches 301 run title @s actionbar {translate:"djzc.dialog.tutorial_d.wait4",fallback:"占下地图上所有点位，T队才算赢。",color:"yellow"}
execute if score d_tip djzc.time2 matches 401 run title @s actionbar {translate:"djzc.dialog.tutorial_d.wait5",fallback:"占领完成后，去靶场试试刚换的装备。",color:"yellow"}
execute if score d_tip djzc.time2 matches 501 run title @s actionbar {translate:"djzc.dialog.tutorial_d.wait6",fallback:"正在占领D点。趁这几秒看看四周，熟悉一下地形。",color:"yellow"}
execute if score d_tip djzc.time2 matches 601 run title @s actionbar {translate:"djzc.dialog.tutorial_d.wait7",fallback:"金胡萝卜，金胡萝卜，Au Au拔不动！",color:"yellow"}
execute if score d_tip djzc.time2 matches 701 run title @s actionbar {translate:"djzc.dialog.tutorial_d.wait8",fallback:"敌人在点里会拖慢占领，先把人清掉再站着等。",color:"yellow"}
execute if score d_tip djzc.time2 matches 801 run title @s actionbar {translate:"djzc.dialog.tutorial_d.wait9",fallback:"按住Shift能悄悄走，脚步声会小很多。",color:"yellow"}
execute if score d_tip djzc.time2 matches 901 run title @s actionbar {translate:"djzc.dialog.tutorial_d.wait10",fallback:"打不过就撤，活着回来还能继续占点。",color:"yellow"}
