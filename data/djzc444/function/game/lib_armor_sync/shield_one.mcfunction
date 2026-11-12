# 单个玩家：先按自己的队伍/兵种/和谐模式定目标，再复用 all_of_player 扫全身
function djzc444:game/lib_armor_sync/shield_target
data modify storage djzc444:armor_sync filter set value "minecraft:shield"
function djzc444:game/lib_armor_sync/all_of_player with storage djzc444:armor_sync
