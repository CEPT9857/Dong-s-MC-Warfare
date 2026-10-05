#在射线检测结果位置生成雷枪爆心标记
#宏函数：坐标来自 storage djzc555:raycast result，发射者 UUID 来自 storage djzc444:rocket caster
#用法：execute at <发射者> run function djzc444:game/lib_rocket_spawn_mark with storage djzc555:raycast result
#注意：marker 没有 Owner 字段（Owner 只属于可驯服生物/抛射物），归属只能放在自定义键 caster

$summon minecraft:marker $(x) $(y) $(z) {Tags:["ltjd_boom"]}
data modify entity @e[tag=ltjd_boom,limit=1,sort=nearest] data.caster set from storage djzc444:rocket caster