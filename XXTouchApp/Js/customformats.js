formatList = function() {
    return {
        "func_list":[
            {
                "id": "touch.tap",
                "name": "touch.tap(x, y)",
                "args": [
					{
						"type":"pos",
						"title":"请选择需要点击的点"
					}
				]
            },
            {
                "id": "touch.swipe",
                "name": "touch.on(x, y):move(x1, y1)...",
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
                "id": "screen.ocr_text",
                "name": "screen.ocr_text(left, top, right, bottom)",
                "args": [
					{
						"type":"pos",
						"title":"请选择右上角位置"
					},
					{
						"type":"pos",
						"title":"请选择左下角位置"
					}
				]
            },
            {
                "id": "screen.is_colors",
                "name": "screen.is_colors(multicolor,sim)",
                "args": [
					{
						"type":"mpos",
						"title":"选择多个点"
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
                "id": "key.press",
                "name": "key.press(KEY)",
                "args": [
					{
						"type":"key",
						"title":"选择需要按下的按键"
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
                "id": "app.close",
                "name": "app.close(bid)",
                "args": [
                    {
                        "type":"bid",
                        "title":"请选择需要关闭的应用"
                    }
                ]
            },
            {
                "id": "app.quit",
                "name": "app.quit(bid)",
                "args": [
                    {
                        "type":"bid",
                        "title":"请选择需要退出的应用"
                    }
                ]
            },
            {
                "id": "app.bundle_path",
                "name": "app.bundle_path(bid)",
                "args": [
                    {
                        "type":"bid",
                        "title":"选择应用"
                    }
                ]
            },
            {
                "id": "app.data_path",
                "name": "app.data_path(bid)",
                "args": [
                    {
                        "type":"bid",
                        "title":"选择应用"
                    }
                ]
            },
            {
                "id": "app.is_running",
                "name": "app.is_running(bid)",
                "args": [
                    {
                        "type":"bid",
                        "title":"选择应用"
                    }
                ]
            },
            {
                "id": "app.is_front",
                "name": "app.is_front(bid)",
                "args": [
                    {
                        "type":"bid",
                        "title":"选择应用"
                    }
                ]
            },
            {
                "id": "app.uninstall",
                "name": "app.uninstall(bid)",
                "args": [
                    {
                        "type":"bid",
                        "title":"选择需要卸载应用"
                    }
                ]
            },
            {
                "id": "clear.keychain",
                "name": "clear.keychain(bid)",
                "args": [
                    {
                        "type":"bid",
                        "title":"选择应用"
                    }
                ]
            },
            {
                "id": "clear.app_data",
                "name": "clear.app_data(bid)",
                "args": [
                    {
                        "type":"bid",
                        "title":"选择应用"
                    }
                ]
            }
        ],
        "snippet_list":[
            {
                "name":"for i = 1, 10, 1 do ... end",
                "content":"for i = 1, 10, 1 do\n\nend\n"
            },
            {
                "name":"while (true) do .. end",
                "content":"while (true) do\n\nend\n"
            },
            {
                "name":"repeat ... until (false)",
                "content":"repeat\n\nuntil (false)\n"
            },
            {
                "name":"if ... then ... end",
                "content":"if () then\n\nend\n"
            },
            {
                "name":"sys.msleep(1000)",
                "content":"sys.msleep(1000)\n"
            },
            {
                "name":"touch.tap(x, y)",
                "content":"touch.tap(x, y)\n"
            },
            {
                "name":"sys.toast('')\n",
                "content":"sys.toast('')\n"
            },
            {
                "name":"sys.alert('', 0)\n",
                "content":"sys.alert('', 0)\n"
            },
            {
                "name":"print()",
                "content":"print()"
            },
            {
                "name":"print.out()",
                "content":"print.out()"
            },
			{
                "name":"app.input_text('')",
                "content":"app.input_text('')\n"
            },
			{
                "name":"accelerometer.shake()",
                "content":"accelerometer.shake()\n"
            },
            {
                "name":"r = sys.input_box('')",
                "content":"r = sys.input_box('')\n"
            },
            {
                "name":"pasteboard.write('')",
                "content":"pasteboard.write('')\n"
            },
            {
                "name":"r = pasteboard.read()",
                "content":"r = pasteboard.read()\n"
            },
            {
                "name":"os.execute('')",
                "content":"os.execute('')\n"
            },
            {
                "name":"io.open 读取文件",
                "content":"local f = io.open('/private/var/mobile/Media/1ferver/lua/scripts/1.txt', 'rb')\nlocal r = f:read('*a')\nf:close()\n"
            },
            {
                "name":"io.open 写入文件",
                "content":"local f = io.open('/private/var/mobile/Media/1ferver/lua/scripts/1.txt', 'wb')\n:write('')\nf:close()\n"
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
            },
            {
                "id": "RETURN",
                "name": "回车键"
            },
            {
                "id": "ESCAPE",
                "name": "ESC 键"
            },
            {
                "id": "BACKSPACE",
                "name": "退格键"
            },
            {
                "id": "SPACE",
                "name": "空格键"
            },
            {
                "id": "TAB",
                "name": "制表符键"
            },
            {
                "id": "FORWARD",
                "name": "多媒体下一首"
            },
            {
                "id": "REWIND",
                "name": "多媒体上一首"
            },
            {
                "id": "FORWARD2",
                "name": "多媒体下一首2"
            },
            {
                "id": "REWIND2",
                "name": "多媒体上一首2"
            },
            {
                "id": "PLAYPAUSE",
                "name": "多媒体暂停键"
            },
            {
                "id": "MUTE",
                "name": "静音键"
            },
            {
                "id": "SPOTLIGHT",
                "name": "Spotlight 键"
            },
            {
                "id": "BRIGHTUP",
                "name": "屏幕亮度 + 键"
            },
            {
                "id": "BRIGHTDOWN",
                "name": "屏幕亮度 - 键"
            },
            {
                "id": "SHOW_HIDE_KEYBOARD",
                "name": "隐藏/显示键盘键"
            }
        ]
    }
}
// 选择文件
// 屏幕旋转
// RGB色


customFunction = function(funcId, pos_color_list, bid, keyid) {
    switch(funcId) {
        case "touch.tap":
            return "touch.tap(" + pos_color_list[0].x + ", " + pos_color_list[0].y + ")\n";
        case "touch.swipe":
			var b = true;
			var ret = "";
			for (var i=0; i<pos_color_list.length; i++) {
				if (b) {
					ret = "touch.on(" + pos_color_list[i].x + ", " + pos_color_list[i].y + ")";
				} else {
					ret = ret + ":move(" + pos_color_list[i].x + ", " + pos_color_list[i].y + "):delay(1000):off()\n";
				}
				b = !b;
			}
			return ret;
        case "screen.ocr_text":
			if (!pos_color_list[1]) {
				return "screen.ocr_text(" + pos_color_list[0].x + ", " + pos_color_list[0].y + ", 0, 0)\n";
			} else {
				return "screen.ocr_text(" + pos_color_list[0].x + ", " + pos_color_list[0].y + ", " + pos_color_list[1].x + ", " + pos_color_list[1].y + ")\n";
			}
        case "screen.is_colors":
			var ret = "screen.is_colors({\n";
			for (var i=0; i<pos_color_list.length; i++) {
				ret += "\t{" + pos_color_list[i].x + ", " + pos_color_list[i].y + ", " + pos_color_list[i].color + "},\n";
			}
			ret += "}, 90)\n";
            return ret;
        case "screen.find_color":
            var ret = "local x, y = screen.find_color({\n";
            for (var i=0; i<pos_color_list.length; i++) {
                ret += "\t{" + pos_color_list[i].x + ", " + pos_color_list[i].y + ", " + pos_color_list[i].color + "},\n";
            }
            ret += "}, 90)\n";
            return ret;
        case "key.press":
            return "key.press(\"" + keyid + "\")\n";
        case "app.run":
            return "app.run(\"" + bid + "\")\n";
        case "app.close":
            return "app.close(\"" + bid + "\")\n";
        case "app.quit":
            return "app.quit(\"" + bid + "\")\n";
        case "app.bundle_path":
            return "app.bundle_path(\"" + bid + "\")\n";
        case "app.data_path":
            return "app.data_path(\"" + bid + "\")\n";
        case "app.is_running":
            return "app.is_running(\"" + bid + "\")";
        case "app.is_front":
            return "(\"" + bid + "\" == app.front_bid())";
        case "app.uninstall":
            return "app.uninstall(\"" + bid + "\")";
        case "clear.keychain":
            return "clear.keychain(\"%" + bid + "%\")\n";
        case "clear.app_data":
            return "clear.app_data(\"" + bid + "\")\n";

    }
}