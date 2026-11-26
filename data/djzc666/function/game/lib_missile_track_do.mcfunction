# 导弹制导模式分发器，根据 missile_mode djzc.option 分值选择制导方式：
#   0        = TP瞬移制导（旧版）
#   1（默认）= 向量法Motion制导（更加摩登）
# @s = 导弹实体，执行上下文已通过 facing entity 朝向目标

# 模式1（默认）：向量法制导
execute if score missile_mode djzc.option matches 1 run return run function djzc666:game/lib_missile_track_calc

# 模式0：TP瞬移制导
# 空对地导弹——保留下滑分量 ^ ^-0.1 ^1.5
execute if entity @s[tag=AG] run tp @s ^ ^-0.1 ^1.5
# 其他导弹（空对空AA、地对空GA）——直飞 ^ ^ ^1.65
execute unless entity @s[tag=AG] run tp @s ^ ^ ^1.65