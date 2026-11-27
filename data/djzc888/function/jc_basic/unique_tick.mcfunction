#教程-基础教程特有，且需要高频检测的内容
#按 djzc.tutorial 阶段检测玩家首次进入点位，显示对应新手教程 dialog
#阶段：1=等A点 3=等B点；坐标硬编码自 jc_basic 地图元数据，省去宏函数调用
#C点启动器激活/C点开放占领/D点占领 相关触发在 unique.mcfunction 处理

#A/B点对话框平等：阶段1到3都可触发，tag 记录已看过的页，顺序自由且不重复弹
#子函数内一次性弹窗+打标记+阶段+1，避免同 tick 内条件被前一条命令改掉
#进入A点（未看过A页）
execute as @a[x=-424,y=41,z=-724,dx=4,dy=2,dz=-4,tag=!tutorial_a_seen] if score @s djzc.tutorial matches 1..3 run function djzc777:tutorial/show_a
#进入B点（未看过B页）
execute as @a[x=-399,y=41,z=-744,dx=4,dy=2,dz=-4,tag=!tutorial_b_seen] if score @s djzc.tutorial matches 1..3 run function djzc777:tutorial/show_b

#未同时占领A/B点前（教程阶段1-4），低处区域禁止探索
execute as @a[predicate=djzc444:height_under40] if score @s djzc.tutorial matches 1..4 run tellraw @s {"translate":"djzc.msg.tutorial.area_locked","fallback":"前面的区域，占点以后再来探索吧！","color":"yellow"}
execute as @a[predicate=djzc444:height_under40] if score @s djzc.tutorial matches 1..4 run tp @s -434 41 -709 -505 0

#离开靶场出口（x=-388..-386, y=19, z=-749..-751）：任意玩家进入弹出 tutorial_end
#弹出后把 djzc.tutorial 置为 -2；阶段 -2 的玩家不再触发，规避每 tick 重复弹窗
execute as @a[x=-388,y=19,z=-749,dx=2,dy=1,dz=-2] unless score @s djzc.tutorial matches -2 run dialog show @s djzc777:tutorial/tutorial_end
execute as @a[x=-388,y=19,z=-749,dx=2,dy=1,dz=-2] unless score @s djzc.tutorial matches -2 run scoreboard players set @s djzc.tutorial -2

#等待占领D点时滚动提示（阶段9、T队、人在D点区域内）
#计时挂在 djzc.time2 的虚拟玩家上，全局每 tick 只走一次，不受在场人数影响
scoreboard players add d_tip djzc.time2 1
execute if score d_tip djzc.time2 matches 1001 run scoreboard players set d_tip djzc.time2 0
execute as @a[x=-424,y=18,z=-759,dx=6,dy=2,dz=-6,team=T] if score @s djzc.tutorial matches 9 run function djzc777:tutorial/d_wait