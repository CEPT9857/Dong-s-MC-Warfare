# [djzc777] 冬战新手教程命名空间加载提示
tellraw @a [{text:"[djzc777] ",color:"aqua"},{"translate":"djzc777.load.msg","fallback":"冬季战场-新手教程系统加载成功","color":"green"}]
#创建教程计分板
#号段：[0,100),基础教程；[100,200),进阶教程
scoreboard objectives add djzc.tutorial dummy {"translate":"djzc.tutorial","fallback":"教程阶段"}