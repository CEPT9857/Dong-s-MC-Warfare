#一键三连航空版 垂直机动效果
execute as @s run advancement grant @s only djzc444:fight/wea_fly
execute as @s run effect give @s minecraft:levitation 1 2 true
execute as @s run effect give @s minecraft:slow_falling 1 1 true

#音效
execute at @s run playsound entity.creeper.primed

#特效 俯角 70°/初速 0.35；近地阈值 2 格。
#四束斜向下 cloud：yaw 跟随视角，pitch 固定 70°，count=0 定向发射
#原理参见Feature 2025年11月刊 https://vanillalibrary.mcfpp.top/datapack-index/feature/archive/202511/5/content.html，引用日期：2026年11月15日
execute at @s positioned ~ ~0.9 ~ rotated ~45 70 positioned ^ ^ ^100000000 run particle minecraft:cloud ^ ^ ^-100000000 ^ ^ ^ 0.0000000035 0 force
execute at @s positioned ~ ~0.9 ~ rotated ~135 70 positioned ^ ^ ^100000000 run particle minecraft:cloud ^ ^ ^-100000000 ^ ^ ^ 0.0000000035 0 force
execute at @s positioned ~ ~0.9 ~ rotated ~225 70 positioned ^ ^ ^100000000 run particle minecraft:cloud ^ ^ ^-100000000 ^ ^ ^ 0.0000000035 0 force
execute at @s positioned ~ ~0.9 ~ rotated ~315 70 positioned ^ ^ ^100000000 run particle minecraft:cloud ^ ^ ^-100000000 ^ ^ ^ 0.0000000035 0 force

#接地烟：脚下 1~2 层，命中最近的地面就把执行点移到表面上方 0.05 格。
#方块判定只在这里做 1~2 次，9 条粒子交给 game/ground_spread；return run 短路掉后面的层，不会重复生成。
execute at @s unless block ~ ~-1 ~ #minecraft:replaceable positioned ~ ~0.05 ~ run return run function djzc444:game/lib_fly_ground_spread
execute at @s if block ~ ~-1 ~ #minecraft:replaceable unless block ~ ~-2 ~ #minecraft:replaceable positioned ~ ~-0.95 ~ run return run function djzc444:game/lib_fly_ground_spread