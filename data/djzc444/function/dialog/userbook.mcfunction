 $dialog show @s \
 {\
    type:"multi_action",\
    "pause": false,\
    title:[\
    {\
    "translate": "djzc.dialog.userbook",\
    "fallback":"冬战成员用书",\
    "hover_event": {\
    "action": "show_text",\
    "value": {\
        "translate": "djzc.dialog.author_make",\
        "fallback": "%1$s 制作",\
        "with":[\
            {\
            "translate":"djzc.dialog.author1",\
            "fallback":"冬战制作组"\
            }\
        ]\
    }\
    }\
    }\
    ],\
    body:[\
    {\
    "type":"plain_message",\
    "width": 500,\
    "contents":[\
        {\
            "translate": "djzc.dialog.wiki",\
            "fallback": "冬季战场百科全书",\
            "color":"green",\
            "hover_event": {\
                "action": "show_text",\
                "value": {\
                    "translate": "djzc.dialog.wiki.desc",\
                    "fallback": "正在不断更新，欢迎进来看看"\
                }\
            },\
            "click_event": {\
                "action": "show_dialog",\
                "dialog": "djzc444:wiki/wiki_notice"\
            }\
        },\
        {\
            "text": " | ",\
            "color": "white"\
        },\
        {\
            "translate": "djzc.dialog.scoreboard",\
            "fallback": "统计信息",\
            "color":"light_purple",\
            "underlined": true,\
            "click_event": {\
                "action": "run_command",\
                "command":"trigger djzc.option set 8"\
            }\
        },\
        {\
            "text": " | ",\
            "color": "white"\
        },\
        {\
            "translate": "djzc.dialog.map_selection.title",\
            "fallback":"地图选择",\
            "color":"blue",\
            "click_event": {\
                "action": "run_command",\
                "command":"trigger djzc.option set 18"\
            }\
        },\
        {\
            "text": " | ",\
            "color": "white"\
        },\
        {\
            "translate": "djzc.book_opbook",\
            "fallback": "冬战管理用书",\
            "color":"aqua",\
            "click_event": {\
                "action": "run_command",\
                "command":"function djzc444:dialog/op_dialog"\
            }\
        }\
    ]\
    },\
    {\
    type:"plain_message",\
    contents:[\
        {\
            "translate": "djzc.dialog.map",\
            "fallback":"当前地图：%1$s",\
            "with": [\
                {\
                    "translate": "djzc.dialog.wiki.map_$(map_name).title",\
                    "fallback": "未知地图",\
                    "color": "aqua",\
                    "hover_event": {\
                    "action": "show_text",\
                    "value": {\
                    "translate": "djzc.dialog.wiki.map_$(map_name).body1",\
                    "fallback": "未知地图"\
                    }\
                    }\
                }\
            ]\
        },\
        {\
            "text": " | "\
        },\
        {\
            "translate": "djzc.dialog.time",\
            "fallback":"剩余时间："\
        },\
        {\
            "text":"$(minute)"\
        },\
        {\
            "translate": "djzc.dialog.time_minute",\
            "fallback":"分"\
        },\
        {\
            "text":"$(second)"\
        },\
        {\
            "translate": "djzc.dialog.time_second",\
            "fallback":"秒"\
        }\
    ]\
    }\
    ],\
    "columns": 3,\
    "actions": [\
        {\
            "label":{\
                "translate": "djzc.dialog.userbook.join_ct",\
                "fallback": "加入CT",\
                "color":"blue",\
                "underlined": true\
            },\
            "tooltip": {\
                "translate": "djzc.dialog.userbook.join_ct.desc",\
                "fallback": "冬季战场的防守方，阻止T方占领全部战区，坚持到时间结束即获胜。"\
            },\
            "action": {\
                "type": "run_command",\
                "command": "trigger djzc.option set 9"\
            }\
        },\
        {\
            "label":{\
                "translate": "djzc.dialog.userbook.join_t",\
                "fallback": "加入T",\
                "color":"red",\
                "underlined": true\
            },\
            "tooltip": {\
                "translate": "djzc.dialog.userbook.join_t.desc",\
                "fallback": "冬季战场的进攻方，占领全部四个战区（A、B、C、D）即可获胜。"\
            },\
            "action": {\
                "type": "run_command",\
                "command": "trigger djzc.option set 10"\
            }\
        },\
        {\
            "label":{\
                "translate": "djzc.dialog.userbook.type_choose",\
                "fallback": "兵种选择",\
                "color":"gold",\
                "underlined": true\
            },\
            "action": {\
                "type": "run_command",\
                "command": "trigger djzc.option set 11"\
            }\
        },\
        {\
            "label":{\
                "translate": "djzc.dialog.userbook.msg",\
                "fallback": "转到步话机",\
                "color":"gold",\
                "underlined": true\
            },\
            "action": {\
                "type": "run_command",\
                "command": "trigger djzc.option set 12"\
            }\
        },\
        {\
            "label":{\
                "translate": "djzc.dialog.userbook.redeploy",\
                "fallback": "重新部署",\
                "color":"dark_gray"\
            },\
            "tooltip": {\
                "translate": "djzc.dialog.userbook.redeploy.desc",\
                "fallback": "会死。"\
            },\
            "action": {\
                "type": "run_command",\
                "command": "trigger djzc.option set 13"\
            }\
        },\
        {\
            "label":{\
                "translate": "djzc.dialog.userbook.stop_music",\
                "fallback": "中止音乐（仅个人）",\
                "color":"gold"\
            },\
            "action": {\
                "type": "run_command",\
                "command": "trigger djzc.option set 14"\
            }\
        },\
        {\
            "label":{\
                "translate": "djzc.dialog.userbook.to_prepare",\
                "fallback": "准备",\
                "color":"green"\
            },\
            "action": {\
                "type": "run_command",\
                "command": "trigger djzc.prepare set 1"\
            }\
        },\
        {\
            "label":{\
                "translate": "djzc.dialog.userbook.un_prepare",\
                "fallback": "取消准备",\
                "color":"red"\
            },\
            "action": {\
                "type": "run_command",\
                "command": "trigger djzc.prepare set 0"\
            }\
        }\
    ],\
    "exit_action": {\
        "label": {\
            "translate": "djzc.dialog.tp_system",\
            "fallback": "点击访问传送系统"\
        },\
        "action": {\
                "type": "run_command",\
                "command": "trigger djzc.option set 16"\
            }\
     }\
 }