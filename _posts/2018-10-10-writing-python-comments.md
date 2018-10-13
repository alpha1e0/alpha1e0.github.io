---
title:  "如何优雅得编写python注释"
tags: 编程
last_modified_at: 2018-10-10
keywords: python注释,reStructuredText
description: 本文介绍如何优雅得为python代码编写注释
---

> 优雅得编写python注释

## 1 为什么要编写注释

“Code is more often read than written.”
— Guido Van Rossum
{: .notice--warning}

“It doesn’t matter how good your software is, because if the documentation is not good enough, people will not use it.“
— Daniele Procida
{: .notice--warning}

如果想做一名职业软件工程师，代码注释是非常重要的，不论是对于团队还是对于自己。一段自己编写的代码（尤其是业务或算法复杂的代码）如果没有合理的注释，很快自己都不知道自己当时写的是什么，更不用说别人的代码了，毫无疑问这就是程序员所说的”坑“。因此良好的注释是不给自己挖坑也不给别人挖坑。

## 2 python的两种注释

python有两种方式进行注释：

1. **docstring** 。这种方式的注释是python提供的一种语言特性，即python代码本身是“自注释”的，即便编译成pyc二进制文件，docstring仍然是存在的。
2. **普通注释** 。以“#”开头的注释，这种类型的注释和其他编程语言是一致的，编译成pyc后就消失了。

例如：

``` python
def print_msg(msg):
    '''
    这里是docstring注释
    
    Args:
        msg (str): the msg to show
    '''
    # 这里是普通注释
    print("hello" + msg)
```

这两种方式的注释是有区别的：

* docstring注释是给“用户”看的（自己也可以是用户），例如编写了一个模块、库，供别人或自己使用，那么就需要使用docstring编写注释，这里的注释更像是“使用手册”
* 普通注释是给“开发者”看的，它们需要通过普通的注释去了解代码内部的原理

在大多数编程语言中，当我们要查看一些库的使用方法的时候，我们只能借助该库的网上在线手册、离线手册、书籍、dash/zeal软件等，但熟练的python程序员则根本不用这些各种渠道的使用手册，他们只使用 `help` 函数即可解决问题，而该函数的作用就是格式化输出docstrig。

例如，上述的 *print_msg* 函数，假设它发布为一个Python库：**idiot_print** ，用户只需要导入库，使用 `help(idiot_print.print_msg)` 即可查看该函数的手册:

> help(idiot_print.print_msg)

```
Help on function print_msg in module idiot_print:

print_msg(msg)
    这里是docstring注释

    Args:
        msg (str): the msg to show
(END)
```

docstring是一个绝妙的主意，它通过语言的特性“统一了使用手册”，使得熟练的python程序员一般很少登录 *docs.python.org* 查阅手册资料，他们仅需要 `help` 就解决问题了。

在下文中将主要介绍docsting类型的注释，对于普通注释，仅在这里列举一下编写原则：

1. 注释应当离被注释的对象尽可能的近。
2. 不要使用图表等复杂格式进行注释。
3. 不要事无巨细，要假设阅读你的代码的人拥有基本的领域知识。
4. 代码应当“自释义”，最好的代码不需要注释，自己本身就是注释，尤其对于python这样的和自然语言比较贴近的语言，提高可读性本身比编写注释更重要。

## 3 如何编写docstring注释

java程序员都知道 `javadoc` 这个工具，可以根据注释生成文档。python本身并不包含这样的工具，但python有一个非常著名的工具 [sphinx](http://www.sphinx-doc.org/en/master/)， 该工具提供了类似于 `javadoc` 的功能，程序员可以使用[reStructuredText](http://docutils.sourceforge.net/rst.html)文本标记语言编写文档，然后将文档编译生成html/pdf/epub等格式。

`sphinx` 工具生成的手册大多数程序员都见过，例如python的[官方手册](https://docs.python.org/3/library/index.html)，你可以在网页右下角看到 *sphinx* 的技术支持说明。

程序员常用的 [readthedoc](https://readthedocs.com) 也主要使用sphinx来生成文档。另一个类似的工具是[gitbook](https://legacy.gitbook.com)；经常有程序员会拿 `readthedoc` 和 `gitbook` 比较，笔者认为前者更适合用于编写技术手册、开发手册，而后者则更适合用于写书。如今IT行业的技术手册，使用 **reStructuredText+sphinx+readthedoc** 方式几乎是一种共识。

`sphinx` 提供了 **autodoc** 的插件，可以导入一个模块，根据docstring生成用户手册。所以，python的docstring注释会使用 `reStructuredText` 作为文本标记语言，生成文档的时候都是带有“格式”的，并且不同风格的docstring均会“扩展”一些语法，在最终使用sphinx生成手册的时候需要一些sphinx插件用于解析扩展的语法，下文的docstring格式示例会看到这一点。

常见的python程序注释风格有3种：

1. google推荐的注释风格，支持模块、类、函数、变量注释，非常详细，且易于阅读。
2. numpy风格的注释，支持模块模块、类、函数、变量注释，同样易于阅读。
3. sphinx风格的注释，支持函数、类，通过sphinx格式化输出比较漂亮，但阅读性弱一些。

笔者这里推荐使用第一种风格的注释，当然这三种风格的注释可以混用，只要格式简洁、易于阅读、不会产生歧义即可，著名的openstack社区多使用sphinx风格的注释，但也做了一些自己的修改、增强。

### 3.1 google风格的docstring注释

下文中的google风格注释原文出处 [google_style_docstrings](http://www.sphinx-doc.org/en/1.6/ext/example_google.html?highlight=Python%20Docstrings)

``` python
# -*- coding: utf-8 -*-

# 这里是模块的docstring注释，在py文件开头编写，模块级别的变量可以在模块中注释，也可以在变量
# 所在行后面注释，注意变量的注释并不是python语法支持的，仅用于生成文档
"""Example Google style docstrings.

This module demonstrates documentation as specified by the `Google Python
Style Guide`_. Docstrings may extend over multiple lines. Sections are created
with a section header and a colon followed by a block of indented text.

Example:
    Examples can be given using either the ``Example`` or ``Examples``
    sections. Sections support any reStructuredText formatting, including
    literal blocks::

        $ python example_google.py

Section breaks are created by resuming unindented text. Section breaks
are also implicitly created anytime a new section starts.

Attributes:
    module_level_variable1 (int): Module level variables may be documented in
        either the ``Attributes`` section of the module docstring, or in an
        inline docstring immediately following the variable.

        Either form is acceptable, but the two should not be mixed. Choose
        one convention to document module level variables and be consistent
        with it.

Todo:
    * For module TODOs
    * You have to also use ``sphinx.ext.todo`` extension

.. _Google Python Style Guide:
   http://google.github.io/styleguide/pyguide.html

"""

module_level_variable1 = 12345

# 这里是对模块级的变量进行docstring注释
module_level_variable2 = 98765
"""int: Module level variable documented inline.

The docstring may span multiple lines. The type may optionally be specified
on the first line, separated by a colon.
"""

# 函数的docstring示例，可以看到这里面使用了reStructuredText语法
def function_with_types_in_docstring(param1, param2):
    """Example function with types documented in the docstring.

    `PEP 484`_ type annotations are supported. If attribute, parameter, and
    return types are annotated according to `PEP 484`_, they do not need to be
    included in the docstring:

    Args:
        param1 (int): The first parameter.
        param2 (str): The second parameter.

    Returns:
        bool: The return value. True for success, False otherwise.

    .. _PEP 484:
        https://www.python.org/dev/peps/pep-0484/

    """


def function_with_pep484_type_annotations(param1: int, param2: str) -> bool:
    """Example function with PEP 484 type annotations.

    Args:
        param1: The first parameter.
        param2: The second parameter.

    Returns:
        The return value. True for success, False otherwise.

    """


def module_level_function(param1, param2=None, *args, **kwargs):
    """This is an example of a module level function.

    Function parameters should be documented in the ``Args`` section. The name
    of each parameter is required. The type and description of each parameter
    is optional, but should be included if not obvious.

    If ``*args`` or ``**kwargs`` are accepted,
    they should be listed as ``*args`` and ``**kwargs``.

    The format for a parameter is::

        name (type): description
            The description may span multiple lines. Following
            lines should be indented. The "(type)" is optional.

            Multiple paragraphs are supported in parameter
            descriptions.

    Args:
        param1 (int): The first parameter.
        param2 (:obj:`str`, optional): The second parameter. Defaults to None.
            Second line of description should be indented.
        *args: Variable length argument list.
        **kwargs: Arbitrary keyword arguments.

    Returns:
        bool: True if successful, False otherwise.

        The return type is optional and may be specified at the beginning of
        the ``Returns`` section followed by a colon.

        The ``Returns`` section may span multiple lines and paragraphs.
        Following lines should be indented to match the first line.

        The ``Returns`` section supports any reStructuredText formatting,
        including literal blocks::

            {
                'param1': param1,
                'param2': param2
            }

    Raises:
        AttributeError: The ``Raises`` section is a list of all exceptions
            that are relevant to the interface.
        ValueError: If `param2` is equal to `param1`.

    """
    if param1 == param2:
        raise ValueError('param1 may not be equal to param2')
    return True


# google风格的docstring注释也支持生成器
def example_generator(n):
    """Generators have a ``Yields`` section instead of a ``Returns`` section.

    Args:
        n (int): The upper limit of the range to generate, from 0 to `n` - 1.

    Yields:
        int: The next number in the range of 0 to `n` - 1.

    Examples:
        Examples should be written in doctest format, and should illustrate how
        to use the function.

        >>> print([i for i in example_generator(4)])
        [0, 1, 2, 3]

    """
    for i in range(n):
        yield i


# exception docstring注释
class ExampleError(Exception):
    """Exceptions are documented in the same way as classes.

    The __init__ method may be documented in either the class level
    docstring, or as a docstring on the __init__ method itself.

    Either form is acceptable, but the two should not be mixed. Choose one
    convention to document the __init__ method and be consistent with it.

    Note:
        Do not include the `self` parameter in the ``Args`` section.

    Args:
        msg (str): Human readable string describing the exception.
        code (:obj:`int`, optional): Error code.

    Attributes:
        msg (str): Human readable string describing the exception.
        code (int): Exception error code.

    """

    def __init__(self, msg, code):
        self.msg = msg
        self.code = code


# 类的docstring注释
class ExampleClass(object):
    """The summary line for a class docstring should fit on one line.

    If the class has public attributes, they may be documented here
    in an ``Attributes`` section and follow the same formatting as a
    function's ``Args`` section. Alternatively, attributes may be documented
    inline with the attribute's declaration (see __init__ method below).

    Properties created with the ``@property`` decorator should be documented
    in the property's getter method.

    Attributes:
        attr1 (str): Description of `attr1`.
        attr2 (:obj:`int`, optional): Description of `attr2`.

    """

    def __init__(self, param1, param2, param3):
        """Example of docstring on the __init__ method.

        The __init__ method may be documented in either the class level
        docstring, or as a docstring on the __init__ method itself.

        Either form is acceptable, but the two should not be mixed. Choose one
        convention to document the __init__ method and be consistent with it.

        Note:
            Do not include the `self` parameter in the ``Args`` section.

        Args:
            param1 (str): Description of `param1`.
            param2 (:obj:`int`, optional): Description of `param2`. Multiple
                lines are supported.
            param3 (list(str)): Description of `param3`.

        """
        self.attr1 = param1
        self.attr2 = param2
        self.attr3 = param3  #: Doc comment *inline* with attribute

        #: list(str): Doc comment *before* attribute, with type specified
        self.attr4 = ['attr4']

        self.attr5 = None
        """str: Docstring *after* attribute, with type specified."""

    @property
    def readonly_property(self):
        """str: Properties should be documented in their getter method."""
        return 'readonly_property'

    @property
    def readwrite_property(self):
        """list(str): Properties with both a getter and setter
        should only be documented in their getter method.

        If the setter method contains notable behavior, it should be
        mentioned here.
        """
        return ['readwrite_property']

    @readwrite_property.setter
    def readwrite_property(self, value):
        value

    def example_method(self, param1, param2):
        """Class methods are similar to regular functions.

        Note:
            Do not include the `self` parameter in the ``Args`` section.

        Args:
            param1: The first parameter.
            param2: The second parameter.

        Returns:
            True if successful, False otherwise.

        """
        return True

    def __special__(self):
        """By default special members with docstrings are not included.

        Special members are any methods or attributes that start with and
        end with a double underscore. Any special member with a docstring
        will be included in the output, if
        ``napoleon_include_special_with_doc`` is set to True.

        This behavior can be enabled by changing the following setting in
        Sphinx's conf.py::

            napoleon_include_special_with_doc = True

        """
        pass

    def __special_without_docstring__(self):
        pass

    def _private(self):
        """By default private members are not included.

        Private members are any methods or attributes that start with an
        underscore and are *not* special. By default they are not included
        in the output.

        This behavior can be changed such that private members *are* included
        by changing the following setting in Sphinx's conf.py::

            napoleon_include_private_with_doc = True

        """
        pass

    def _private_without_docstring(self):
        pass

```

在使用sphinx生成手册的时候需要在*conf.py*中添加`sphinx.ext.napoleon`插件。
{: .notice--info}

### 3.2 nmupy风格的docstring注释

下文中的numpy风格注释原文出处 [numpy_style_docstrings](http://www.sphinx-doc.org/en/1.6/ext/example_numpy.html#example-numpy)

``` python
# -*- coding: utf-8 -*-
"""Example NumPy style docstrings.

This module demonstrates documentation as specified by the `NumPy
Documentation HOWTO`_. Docstrings may extend over multiple lines. Sections
are created with a section header followed by an underline of equal length.

Example
-------
Examples can be given using either the ``Example`` or ``Examples``
sections. Sections support any reStructuredText formatting, including
literal blocks::

    $ python example_numpy.py


Section breaks are created with two blank lines. Section breaks are also
implicitly created anytime a new section starts. Section bodies *may* be
indented:

Notes
-----
    This is an example of an indented section. It's like any other section,
    but the body is indented to help it stand out from surrounding text.

If a section is indented, then a section break is created by
resuming unindented text.

Attributes
----------
module_level_variable1 : int
    Module level variables may be documented in either the ``Attributes``
    section of the module docstring, or in an inline docstring immediately
    following the variable.

    Either form is acceptable, but the two should not be mixed. Choose
    one convention to document module level variables and be consistent
    with it.


.. _NumPy Documentation HOWTO:
   https://github.com/numpy/numpy/blob/master/doc/HOWTO_DOCUMENT.rst.txt

"""

module_level_variable1 = 12345

module_level_variable2 = 98765
"""int: Module level variable documented inline.

The docstring may span multiple lines. The type may optionally be specified
on the first line, separated by a colon.
"""


def function_with_types_in_docstring(param1, param2):
    """Example function with types documented in the docstring.

    `PEP484`_ type annotations are supported. If attribute, parameter, and
    return types are annotated according to `PEP484`_, they do not need to be
    included in the docstring:

    .. _PEP484: https://www.python.org/dev/peps/pep-0484/

    Parameters
    ----------
    param1 : int
        The first parameter.
    param2 : str
        The second parameter.

    Returns
    -------
    bool
        True if successful, False otherwise.

    """


def function_with_pep484_type_annotations(param1: int, param2: str) -> bool:
    """Example function with PEP 484 type annotations.

    The return type must be duplicated in the docstring to comply
    with the NumPy docstring style.

    Parameters
    ----------
    param1
        The first parameter.
    param2
        The second parameter.

    Returns
    -------
    bool
        True if successful, False otherwise.

    """


def module_level_function(param1, param2=None, *args, **kwargs):
    """This is an example of a module level function.

    Function parameters should be documented in the ``Parameters`` section.
    The name of each parameter is required. The type and description of each
    parameter is optional, but should be included if not obvious.

    If ``*args`` or ``**kwargs`` are accepted,
    they should be listed as ``*args`` and ``**kwargs``.

    The format for a parameter is::

        name : type
            description

            The description may span multiple lines. Following lines
            should be indented to match the first line of the description.
            The ": type" is optional.

            Multiple paragraphs are supported in parameter
            descriptions.

    Parameters
    ----------
    param1 : int
        The first parameter.
    param2 : :obj:`str`, optional
        The second parameter.
    *args
        Variable length argument list.
    **kwargs
        Arbitrary keyword arguments.

    Returns
    -------
    bool
        True if successful, False otherwise.

        The return type is not optional. The ``Returns`` section may span
        multiple lines and paragraphs. Following lines should be indented to
        match the first line of the description.

        The ``Returns`` section supports any reStructuredText formatting,
        including literal blocks::

            {
                'param1': param1,
                'param2': param2
            }

    Raises
    ------
    AttributeError
        The ``Raises`` section is a list of all exceptions
        that are relevant to the interface.
    ValueError
        If `param2` is equal to `param1`.

    """
    if param1 == param2:
        raise ValueError('param1 may not be equal to param2')
    return True


def example_generator(n):
    """Generators have a ``Yields`` section instead of a ``Returns`` section.

    Parameters
    ----------
    n : int
        The upper limit of the range to generate, from 0 to `n` - 1.

    Yields
    ------
    int
        The next number in the range of 0 to `n` - 1.

    Examples
    --------
    Examples should be written in doctest format, and should illustrate how
    to use the function.

    >>> print([i for i in example_generator(4)])
    [0, 1, 2, 3]

    """
    for i in range(n):
        yield i


class ExampleError(Exception):
    """Exceptions are documented in the same way as classes.

    The __init__ method may be documented in either the class level
    docstring, or as a docstring on the __init__ method itself.

    Either form is acceptable, but the two should not be mixed. Choose one
    convention to document the __init__ method and be consistent with it.

    Note
    ----
    Do not include the `self` parameter in the ``Parameters`` section.

    Parameters
    ----------
    msg : str
        Human readable string describing the exception.
    code : :obj:`int`, optional
        Numeric error code.

    Attributes
    ----------
    msg : str
        Human readable string describing the exception.
    code : int
        Numeric error code.

    """

    def __init__(self, msg, code):
        self.msg = msg
        self.code = code


class ExampleClass(object):
    """The summary line for a class docstring should fit on one line.

    If the class has public attributes, they may be documented here
    in an ``Attributes`` section and follow the same formatting as a
    function's ``Args`` section. Alternatively, attributes may be documented
    inline with the attribute's declaration (see __init__ method below).

    Properties created with the ``@property`` decorator should be documented
    in the property's getter method.

    Attributes
    ----------
    attr1 : str
        Description of `attr1`.
    attr2 : :obj:`int`, optional
        Description of `attr2`.

    """

    def __init__(self, param1, param2, param3):
        """Example of docstring on the __init__ method.

        The __init__ method may be documented in either the class level
        docstring, or as a docstring on the __init__ method itself.

        Either form is acceptable, but the two should not be mixed. Choose one
        convention to document the __init__ method and be consistent with it.

        Note
        ----
        Do not include the `self` parameter in the ``Parameters`` section.

        Parameters
        ----------
        param1 : str
            Description of `param1`.
        param2 : list(str)
            Description of `param2`. Multiple
            lines are supported.
        param3 : :obj:`int`, optional
            Description of `param3`.

        """
        self.attr1 = param1
        self.attr2 = param2
        self.attr3 = param3  #: Doc comment *inline* with attribute

        #: list(str): Doc comment *before* attribute, with type specified
        self.attr4 = ["attr4"]

        self.attr5 = None
        """str: Docstring *after* attribute, with type specified."""

    @property
    def readonly_property(self):
        """str: Properties should be documented in their getter method."""
        return "readonly_property"

    @property
    def readwrite_property(self):
        """list(str): Properties with both a getter and setter
        should only be documented in their getter method.

        If the setter method contains notable behavior, it should be
        mentioned here.
        """
        return ["readwrite_property"]

    @readwrite_property.setter
    def readwrite_property(self, value):
        value

    def example_method(self, param1, param2):
        """Class methods are similar to regular functions.

        Note
        ----
        Do not include the `self` parameter in the ``Parameters`` section.

        Parameters
        ----------
        param1
            The first parameter.
        param2
            The second parameter.

        Returns
        -------
        bool
            True if successful, False otherwise.

        """
        return True

    def __special__(self):
        """By default special members with docstrings are not included.

        Special members are any methods or attributes that start with and
        end with a double underscore. Any special member with a docstring
        will be included in the output, if
        ``napoleon_include_special_with_doc`` is set to True.

        This behavior can be enabled by changing the following setting in
        Sphinx's conf.py::

            napoleon_include_special_with_doc = True

        """
        pass

    def __special_without_docstring__(self):
        pass

    def _private(self):
        """By default private members are not included.

        Private members are any methods or attributes that start with an
        underscore and are *not* special. By default they are not included
        in the output.

        This behavior can be changed such that private members *are* included
        by changing the following setting in Sphinx's conf.py::

            napoleon_include_private_with_doc = True

        """
        pass

    def _private_without_docstring(self):
        pass
```

在使用sphinx生成手册的时候需要在*conf.py*中添加`sphinx.ext.napoleon`插件。
{: .notice--info}

### 3.3 sphinx风格的docstring注释

示例如下

``` python
# -*- coding: utf-8 -*-
"""Example Sphinx style docstrings.

This module demonstrates documentation as specified by the 
`Sphinx Python Style Guide`_. Docstrings may extend over multiple lines. 
Sections are created with a section header and a colon followed by a 
block of indented text.

Example:
    Examples can be given using either the ``Example`` or ``Examples``
    sections. Sections support any reStructuredText formatting, including
    literal blocks::

        $ python example_google.py

Section breaks are created by resuming unindented text. Section breaks
are also implicitly created anytime a new section starts.

Todo:
    * For module TODOs
    * You have to also use ``sphinx.ext.todo`` extension

.. _Sphinx Python Style Guide:
   https://pythonhosted.org/an_example_pypi_project/sphinx.html#full-code-example

"""

# sphinx 风格的docstring注释不支持变量注释，不过可以使用google风格的，实际上numpy风格
# 的变量注释和google风格是一样的
module_level_variable1 = 12345
module_level_variable2 = 98765
"""int: Module level variable documented inline.

The docstring may span multiple lines. The type may optionally be specified
on the first line, separated by a colon.
"""

# 函数的注释，注意这里type和param是分开的，会损失可读性
def function_with_types_in_docstring(param1, param2):
    """Example function with types documented in the docstring.

    `PEP 484`_ type annotations are supported. If attribute, parameter, and
    return types are annotated according to `PEP 484`_, they do not need to be
    included in the docstring:

    :param param1: The first parameter.
    :type param1: int
    :param param2: The second parameter.
    :type param2: str

    :returns: The return value. True for success, False otherwise.
    :rtype: bool

    .. _PEP 484:
        https://www.python.org/dev/peps/pep-0484/

    """


def function_with_pep484_type_annotations(param1: int, param2: str) -> bool:
    """Example function with PEP 484 type annotations.

    :param param1: The first parameter.
    :param param2: The second parameter.

    :returns: The return value. True for success, False otherwise.

    """

# 类方式的docstring注释
class ExampleClass(object):
    """The summary line for a class docstring should fit on one line.
    """

    def __init__(self, param1, param2, param3):
        """Example of docstring on the __init__ method.

        The __init__ method may be documented in either the class level
        docstring, or as a docstring on the __init__ method itself.

        Either form is acceptable, but the two should not be mixed. Choose one
        convention to document the __init__ method and be consistent with it.

        Note:
            Do not include the `self` parameter in the ``Args`` section.

        :param param1: The first parameter.
        :type param1: str
        :param param2: The second parameter.
        :type param2: int
        :param param3: The third parameter.

        """
        self.attr1 = param1
        self.attr2 = param2
        self.attr3 = param3  #: Doc comment *inline* with attribute

        #: list(str): Doc comment *before* attribute, with type specified
        self.attr4 = ['attr4']

        self.attr5 = None
        """str: Docstring *after* attribute, with type specified."""


    def example_method(self, param1, param2):
        """Class methods are similar to regular functions.

        Note:
            Do not include the `self` parameter in the ``Args`` section.

        :param param1: The first parameter.
        :type param1: str
        :param param2: The second parameter.
        :type param2: int

        :returns: The return value. True for success, False otherwise.
        :rtype: bool

        """
        return True

    def __special__(self):
        """By default special members with docstrings are not included.

        Special members are any methods or attributes that start with and
        end with a double underscore. Any special member with a docstring
        will be included in the output, if
        ``napoleon_include_special_with_doc`` is set to True.

        This behavior can be enabled by changing the following setting in
        Sphinx's conf.py::

            napoleon_include_special_with_doc = True

        """
        pass

    def __special_without_docstring__(self):
        pass

    def _private(self):
        """By default private members are not included.

        Private members are any methods or attributes that start with an
        underscore and are *not* special. By default they are not included
        in the output.

        This behavior can be changed such that private members *are* included
        by changing the following setting in Sphinx's conf.py::

            napoleon_include_private_with_doc = True

        """
        pass

    def _private_without_docstring(self):
        pass
```

## 4 使用sphinx生成手册

sphinx的使用在本文中不再赘述，可参考[sphinx官方手册](http://www.sphinx-doc.org/en/master/)，下文仅介绍使用sphinx的几个插件根据docstring自动生成python项目的使用手册。

正常情况下，一个python项目，建议在项目根目录下新建一个目录 **docs** ，在这个目录中存放手册文档（openstack社区每个项目都有一个这样的目录），在这个目录中运行

> sphinx-quickstart

该命令初始化sphinx项目，该命令会以交互式方式询问一些问题，大部分情况直接选默认，生成的配置会写入到 *conf.py* 文件，后期可以根据需要修改这个文件。

在这里我将创建一个 **python_comment** 的python项目（项目内容就是python各种风格的docstring示例代码），可点击 [这里](/attachments/python_comment.tar.gz) 下载该项目。

使用这个命令后，我们的项目目录结构为

    python_comment
    ├── docs
    │   ├── Makefile
    │   ├── _build
    │   ├── _static
    │   ├── _templates
    │   ├── conf.py
    │   ├── google_style.rst
    │   ├── index.rst
    │   ├── make.bat
    │   ├── modules.rst
    │   ├── numpy_style.rst
    │   └── sphinx_style.rst
    ├── google_style.py
    ├── numpy_style.py
    └── sphinx_style.py

下面需要修改 *conf.py* 配置文件，用于支持手册生成。

首先要做的修改是：让sphinx能够找到代码在哪里。sphinx会通过 *sys.path* 来找到代码的位置，所以如果是自己编写的项目，则需要将项目路径加入到 *sys.path* ，例如在python_comment项目中，需要添加如下代码到 *conf.py* 开头部分：

``` python
import os
import sys
sys.path.insert(0, os.path.abspath('..'))
```

其次，正如上文所述，为了让sphinx生成漂亮的手册，我们需要增加一些插件支持，仍然是修改 *conf.py* ，将 *extensions* 列表修改为：

``` python
extensions = [
    'sphinx.ext.autodoc', 
    'sphinx.ext.napoleon', 
    'sphinx.ext.todo'
]
```

现在我们剩下最后一步，编写rst文档来告诉sphinx应该生成哪些模块、类、函数的文档。而这一步通常不需要自己手动编写，使用 [sphinx-apidoc](http://www.sphinx-doc.org/en/1.4/man/sphinx-apidoc.html) 命令即可生成所有模块的rst文档，然后自己根据需要进行裁剪即可。例如在python_comment项目中，在python_comment目录下执行如下shell命令：

> sphinx-apidoc -f -o docs .

其中， *-f* 参数强制重写同名文件，*-o* 参数指定输出的目录，最后的"."则指定对于 python_comment 项目目录下的所有python文件生成rst文档

此时会在*docs*目录下看到新增加了4个文件：

    ├── modules.rst
    ├── google_style.rst
    ├── numpy_style.rst
    ├── sphinx_style.rst

*modules.rst* 相当于一个入口，引用了其他几个文件

然后，我们需要更改 *index.rst* 文件，让它引用 *modules.rst*，例如加入如下代码：

    .. toctree::
       :maxdepth: 2

       modules

此时，执行 `make html` 即可生成文档，例如使用 *classic* 模板生成文档如下图

![google_style_comment](/images/python_comment_1.png "google_style_comment")


## 5 参考

1. [https://realpython.com/documenting-python-code/](https://realpython.com/documenting-python-code/)
2. [http://www.sphinx-doc.org/en/1.6/ext/example_google.html?highlight=Python%20Docstrings](http://www.sphinx-doc.org/en/1.6/ext/example_google.html?highlight=Python%20Docstrings)
3. [http://www.sphinx-doc.org/en/1.6/ext/example_numpy.html#example-numpy](http://www.sphinx-doc.org/en/1.6/ext/example_numpy.html#example-numpy)
4. [https://pythonhosted.org/an_example_pypi_project/sphinx.html#full-code-example](https://pythonhosted.org/an_example_pypi_project/sphinx.html#full-code-example)
5. [https://gisellezeno.com/tutorials/sphinx-for-python-documentation.html](https://gisellezeno.com/tutorials/sphinx-for-python-documentation.html)
6. [https://medium.com/@eikonomega/getting-started-with-sphinx-autodoc-part-1-2cebbbca5365](https://medium.com/@eikonomega/getting-started-with-sphinx-autodoc-part-1-2cebbbca5365)
7. [http://www.sphinx-doc.org/en/1.4/man/sphinx-apidoc.html](http://www.sphinx-doc.org/en/1.4/man/sphinx-apidoc.html)

