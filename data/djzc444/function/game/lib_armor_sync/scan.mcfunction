# 宏循环，container.$(slot) 从 0 走到 35
$execute if items entity @s container.$(slot) $(filter) run item modify entity @s container.$(slot) $(modifier)
scoreboard players add #slot djzc444.armor_slot 1
execute store result storage djzc444:armor_sync slot int 1 run scoreboard players get #slot djzc444.armor_slot
execute if score #slot djzc444.armor_slot matches ..35 run function djzc444:game/lib_armor_sync/scan with storage djzc444:armor_sync
