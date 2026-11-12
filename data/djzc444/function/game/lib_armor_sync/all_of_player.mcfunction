# 玩家身上所有能放物品的槽位
# 1.21.11 的 /item modify 只能单槽改，没有 slot_source 注册表，这里是函数遍历
# 参数：filter = 完整物品谓词，modifier = 目标 item_modifier
# 参数放在 storage djzc444:armor_sync，盔甲和盾牌共用这一套

# 背包 + 快捷栏 container.0..35
scoreboard players set #slot djzc444.armor_slot 0
execute store result storage djzc444:armor_sync slot int 1 run scoreboard players get #slot djzc444.armor_slot
function djzc444:game/lib_armor_sync/scan with storage djzc444:armor_sync

# 护甲四格
$execute if items entity @s armor.head $(filter) run item modify entity @s armor.head $(modifier)
$execute if items entity @s armor.chest $(filter) run item modify entity @s armor.chest $(modifier)
$execute if items entity @s armor.legs $(filter) run item modify entity @s armor.legs $(modifier)
$execute if items entity @s armor.feet $(filter) run item modify entity @s armor.feet $(modifier)

# 主手、副手、光标、合成格
$execute if items entity @s weapon.mainhand $(filter) run item modify entity @s weapon.mainhand $(modifier)
$execute if items entity @s weapon.offhand $(filter) run item modify entity @s weapon.offhand $(modifier)
$execute if items entity @s player.cursor $(filter) run item modify entity @s player.cursor $(modifier)
$execute if items entity @s player.crafting.0 $(filter) run item modify entity @s player.crafting.0 $(modifier)
$execute if items entity @s player.crafting.1 $(filter) run item modify entity @s player.crafting.1 $(modifier)
$execute if items entity @s player.crafting.2 $(filter) run item modify entity @s player.crafting.2 $(modifier)
$execute if items entity @s player.crafting.3 $(filter) run item modify entity @s player.crafting.3 $(modifier)

data remove storage djzc444:armor_sync slot
