# 目标盾牌：默认 tv；非和谐且 CT 非 scj 用北极星；非和谐 T 用普通
data modify storage djzc444:armor_sync modifier set value "djzc444:shield_tv"
execute if score harmony djzc.option matches 0 if entity @s[team=CT] unless entity @s[tag=scj] run data modify storage djzc444:armor_sync modifier set value "djzc444:shield_ct"
execute if score harmony djzc.option matches 0 if entity @s[team=T] run data modify storage djzc444:armor_sync modifier set value "djzc444:shield_t"
