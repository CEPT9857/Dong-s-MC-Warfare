#雷枪爆炸求值（由 lib_rocket_detonate 以 with storage 调用）
#@s = 发射者本人（玩家）：由调用上下文自然携带，归属与友军豁免都靠它
#  · 击杀归属：函数以发射者身份运行，上下文自带伤害来源，击杀时正常显示击杀者（无需显式写 by）
#  · 友军豁免：/damage 会自动进行友伤判定，同队成员天然不掉血，故不需要 team=! 选择器
#  · 自身豁免：发射者由 lib_rocket_fire 打上 djzc.rocket_caster 标签，用 tag=! 排除
#    （/damage 对自身目标不做豁免，必须显式排除）
#$(x)/$(y)/$(z) 为爆心坐标，宏来源为 storage djzc444:rocket
#伤害半径8米，中心72，伤害 = 72 × (1 - 距离/8)，0.5米一档，每档以档位中点代入后取整
#坐标一律用 positioned 宏参数给出（不能用 @s 的坐标，因为 @s 是发射者而不是爆心）

$execute positioned $(x) $(y) $(z) as @e[distance=..0.5,tag=!djzc.rocket_caster] run damage @s 70 minecraft:explosion
$execute positioned $(x) $(y) $(z) as @e[distance=0.5..1.0,tag=!djzc.rocket_caster] run damage @s 65 minecraft:explosion
$execute positioned $(x) $(y) $(z) as @e[distance=1.0..1.5,tag=!djzc.rocket_caster] run damage @s 61 minecraft:explosion
$execute positioned $(x) $(y) $(z) as @e[distance=1.5..2.0,tag=!djzc.rocket_caster] run damage @s 56 minecraft:explosion
$execute positioned $(x) $(y) $(z) as @e[distance=2.0..2.5,tag=!djzc.rocket_caster] run damage @s 52 minecraft:explosion
$execute positioned $(x) $(y) $(z) as @e[distance=2.5..3.0,tag=!djzc.rocket_caster] run damage @s 47 minecraft:explosion
$execute positioned $(x) $(y) $(z) as @e[distance=3.0..3.5,tag=!djzc.rocket_caster] run damage @s 43 minecraft:explosion
$execute positioned $(x) $(y) $(z) as @e[distance=3.5..4.0,tag=!djzc.rocket_caster] run damage @s 38 minecraft:explosion
$execute positioned $(x) $(y) $(z) as @e[distance=4.0..4.5,tag=!djzc.rocket_caster] run damage @s 34 minecraft:explosion
$execute positioned $(x) $(y) $(z) as @e[distance=4.5..5.0,tag=!djzc.rocket_caster] run damage @s 29 minecraft:explosion
$execute positioned $(x) $(y) $(z) as @e[distance=5.0..5.5,tag=!djzc.rocket_caster] run damage @s 25 minecraft:explosion
$execute positioned $(x) $(y) $(z) as @e[distance=5.5..6.0,tag=!djzc.rocket_caster] run damage @s 20 minecraft:explosion
$execute positioned $(x) $(y) $(z) as @e[distance=6.0..6.5,tag=!djzc.rocket_caster] run damage @s 16 minecraft:explosion
$execute positioned $(x) $(y) $(z) as @e[distance=6.5..7.0,tag=!djzc.rocket_caster] run damage @s 11 minecraft:explosion
$execute positioned $(x) $(y) $(z) as @e[distance=7.0..7.5,tag=!djzc.rocket_caster] run damage @s 7 minecraft:explosion
$execute positioned $(x) $(y) $(z) as @e[distance=7.5..8.0,tag=!djzc.rocket_caster] run damage @s 2 minecraft:explosion

#特效（定位到爆心）
$execute positioned $(x) $(y) $(z) run particle minecraft:campfire_cosy_smoke ~ ~ ~ 0.1 0.1 0.1 0.5 300 force

#音效
$execute positioned $(x) $(y) $(z) run playsound entity.generic.explode ambient @a ~ ~ ~ 1.0 1.0 0.1
$execute positioned $(x) $(y) $(z) run playsound minecraft:block.gravel.break ambient @a