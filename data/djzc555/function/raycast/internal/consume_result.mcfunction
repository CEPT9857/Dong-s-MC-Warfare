#按 uid 取出并删除一条结果槽，取到的内容放在 storage djzc555:raycast tmp.slot
#用法：
#  data modify storage djzc555:raycast tmp.uid set value <uid>
#  function djzc555:raycast/internal/consume_result with storage djzc555:raycast tmp
#调用后 tmp.slot 就是那条结果，槽已删除；槽不存在时 tmp.slot 为空
#只在本条射线需要跨 tick 或事后查询时用，ray_keep 没开的话槽里什么都没有
data modify storage djzc555:raycast tmp.slot set value {}
$execute if data storage djzc555:raycast results.u$(uid) run data modify storage djzc555:raycast tmp.slot set from storage djzc555:raycast results.u$(uid)
$execute if data storage djzc555:raycast results.u$(uid) run data remove storage djzc555:raycast results.u$(uid)
