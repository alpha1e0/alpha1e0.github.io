---
title:  "python pyenv anaconda使用"
tags: 编程
last_modified_at: 2019-09-1
keywords: pyenv,virtualenv,anaconda
description: 使用pyenv/virtualenv/anaconda构建python开发环境
---

> 使用pyenv/virtualenv/anaconda构建python开发环境

## 1 背景

python开发的时候，尤其是多个项目开发的时候，经常会遇到以下两个问题：

1. 不同项目使用了不同版本的python
2. 不同项目的第三方依赖不一样，例如一个依赖于 xxx-1.0.0，另一个依赖于xxx-1.2.0

为了解决以上问题，需要引入**版本管理**和**环境管理**工具，前者用于在一台机器上实现安装多个版本的python，后者实现对每个项目工程创建*虚拟环境*实现每个项目不同依赖。

python有众多的版本，不同版本之间支持的特性有差异，而且python2和python3是不向下兼容的，如果做机器学习方面工作又经常会使用`anaconda`，而`anaconda`则完全实现了自己的包管理。

为了应对这种局面，python出现了很多管理工具，例如：virtualenv、pipenv、pyenv等

**pyenv**：

[pyenv](https://github.com/pyenv/pyenv)用于管理python多版本，例如安装多个版本python，如果使用windows系统则需要使用[pyenv-win](https://github.com/pyenv-win/pyenv-win)，pyenv可集成virtual-env插件

**virtualenv**

[virtualenv](https://virtualenv.pypa.io)是python虚拟环境管理工具，可以为每个项目（对应一个目录）创建独立虚拟环境，不同的虚拟环境可以有不同的依赖库

**pipenv**

可以看做是virtualenv的升级

本文主要介绍使用pyenv、virtualenv、anaconda搭建python环境，基本可覆盖绝大多数python开发场景。

## 2. pyenv使用

### 2.1 安装

linux安装：

    curl https://pyenv.run | bash

macos安装：

    brew install pyenv
    brew init

windows安装参考：

    https://github.com/pyenv-win/pyenv-win
    
按照提示操作，一般需要添加

    eval "$(pyenv init -)"
    
到shell初始化脚本中

### 2.2 使用

```
pyenv commands   # 显示所有支持的子命令
pyenv versions  # 查看已经安装的python版本，带*号的为默认使用的版本
pyenv version  # 显示局部或全局python版本
pyenv install -l  # 列举所有可以安装的python版本
pyenv install xxx  # 安装版本，版本安装在 {pyenv home}/versions/
pyenv local {version}   # 在某个目录下执行，配置该目录下的项目使用{version}的python，会在目录下生成.python-version文件记录版本
pyenv global {version}  # 全局切换python版本
pyenv shell {version}  # 当前shell切换为{version}版本python
```

### 2.3 pyenv-virtualenv插件

pyenv-virtualenv是pyenv的virtualenv功能实现，pyenv用于管理多个python版本，而pyenv-virtualenv用于创建虚拟环境

虚拟环境的使用就像虚拟机一样，有以下特点：

1. 虚拟环境需要有一个目录承载，创建虚拟环境后，在这个目录中会有bin/lib/include/local等目录和文件；其中bin中有python、pip等可执行程序，lib中有site-package等安装包的地方
2. bin中有activate/deactivate脚本，当source后会更改环境变量，此时用户使用的时候就像一个全新安装的环境一样，执行python会执行${你的env路径}/bin/python，pip安装会安装到虚拟环境的lib/site-package中。
3. 注意当退出当前shell后，环境变量会消失，下次进入shell需要重新source bin/active。如果想永久使用，可以使用绝对路径访问${你的env路径}/bin/python

**安装：**

    brew install pyenv-virtualenv
    
**环境变量：**

    eval "$(pyenv virtualenv-init -)”

**创建虚拟环境**：

    pyenv virtualenv anaconda3-5.2.0 test
    
**删除虚拟环境**：

    pyenv uninstall test
    
**激活虚拟环境**

    pyenv activate test
    
**去激活当前虚拟环境**

    pyenv deactivate
    
### 2.4 和anaconda联动

当anaconda是由pyenv创建的时候需要注意
conda虚拟环境可以通过pyenv virtualenv或conda命令创建，如果使用pyenv virtualenv创建则会创建一个链接到conda的env目录下

正确的步骤是：
1. 使用pyenv global anaconda3-5.2.0或pyenv activate anaconda3-5.2.0进行切换（两者都可实现切换，不知道区别是什么）
2. 使用pyenv virtualenv或conda命令创建conda虚拟环境
3. 使用conda activate/deactivate激活、去激活环境

## 3 anaconda

### 3.1 安装

推荐使用pyenv进行安装：

    pyenv install -l  # 列举所有可以安装的python版本
    pyenv install anaconda3-5.2.0  # 安装版本，版本安装在 {pyenv home}/versions/
    pyenv global {version}  # 全局切换python版本
    
### 3.2 使用

#### 3.2.1 环境管理

环境管理主要用于创建多python环境（类似于pyenv的功能）
创建一个名为python34的环境，指定Python版本是3.4（不用管是3.4.x，conda会为我们自动寻找3.4.x中的最新版本，如果不指定版本，则会使用系统默认的python版本）

    conda create --name python34 [python=3.4]
 
安装好后，使用activate激活某个环境

    activate python34 # for Windows
    source activate python34 # for Linux & Mac
 
如果想返回默认的环境，运行

    deactivate python34 # for Windows
    source deactivate python34 # for Linux & Mac
 
删除一个已有的环境

    conda remove --name python34 —all
    
查看所有环境

    conda info --envs
    
注意，如果使用pyenv安装的anaconda，则需要使用conda activate/deactivate 激活、去激活环境，不能使用activate、deactivate的方式激活环境

#### 3.2.2 包管理

类似于pip功能，当然在anaconda环境下也同样可以使用pip

查找包

    conda search scipy
    
安装包（使用 -n 参数可指定某个环境，下同）

    conda install [-n python34] scipy
 
查看已经安装的packages

    conda list [-n python34]
    
更新package（conda还可以更新自身，例如conda/anaconda/python）
    
    conda update [-n python34] numpy
 
删除package
    
    conda remove [-n python34] numpy

#### 3.2.3 源配置

配置国内源（清华源）

    conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
    conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/
    conda config --set show_channel_urls yes

### 3.3 参考

1. conda官方手册: [https://conda.io/docs/user-guide/getting-started.html](https://conda.io/docs/user-guide/getting-started.html)
2. 配置清华源：[https://mirrors.tuna.tsinghua.edu.cn/help/anaconda/](https://mirrors.tuna.tsinghua.edu.cn/help/anaconda/)
