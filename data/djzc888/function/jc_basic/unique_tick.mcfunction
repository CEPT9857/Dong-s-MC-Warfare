#教程-基础教程特有，且需要高频检测的内容
#按 djzc.tutorial 阶段检测玩家首次进入点位，显示对应新手教程 dialog
#阶段：1=等A点 3=等B点；坐标硬编码自 jc_basic 地图元数据，省去宏函数调用
#C点启动器激活/C点开放占领/D点占领 相关触发在 unique.mcfunction 处理

#首次进入A点（阶段1）
execute as @a[x=-424,y=41,z=-724,dx=4,dy=2,dz=-4] if score @s djzc.tutorial matches 1 run dialog show @s djzc777:tutorial/tutorial_a
execute as @a[x=-424,y=41,z=-724,dx=4,dy=2,dz=-4] if score @s djzc.tutorial matches 1 run scoreboard players set @s djzc.tutorial 2
#首次进入B点（阶段3）
execute as @a[x=-399,y=41,z=-744,dx=4,dy=2,dz=-4] if score @s djzc.tutorial matches 3 run dialog show @s djzc777:tutorial/tutorial_b
execute as @a[x=-399,y=41,z=-744,dx=4,dy=2,dz=-4] if score @s djzc.tutorial matches 3 run scoreboard players set @s djzc.tutorial 4

#离开靶场出口（x=-388..-386, y=19, z=-749..-751）：任意玩家进入弹出 tutorial_end
#弹出后把 djzc.tutorial 置为 -2；阶段 -2 的玩家不再触发，规避每 tick 重复弹窗
#重播时 start 会把阶段重置为 1，故下次经过出口仍可再次触发
execute as @a[x=-388,y=19,z=-749,dx=2,dy=1,dz=-2] unless score @s djzc.tutorial matches -2 run dialog show @s djzc777:tutorial/tutorial_end
execute as @a[x=-388,y=19,z=-749,dx=2,dy=1,dz=-2] unless score @s djzc.tutorial matches -2 run scoreboard players set @s djzc.tutorial -2