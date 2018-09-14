---
title:  "jekyll和markdown构建网站、博客"
categories: 其他
tags: 工具使用
last_modified_at: 2018-08-12
keywords: jekyll,markdown,Minimal Mistakes主题
description: jekyll构建静态网站，markdown编写文档、博客
---

> jekyll构建静态网站，markdown编写文档、博客

## 1 使用jekyll和markdown构建个人网站、博客

[jekyll](https://jekyllrb.com)是一个静态网站生成工具，可以通过`markdown`编写文档，使用模板自定义网站结构，通过`sass`或`css`自定义格式。

类似的工具还有[gitbook](https://www.gitbook.com)、[Sphinx](http://www.sphinx-doc.org/en/master/)。

相比起来，gitbook更适合用来写书籍，sphinx更适合用来写使用手册，而jekyll更适合用于构建博客。

同时gitbook jekyll使用`markdown`作为格式化语言，而sphinx则使用`reStructuredText`作为格式化语言。

**另外:** 如果仅仅是希望能够将markdown转换为html或其他格式文档，强烈建议使用神器[pandoc](http://www.pandoc.org)
{: .notice--info}

### 1.1 jekyll安装

jekyll是用`ruby`编写的工具，因此在安装jekyll之前需要安装`ruby`环境。

一个完整的ruby环境包括：

* ruby。ruby的主程序。
* ruby包管理工具`rubygems`。用于从源服务器下载软件包并安装到合适的目录。
* ruby的包依赖管理工具`bundle`。如果一个项目有很多依赖包，这些依赖包有版本限制，并且可能依赖于其他包，此时如果手动用rubygem安装则会非常繁琐，且容易出错，而bundle就是用来解决这个问题，它可以根据项目根目录下的*Gemfile*自动解决软件包依赖。

`ruby`安装：

* windows 安装可直接下载[安装包](https://rubyinstaller.org/downloads/)，建议安装*2.2*以上版本。
* linux 下可使用包管理工具安装直接安装，*yum install ruby* 或 *apt-get install ruby*，当然也可[下载](http://www.ruby-lang.org/en/downloads/)安装包到本地安装。
* macos 下可使用包管理工具安装，*brew install ruby*，也可[下载](http://www.ruby-lang.org/en/downloads/)安装包到本地安装。

`rubygems`安装可参考[这里](https://rubygems.org/pages/download)

需要下载相应的压缩包，在本地解压后，进入目录执行 *ruby setup.rb* 命令完成安装。

在中国国内使用的时候（容易被墙）建议切换源服务器，可以大大提升安装速度，具体参考[这里](https://gems.ruby-china.org)

`bundle`的安装非常简单。此时rubygems已经安装完成了，因此可直接使用：

    gem install bundle

完成安装。

`jekyll`安装，同样和bundle安装一样，直接使用gem命令即可：

    gem install jekyll


### 1.2 jekyll使用

#### a. 基本原理

jekyll的原理很简单，根据配置文件，基于用户自己定义的[Liquid](https://github.com/Shopify/liquid/wiki)模板，将使用markdown编写的文档根据用户自定义的CSS/SASS格式编译成静态网站。

因此，使用jekyll的时候将涉及到以下4个要素：

1. 配置。初始建站的时候配置一次，以后便基本不用在配置了；全局配置较少，但有的主题配置比较多。
2. markdown文档。这是自己需要编写的博客。
3. 模板系统。模板系统定义了网站的结构，类似于java的jsp、python的mako。
4. CSS/SASS定义。定义了网站的页面展示效果。

其中3和4构成了jekyll的“主题”，用户可自己[在这里](http://jekyllthemes.org)下载一些开源的主题直接使用，例如本博客使用的主题[Minimal Mistakes](https://mademistakes.com/work/minimal-mistakes-jekyll-theme/)。

#### b. 基本命令

在搭建完成jekyll之后，可以使用如下命令在本地创建一个网站、博客：

    $ jekyll new my-awesome-site   # 创建一个名字为"my-awesome-site"的网站，此时会在本地创建名为"my-awesome-site"的目录
    ~ $ cd my-awesome-site         # 进入目录
    # 此处配置、配置主题、编写博客
    ~/my-awesome-site $ bundle exec jekyll serve # 在本地编译并开启网站，然后访问 http://127.0.0.1:4000 即可访问

**注意:** 也可使用*jekyll server*命令在本地编译并开启网站，但建议使用*bundle exec jekyll serve*，这样bundle会根据网站的Gemfile解决ruby的依赖，同样的情况也适用于*bundle build*命令。

#### c. 目录结构

使用*jekyll new my-awesome-site*命令后会创建同名目录，并且在同名目录中创建一些最基础的内容，理论上你可以在此目录中放入任何目录和文件，但一般情况下建议使用如下的目录结构：

    ├── /_posts                    # _posts目录是编写博客、网站使用的目录
    │   └── 2018-08-01-example.md
    ├── /_layouts                  # _loayouts目录定义了网站的布局，使用Liquid模板编写，一般会引用_inculdes目录下定义的内容
    │   ├── default.html
    │   ├── home.html
    │   ├── page.html
    │   └── post.html
    ├── /_includes                 # _includes目录使用Liquid模板编写了网站的“局部布局”例如网站头部、尾部
    │   ├── head.html
    │   └── header.html
    ├── /_sass                     # _sass定义了网站的sass信息
    │   ├── /minima
    │   │   ├── _base.scss
    │   │   └── _layout.scss
    │   └── minima.scss
    ├── /assets                    # assets目录一般存放一些静态资源：图片、css、js等
    │   └── main.scss
    ├── /_site                     # 该目录自动生成，用于存放编译出来的静态网站内容
    ├── _config.yml                # jekyll的主配置文件，需要用户根据实际情况编辑
    ├── index.html                 # 自定义的index.html，一般无需修改
    ├── 404.html                   # 自定义的404错误页面
    ├── README.md                  # 网站介绍，一般不会出现在网站中
    ├── Gemfile                    # Gemfile文件
    ├── Gemfile.lock
    ├── about.md
    └── LICENSE.txt

用户完全可以在jekyll中创建任意目录，例如可以将所有静态资源：css、js、图片、副件放入到一个目录中：

    ├── /static
        ├── /css
        ├── /js
        ├── /attachment
        └── /image
             ├── xxx.jpg
             └── avata.png

这样可以在博客中使用 */static/image/xxx.jpg* 来访问这些静态资源。

#### d. 编写博客

博客内容需要放入到*/_posts*目录下，在jekyll中博客文件名需要按照一定的格式:

    YEAR-MONTH-DAY-title.MARKUP

即，在真正的文件名之前需要写上编写日期，当然日期可随便写，月份、天数为单个数字的时候要在前面补一个0，例如 2018-08-01，MARKUP可以为md或者markdown。

例如：

    2011-12-31-我的第一篇博客.md
    2012-09-12-how-to-write-a-blog.md

在每篇博客中，我们需要在正文之前加一段信息，用于说明这篇博客的一些基本情况，jekyll中将这个信息称为[YAML Front Matter](https://jekyllrb.com/docs/frontmatter/)，这个信息使用 [yaml](http://yaml.org)，不过对于博客编写完全没有必要去学习`yaml`语言。

例如，本文的`YAML Front Matter`如下：

    ---
    title:  "jekyll和markdown构建网站、博客"
    categories: 其他
    tags: 工具使用
    toc: true
    toc_label: 目录
    toc_icon: "cog"
    ---

`YAML Front Matter`中的内容可以理解为文档的基本信息、基本配置，*title* 是必须的，其他的都是可选的，定义这些信息是为了给“主题”系统提供一些信息。举个例子，如果你想实现一个页面，其中包含了所有类别为“其他”的文档，则需要遍历所有博客，从`YAML Front Matter`中读取*categories*，判断其是否为*其他*，然后决定是否包含。上例中的*toc\**明显是关于博客导航的配置。

正文的内容则没有任何要求，使用markdown编写即可。


#### e. 其他

jekyll[手册](https://jekyllrb.com/docs/home/)中有jekyll的使用方法。

需要注意的是，其中的大部分内容都是关于jekyll模板系统的，因此如果不想自己编写一套"主题"则大部分内容可以不参考。其中对普通使用这最有用的内容是[配置](https://jekyllrb.com/docs/configuration/)、[目录结构](https://jekyllrb.com/docs/configuration/)、[编写内容](https://jekyllrb.com/docs/posts/)


### 1.3 网站发布

在编写完成了博客之后，使用*bundle jekyll build*或者*bundle jekyll server*可在本地的*_site*目录下生成静态网站，但目前为止该网站仅能在本地访问。这时候要做的就是发布自己的网站。

一种免费的解决方案：使用[github](https://github.com)，只需要创建一个代码仓库，将自己在本地创建的jekyll项目push到github即可，每次更新后，github就会自动使用服务器端的jekyll生成静态网站。

详细步骤：

1. 在github上创建一个代码仓库。名字必须为*yourname.github.io*，假设你的git账户名为*yourname*
2. 将创建的仓库clone到本地，*git clone git@github.com:yourname/yourname.github.io.git*
3. 将自己创建的jekyll目录*my-awesome-site*中的内容完全复制到自己的代码仓库本地仓库*yourname.github.io*中，注意这里是将*my-awesome-site*中的内容copy进去，而不是整个目录本身copy进去。
4. 使用git push自己的编辑内容。

此时即可通过 *https://yourname.gitbub.io* 访问自己的网站。如果在发布过程中一些帮助信息可参考[这里](https://help.github.com/categories/customizing-github-pages/)

**注意:** 使用这种方式可以免费发布自己的网站，但是此处使用的是服务器端的jekyll编译的，而不是你本地自己搭建的jekyll编译的，因此两者会有一些差异，并且因为一些安全的原因，有的插件在本地有效在github上无效。
{: .notice--warning}

github发布的缺点在于，在中国大陆访问速度很慢。

因此可以在国内自己创建服务器发布，可以在[阿里云](https://www.aliyun.com)，[华为云](https://www.huaweicloud.com)购买最基础的ECS（如果博客访问量没有爆发，则最低配置完全够用）。

在服务器上安装apache，如果使用的CentOS镜像，则可以直接使用：

    yum install httpd

然后将自己的编译后的网站内容，即_site目录下的所有内容上传到网站上即可。

为了简化整个过程，可以在本地jekyll目录中编写一个`Makefile`文件，用于自动化完成上述过程，例如

```bash
.PHONY: preview
preview:
    bundle exec jekyll serve

.PHONY: server
server:
    bundle exec jekyll build
    @echo
    @echo "Build finished. Upload to server."
    cd $(BUILDDIR) && scp -i 你的ssh证书文件 -P $port -r . root@$ip:/你的服务器http目录
```

使用*make preview*可预览网站，完成修改后使用*make server*完成网站发布


## 2 markdown 语法示例

本文中介绍的`markdown`为 [kramdown](https://kramdown.gettalong.org/quickref.html)

### 2.1 标题

标题用#号开头即可，1个#号是一级标题，2个##号是二级标题，依次类推，例如：

```
# 一级标题
## 二级标题
### 三级标题
...

```

### 2.2 段落

段落仅需要“正常书写”，空行会自动分割两个段落，段落前的空格、TAB键会自动忽略

这是新的段落，中间隔一行空行就可以了


```
这是正常文字

*这是斜体文字*

**这是加重文字**

`这是高亮文字`
```

这是正常文字

*这是斜体文字*

**这是加重文字**

`这是高亮文字`


### 2.3 列表

无序列表: 无序列表以 \* 或 \- 或 \+ 符号开始

```
* 项目1
* 项目2
* 项目3
```

* 项目1
* 项目2
* 项目3

有序列表: 有序列表以数字和 . 开始

```
1. the first one
2. the second one
```

1. the first one
2. the second one

定义列表：

```
文章简要信息
: 作者：alpha1e0
: 日期：2018-7-10
```

文章简要信息
: 作者：alpha1e0
: 日期：2018-7-10


### 2.4 引用

引用用于凸显某些信息，例如：

```
> 这是一个引用
>> 二级引用
```

显示效果为：

> 这是一个引用
>> 二级引用


### 2.5 代码块

代码块用于在文档中插入一段代码内容，用于凸显代码，在jekyll的“加持”下可以支持语法高亮显示，非常适合程序员使用。

markdown默认的代码块语法非常简单，只需要在代码块前面加 `TAB` 键即可，例如：

```
    def foo():
        print "hello world!"
```

显示为：


    def foo():
        print "hello world!"

此种方式显示的代码块中无法高亮显示语法，因此当需要语法高亮的时候，需要使用如下三种方式之一：

**语法高亮方式1：**

{% raw %}
    {% highlight ruby %}
    def print_hi(name)
      puts "Hi, #{name}"
    end
    {% endhighlight %}
{% endraw %}

显示为：

{% highlight ruby %}
def print_hi(name)
  puts "Hi, #{name}"
end
{% endhighlight %}

此时可以加入 **linenos** 关键词，指定在代码行前加入行号（后面两种语法高亮方式无法使用此功能）

{% raw %}
    {% highlight ruby linenos %}
    def print_hi(name)
      puts "Hi, #{name}"
    end
    {% endhighlight %}
{% endraw %}

显示为：

{% highlight ruby linenos %}
def print_hi(name)
  puts "Hi, #{name}"
end
{% endhighlight %}

**语法高亮方式2：**


    ``` python
    def foo():
        print "hello world"
    ```

显示为

``` python
def foo():
    print "hello world"
```

**语法高亮方式3：**

此种方式是 `kramdown` 语法支持的方式

    ~~~ python
    def foo():
        print "hello world"
    ~~~

显示为：

~~~ python
def foo():
    print "hello world"
~~~

这种方式还有一个好处，如果想要在行内加入“\~\~\~”符号，只需要在初始和结束行加入更长的“\~\~\~\~\~\~\~”

    ~~~~~ python
    def foo():
        print "hello world"
    ~~~
    print "hi, tom"
    ~~~~~

显示为：

~~~~~ python
def foo():
    print "hello world"
~~~
print "hi, tom"
~~~~~


### 2.6 链接

普通链接示例如下：

```
Google搜索: [Google一下](www.google.com)

My email is: [email](mailto:test@gmail.com)
```

Google搜索: [Google一下](www.google.com)

My email is: [email](mailto:xxx@gmail.com)

图片链接示例如下：

```
![铁路](/images/railway.jpg "铁路")
```

![铁路](/images/railway.jpg "铁路")

行外链接示例如下：（有时候链接信息很多，则可以将链接信息放到一起，在行内直接引用）

```
本文参考了[markdown语法][markdown]信息，[kramdown][2]语法信息，以及[jekyll][jekyll]相关文档

[1]: https://mademistakes.com/work/minimal-mistakes-jekyll-theme/
[2]: https://kramdown.gettalong.org/quickref.html
[jekyll]: https://jekyllrb.com/
[markdown]: http://www.appinn.com/markdown/
```

本文参考了[markdown语法][markdown]信息，[kramdown][2]语法信息，以及[jekyll][jekyll]相关文档

[1]: https://mademistakes.com/work/minimal-mistakes-jekyll-theme/
[2]: https://kramdown.gettalong.org/quickref.html
[jekyll]: https://jekyllrb.com/
[markdown]: http://www.appinn.com/markdown/

**注:** 一般情况下将链接信息统一放在文章末尾处
{: .notice--info}

参考、引用信息的语法如下：

```
我们必须知道，我们终将知道[^1]

[^1]: 大卫.希尔伯特
```

我们必须知道，我们终将知道[^1]

[^1]: 大卫.希尔伯特


### 2.7 表格

表格示例如下：

```
Table Header 1 | Table Header 2 | Table Header 3
-------------- | -------------- | --------------
Row 1 col 1 | Row 1 col 2 | Row 1 col 3
Row 2 col 1 | Row 2 col 2 | Row 2 col 3
```

Table Header 1 | Table Header 2 | Table Header 3
-------------- | -------------- | --------------
Row 1 col 1 | Row 1 col 2 | Row 1 col 3
Row 2 col 1 | Row 2 col 2 | Row 2 col 3


其中，各行不需要对其，仅仅用 “\|” 进行正确分割即可

第二行中的分割线可定义表格内容的对其方式：

    :-------  # 左对其
    :------:  # 中间对其
    -------:  # 右对其


### 2.8 其他

#### a. 分割线

分割线在一行开头输入 *“-”* 重复3个字符以上即可


```
----
```

----

#### b. 自定义属性

kramdown支持自定义html属性。

这个特性在有的时候非常有用，例如，你可能需要某些特殊的html展示，此时可以自定义一些class，编写相应的CSS文件，在markdown文本中引用这些class。

自定义属性的语法格式如下：

    {: .some_class #some_id somekey="somevalue"}

经过自定义后将会生成如下的属性：

    <xxx class="some_class", id="some_id", somekey="somevalue">

只需要在某个block结束（或之前）加入这些自定义信息即可

例如，mademistakes主题中增加了以下提醒信息：

```
**重要提示:** 重要、紧急、致命提示信息
{: .notice--danger}
```

**重要提示:** 重要、紧急、致命提示信息
{: .notice--danger}

```
**警告提示:** 警告提示信息
{: .notice--warning}
```

**警告提示:** 警告提示信息
{: .notice--warning}

```
**普通提示:** 普通提示信息
{: .notice--info}
```

**普通提示:** 普通提示信息
{: .notice--info}





