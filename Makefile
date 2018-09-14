# Makefile for Sphinx documentation
#

# You can set these variables from the command line.
BUILDDIR    = _site
SERVERTOOL  = /Users/apple/bin/alivm

.PHONY: preview
preview:
	bundle exec jekyll serve

.PHONY: server
server:
	bundle exec jekyll build
	@echo
	@echo "Build finished. Upload to server."
	cd $(BUILDDIR) && $(SERVERTOOL) put . /webdata

.PHONY: server2
server2:
	bundle exec jekyll build
	@echo
	@echo "Build finished. Upload to server."
	cd $(BUILDDIR)/安全研究 && $(SERVERTOOL) put . /webdata/安全研究
	cd $(BUILDDIR)/漏洞分析 && $(SERVERTOOL) put . /webdata/漏洞分析
	cd $(BUILDDIR)/其他 && $(SERVERTOOL) put . /webdata/其他
	cd $(BUILDDIR)/images && $(SERVERTOOL) put . /webdata/images
	cd $(BUILDDIR)/工具使用 && $(SERVERTOOL) put . /webdata/工具使用
	cd $(BUILDDIR)/sitemap && $(SERVERTOOL) put . /webdata/sitemap
	cd $(BUILDDIR)/page2 && $(SERVERTOOL) put . /webdata/page2
	cd $(BUILDDIR)/渗透测试 && $(SERVERTOOL) put . /webdata/渗透测试
	cd $(BUILDDIR)/about && $(SERVERTOOL) put . /webdata/about
	cd $(BUILDDIR)/tags && $(SERVERTOOL) put . /webdata/tags
	cd $(BUILDDIR)/search && $(SERVERTOOL) put . /webdata/search
	cd $(BUILDDIR)/人工智能 && $(SERVERTOOL) put . /webdata/人工智能
	cd $(BUILDDIR)/year-archive && $(SERVERTOOL) put . /webdata/year-archive
	cd $(BUILDDIR)/attachments && $(SERVERTOOL) put . /webdata/attachments
	cd $(BUILDDIR)/404 && $(SERVERTOOL) put . /webdata/404
	cd $(BUILDDIR)/categories && $(SERVERTOOL) put . /webdata/categories
	cd $(BUILDDIR) && $(SERVERTOOL) put feed.xml /webdata
	cd $(BUILDDIR) && $(SERVERTOOL) put site.json /webdata
	cd $(BUILDDIR) && $(SERVERTOOL) put index.html /webdata
	cd $(BUILDDIR) && $(SERVERTOOL) put sitemap.xml /webdata
	cd $(BUILDDIR) && $(SERVERTOOL) put atom.xml /webdata

