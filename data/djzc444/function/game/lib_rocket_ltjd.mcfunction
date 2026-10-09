#雷枪：诡异菌钓竿右键 → 射线检测 → 落点立即爆炸
#@a = 本 tick 使用过诡异菌钓竿的玩家
#全图可用
#与轰炸指示器使用不同的计分板（djzc.r_click6 vs djzc.r_click5）与不同的爆炸标签（ltjd_boom vs mark3），互不干扰

#没收耐久耗尽的雷枪（16发打空，与轰炸指示器类似）
execute as @a if items entity @s weapon.mainhand minecraft:warped_fungus_on_a_stick[minecraft:damage~{damage:16}] run item replace entity @s weapon.mainhand with air
execute as @a if items entity @s weapon.offhand minecraft:warped_fungus_on_a_stick[minecraft:damage~{damage:16}] run item replace entity @s weapon.offhand with air

#非debug与debug模式均全图可用，故不需要 boom_area 谓词判定
execute as @a[predicate=djzc444:select_rocket_ltjd,scores={djzc.r_click6=1..}] at @s run function djzc444:game/lib_rocket_single

#兜底清理未被消耗的分值
execute as @a[scores={djzc.r_click6=1..}] run scoreboard players set @s djzc.r_click6 0
