formatList = function() {
    return {
        "func_list":[
            {
                "id": "touch.on",
                "name": "touch.on(id, x, y)",
                "args": [
					{
						"type":"pos",
						"title":"请选择需要点击的点"
					}
				]
            },
            {
                "id": "touch.move",
                "name": "touch.move(id, x, y)",
                "args": [
					{
						"type":"pos",
						"title":"请选择需要移动到的点"
					}
				]
            },
            {
                "id": "touch.swipe",
                "name": "touch.swipe(x0, y0, x1, y1)",
                "args": [
					{
						"type":"pos",
						"title":"请选择滑动的起始位置"
					},
					{
						"type":"pos",
						"title":"请选择滑动的终止位置"
					}
				]
            },
            {
                "id": "app.run",
                "name": "app.run(bid)",
                "args": [
					{
						"type":"bid",
						"title":"请选择需要启动的应用"
					}
				]
            },
            {
                "id": "screen.find_color",
                "name": "screen.find_color(multicolor, sim, ...)",
                "args": [
					{
						"type":"mpos",
						"title":"选择多个点"
					}
				]
            },
            {
                "id": "key.down",
                "name": "key.down(KEY)",
                "args": [
					{
						"type":"key",
						"title":"选择需要按下的按键"
					}
				]
            },
            {
                "id": "key.up",
                "name": "key.up(KEY)",
                "args": [
					{
						"type":"key",
						"title":"选择需要抬起的按键"
					}
				]
            }
        ],
        "snippet_list":[
            {
                "name":"local ... = ...",
                "content":"local  =  "
            },
            {
                "name":"do ... end",
                "content":"do\n\nend"
            },
            {
                "name":"if ... then ... end",
                "content":"if  then\n\nend"
            }
        ],
        "key_list":[
            {
                "id": "HOMEBUTTON",
                "name": "HOME 键"
            },
            {
                "id": "VOLUMEUP",
                "name": "音量 + 键"
            },
            {
                "id": "VOLUMEDOWN",
                "name": "音量 - 键"
            },
            {
                "id": "LOCK",
                "name": "电源键"
            }
        ]
    }
}

customFunction = function(funcId, pos_color_list, bid, keyid) {
    switch(funcId) {
        case "touch.on":
            return "touch.on(0, " + pos_color_list[0].x + ", " + pos_color_list[0].y + ")";
        case "touch.move":
            return "touch.move(0, " + pos_color_list[0].x + ", " + pos_color_list[0].y + ")";
        case "app.run":
            return "app.run(\"" + bid + "\")";
        case "screen.find_color":
			var ret = "x, y = screen.find_color({\n";
			for (var i=0; i<cars.length; i++) {
				ret += "\t{" + pos_color_list[i].x + ", " + pos_color_list[i].y + ", " + pos_color_list[i].color + "},\n";
			}
			ret += "}, 90)";
            return ret;
        case "key.down":
			var ret = "key.down(\"" + keyid + "\")";
            return ret;
        case "key.up":
			var ret = "key.up(\"" + keyid + "\")";
            return ret;
        case "touch.swipe":
			if (pos_color_list[1]) {
				var ret = "touch.swipe(" + pos_color_list[0].x + ", " + pos_color_list[0].y + ", " + pos_color_list[1].x + ", " + pos_color_list[1].y + ")";
				return ret;
			} else {
				var ret = "touch.swipe(" + pos_color_list[0].x + ", " + pos_color_list[0].y + ", 0, 0)";
				return ret;
			}
    }
}