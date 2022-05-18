
local o,t,e
local aa1 = luci.sys.exec("head -3 /usr/share/koolproxy/data/rules/koolproxy.txt | grep rules | awk -F' ' '{print $3,$4}'")
local ab1 = luci.sys.exec("head -4 /usr/share/koolproxy/data/rules/koolproxy.txt | grep video | awk -F' ' '{print $3,$4}'")
local b1 = luci.sys.exec("head -6 /usr/share/koolproxy/data/rules/adg.txt | grep modified | awk -F' ' '{print$4}'")
local c1 = luci.sys.exec("head -2 /usr/share/koolproxy/data/rules/steven.txt | grep Date | awk -F' ' '{print$5,$6}'")
local d1 = luci.sys.exec("head -1 /usr/share/koolproxy/data/rules/yhosts.txt | grep version | awk -F' ' '{print$2}'")
local e1 = luci.sys.exec("head -2 /usr/share/koolproxy/data/rules/antiad.txt | grep VER | awk -F'=' '{print$2}'")
local f1 = luci.sys.exec("head -1 /usr/share/koolproxy/data/rules/adgk.txt | grep Version | awk -F' ' '{print$3}'")
local aa2 = luci.sys.exec("grep -v !x /usr/share/koolproxy/data/rules/koolproxy.txt | wc -l")
local ab2 = luci.sys.exec("ls -l /usr/share/koolproxy/data/rules/kp.dat | awk '{print $5}'")
local ac2 = luci.sys.exec("grep -v !x /usr/share/koolproxy/data/rules/daily.txt | wc -l")
local ad2= luci.sys.exec("grep -v '^!' /usr/share/koolproxy/data/rules/user.txt | wc -l")
local b2 = luci.sys.exec("grep -v !x /usr/share/koolproxy/data/rules/adg.txt | wc -l")
local c2 = luci.sys.exec("grep -v !x /usr/share/koolproxy/data/rules/steven.txt | wc -l")
local d2 = luci.sys.exec("grep -v !x /usr/share/koolproxy/data/rules/yhosts.txt | wc -l")
local e2 = luci.sys.exec("grep -v !x /usr/share/koolproxy/data/rules/antiad.txt | wc -l")
local f2 = luci.sys.exec("grep -v !x /usr/share/koolproxy/data/rules/adgk.txt | wc -l")
local g2 = luci.sys.exec("cat /usr/share/koolproxy/dnsmasq.adblock | wc -l")

o = Map("koolproxy")
o.title = translate("iKoolProxy滤广告")
o.description = translate("iKoolProxy是基于KoolProxyR重新整理的能识别adblock规则的免费开源软件,追求体验更快、更清洁的网络，屏蔽烦人的广告！")

o:section(SimpleSection).template = "koolproxy/koolproxy_status"

t = o:section(TypedSection, "global")
t.anonymous = true

e = t:option(Flag, "enabled", translate("启用"))
e.default = 0

e = t:option(Value, "startup_delay", translate("启动延迟"))
e:value(0, translate("不启用"))
for _, v in ipairs({5, 10, 15, 25, 40, 60}) do
	e:value(v, translate("%u 秒") %{v})
end
e.datatype = "uinteger"
e.default = 0

e = t:option(ListValue, "koolproxy_mode", translate("过滤模式"))
e:value(1, translate("全局模式"))
e:value(2, translate("IPSET模式"))
e:value(3, translate("视频模式"))
e.default = 1

e = t:option(MultiValue, "koolproxy_rules", translate("内置规则"))
e:value("koolproxy.txt", translate("静态规则"))
e:value("daily.txt", translate("每日规则"))
e:value("kp.dat", translate("视频规则"))
e:value("user.txt", translate("自定义规则"))
e:value("dnsmasq.adblock", translate("dnsmasq.adblock文件"))
e.optional = false

e = t:option(MultiValue, "thirdparty_rules", translate("第三方规则"))
e:value("adg.txt", translate("AdGuard规则"))
e:value("steven.txt", translate("Steven规则"))
e:value("yhosts.txt", translate("Yhosts规则"))
e:value("antiad.txt", translate("AntiAD规则"))
e:value("adgk.txt", translate("Banben规则"))
e.optional = false

e = t:option(ListValue, "koolproxy_port", translate("端口控制"))
e:value(0, translate("关闭"))
e:value(1, translate("开启"))
e.default = 0

--e = t:option(ListValue, "koolproxy_ipv6", translate("IPv6支持"))
--e:value(0, translate("关闭"))
--e:value(1, translate("开启"))
--e.default = 0

e = t:option(Value, "koolproxy_bp_port", translate("例外端口"))
e.description = translate("单端口:80&nbsp;&nbsp;多端口:80,443")
e:depends("koolproxy_port", "1")

e = t:option(Flag, "koolproxy_host", translate("开启Adblock Plus Hosts"))
e:depends("koolproxy_mode","2")
e.default = 0

e = t:option(ListValue, "koolproxy_acl_default", translate("默认访问控制"))
e.description = translate("访问控制设置中其他主机的默认规则")
e:value(0, translate("不过滤"))
e:value(1, translate("过滤HTTP协议"))
e:value(2, translate("过滤HTTP(S)协议"))
e:value(3, translate("过滤全端口"))
e.default = 1

e = t:option(ListValue, "time_update", translate("定时更新"))
e.description = translate("定时更新规则")
for t = 0,23 do
	e:value(t,translate("每天"..t.."点"))
end
e:value(nil, translate("关闭"))
e.default = nil

e = t:option(Button, "restart", translate("规则状态"))
e.inputtitle = translate("更新规则")
e.inputstyle = "reload"
e.write = function()
	luci.sys.call("/usr/share/koolproxy/kpupdate 2>&1 >/dev/null")
	luci.http.redirect(luci.dispatcher.build_url("admin","services","koolproxy"))
end
e.description = translate(string.format("<font color=\"red\"><strong>更新订阅规则信息</strong></font><br /><font color=\"green\">KP静态规则:%s	 /%s条<br />视频规则: %s /%s<br />每日规则:%s条<br />自定义规则: %s条<br />AdGuard规则: %s /%s条<br />Steven规则: %s /%s条<br />Yhosts规则: %s /%s条<br />AntiAD规则: %s /%s条<br />Banben规则: %s /%s条<br />Host: %s条</font><br />", aa1,aa2,ab1,ab2,ac2,ad2,b1,b2,c1,c2,d1,d2,e1,e2,f1,f2,g2 ))

return o
