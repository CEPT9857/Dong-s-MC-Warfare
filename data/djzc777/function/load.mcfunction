# [djzc777] 冬战新手教程命名空间加载提示
scoreboard objectives add djzc777.tutorial dummy {"translate":"djzc777.scoreboard.tutorial","fallback":"教程阶段"}
tellraw @a [{text:"[djzc777] ",color:"aqua"},{"translate":"djzc777.load.msg","fallback":"冬季战场-新手教程系统加载成功！","color":"green"}]
