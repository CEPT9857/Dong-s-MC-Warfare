# 接地逸散：执行点已被调用方 positioned 到地面表面上方 0.05 格。
# 八个水平方向铺开 + 一点向上初速，外加一小团普通弥散烟。
# 方块判定只在 lib_fly 里做 1~2 次，这里只负责发粒子。

particle minecraft:campfire_cosy_smoke ~ ~ ~ 1 0.2 0 0.2 0 force
particle minecraft:campfire_cosy_smoke ~ ~ ~ -1 0.2 0 0.2 0 force
particle minecraft:campfire_cosy_smoke ~ ~ ~ 0 0.2 1 0.2 0 force
particle minecraft:campfire_cosy_smoke ~ ~ ~ 0 0.2 -1 0.2 0 force
particle minecraft:campfire_cosy_smoke ~ ~ ~ 0.7 0.2 0.7 0.2 0 force
particle minecraft:campfire_cosy_smoke ~ ~ ~ -0.7 0.2 0.7 0.2 0 force
particle minecraft:campfire_cosy_smoke ~ ~ ~ 0.7 0.2 -0.7 0.2 0 force
particle minecraft:campfire_cosy_smoke ~ ~ ~ -0.7 0.2 -0.7 0.2 0 force
particle minecraft:campfire_cosy_smoke ~ ~ ~ 0.3 0.1 0.3 0.02 6 force
