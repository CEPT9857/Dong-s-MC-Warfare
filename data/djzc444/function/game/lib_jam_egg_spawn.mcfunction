#干扰弹鸡群生成 - 向上下左右前后六个方向弹出
#上
execute if entity @s[tag=AF] run summon chicken ^ ^1 ^ {Tags:["jam_decoy","AF"],PortalCooldown:100,Motion:[0.0,0.5,0.0],CustomName:{translate:"djzc.jam_chicken","fallback":"干扰弹"}}
execute if entity @s[tag=GF] run summon chicken ^ ^1 ^ {Tags:["jam_decoy","GF"],PortalCooldown:100,Motion:[0.0,0.5,0.0],CustomName:{translate:"djzc.jam_chicken","fallback":"干扰弹"}}
#下（仅在空中时弹出，避免地面玩家把鸡弹进方块）
execute if predicate djzc444:no_on_ground if entity @s[tag=AF] run summon chicken ^ ^-1 ^ {Tags:["jam_decoy","AF"],PortalCooldown:100,Motion:[0.0,-0.5,0.0],CustomName:{translate:"djzc.jam_chicken","fallback":"干扰弹"}}
execute if predicate djzc444:no_on_ground if entity @s[tag=GF] run summon chicken ^ ^-1 ^ {Tags:["jam_decoy","GF"],PortalCooldown:100,Motion:[0.0,-0.5,0.0],CustomName:{translate:"djzc.jam_chicken","fallback":"干扰弹"}}
#左
execute if entity @s[tag=AF] run summon chicken ^-1 ^ ^ {Tags:["jam_decoy","AF"],PortalCooldown:100,Motion:[-0.5,0.0,0.0],CustomName:{translate:"djzc.jam_chicken","fallback":"干扰弹"}}
execute if entity @s[tag=GF] run summon chicken ^-1 ^ ^ {Tags:["jam_decoy","GF"],PortalCooldown:100,Motion:[-0.5,0.0,0.0],CustomName:{translate:"djzc.jam_chicken","fallback":"干扰弹"}}
#右
execute if entity @s[tag=AF] run summon chicken ^1 ^ ^ {Tags:["jam_decoy","AF"],PortalCooldown:100,Motion:[0.5,0.0,0.0],CustomName:{translate:"djzc.jam_chicken","fallback":"干扰弹"}}
execute if entity @s[tag=GF] run summon chicken ^1 ^ ^ {Tags:["jam_decoy","GF"],PortalCooldown:100,Motion:[0.5,0.0,0.0],CustomName:{translate:"djzc.jam_chicken","fallback":"干扰弹"}}
#前（仅在地面时弹出，避免空中玩家向前撞到自己的鸡）
execute if predicate djzc444:is_on_ground if entity @s[tag=AF] run summon chicken ^ ^ ^1 {Tags:["jam_decoy","AF"],PortalCooldown:100,Motion:[0.0,0.0,0.5],CustomName:{translate:"djzc.jam_chicken","fallback":"干扰弹"}}
execute if predicate djzc444:is_on_ground if entity @s[tag=GF] run summon chicken ^ ^ ^1 {Tags:["jam_decoy","GF"],PortalCooldown:100,Motion:[0.0,0.0,0.5],CustomName:{translate:"djzc.jam_chicken","fallback":"干扰弹"}}
#后
execute if entity @s[tag=AF] run summon chicken ^ ^ ^-1 {Tags:["jam_decoy","AF"],PortalCooldown:100,Motion:[0.0,0.0,-0.5],CustomName:{translate:"djzc.jam_chicken","fallback":"干扰弹"}}
execute if entity @s[tag=GF] run summon chicken ^ ^ ^-1 {Tags:["jam_decoy","GF"],PortalCooldown:100,Motion:[0.0,0.0,-0.5],CustomName:{translate:"djzc.jam_chicken","fallback":"干扰弹"}}