#雷枪引爆入口（由 lib_rocket_fire 调用）
#@s = 发射者（玩家）—— 必须保持为玩家，爆炸函数靠这个上下文获得击杀归属
#做法：只把爆心标记当作「坐标来源」，把 x/y/z 读进宏来源 storage；
#      给发射者打临时标签（供爆炸函数做自身豁免），再以发射者身份调用爆炸函数
#注意：不要把标记变成执行者（as @e[tag=ltjd_boom] run function），否则爆炸特效与音效会一并消失（实测过）

#从爆心标记取出坐标，写进宏来源 storage
execute as @e[tag=ltjd_boom,limit=1,sort=nearest] run data modify storage djzc444:rocket x set from entity @s Pos[0]
execute as @e[tag=ltjd_boom,limit=1,sort=nearest] run data modify storage djzc444:rocket y set from entity @s Pos[1]
execute as @e[tag=ltjd_boom,limit=1,sort=nearest] run data modify storage djzc444:rocket z set from entity @s Pos[2]

#给发射者打临时标签，供爆炸函数用 tag=! 排除自身（/damage 不豁免自身目标）
tag @s add djzc.rocket_caster

#以发射者身份引爆：击杀归属由函数上下文自带，队友由 /damage 自动豁免
execute if data storage djzc444:rocket x run function djzc444:game/lib_rocket_boom with storage djzc444:rocket