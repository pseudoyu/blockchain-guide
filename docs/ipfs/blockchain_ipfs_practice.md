# IPFS本地节点搭建（命令行）

## 前言

上一篇《[IPFS分布式文件存储原理](https://www.pseudoyu.com/zh/2021/03/25/blockchain_ipfs_structure/)》对于IPFS系统的设计理念、功能、工作原理及IPNS做了详细的介绍，那么，如何在本地搭建一个IPFS节点呢？

本文在`macOS 11.2.3`系统上搭建了一个IPFS节点（命令行版本），并对文件上传、下载、网络同步、`pin`、`GC`、`IPNS`等进行了实际操作，以加深对IPFS工作原理的理解。

## 代码实践

### 安装

```sh
wget https://dist.ipfs.io/go-ipfs/v0.8.0/go-ipfs_v0.8.0_darwin-amd64.tar.gz
tar -xvzf go-ipfs_v0.8.0_darwin-amd64.tar.gz
cd go-ipfs
./install.sh
ipfs --version
```

### 启动

```sh
# 启动节点
ipfs init

# 上传文件
ipfs add ipfs_init_readme.png

# 上传文件并且只输出哈希值
ipfs add -q ipfs_init_readme.png

# 上传目录
ipfs add -r [Dir]

# 查看文件
ipfs cat /ipfs/QmQPeNsJPyVWPFDVHb77w8G42Fvo15z4bG2X8D2GhfbSXc/readme
ipfs cat /ipfs/QmQPeNsJPyVWPFDVHb77w8G42Fvo15z4bG2X8D2GhfbSXc/quick-start

# 查看自己上传的文件
ipfs cat QmaP3QS6ZfBoEaUJZ3ZfRKoBm3GGuhQSnUWtkVCNc8ZLTj

# 查看图片并输出到文件
ipfs cat QmfViXYw7GA296brLwid255ivDp1kmTiXJw1kmZVsg7DFH > ipfsTest.png

# 下载文件
ipfs get QmfViXYw7GA296brLwid255ivDp1kmTiXJw1kmZVsg7DFH -o ipfsTest.png

# 压缩并下载文件
ipfs get QmfViXYw7GA296brLwid255ivDp1kmTiXJw1kmZVsg7DFH -Cao ipfsTest.png
```

![ipfs_init_readme](https://raw.githubusercontent.com/pseudoyu/image_hosting/master/hugo_images/ipfs_init_readme.png)

### 开启/加入服务

```sh
# 查看当前节点信息 
ipfs id

# 查看IPFS配置信息
ipfs config show

# 开启节点服务器
ipfs daemon
```

API服务，默认在5001端口，可以通过 http://localhost:5001/webui 进行访问

![ipfs_webui](https://raw.githubusercontent.com/pseudoyu/image_hosting/master/hugo_images/ipfs_webui.png)

网关服务，默认在8080端口，在浏览器里访问文件需要借助于IPFS提供的网关服务，由浏览器先访问到网关，网关去获取IPFS网络杀过了的文件。通过 http://localhost:8080/ipfs/[File Hash] 来访问上传到ipfs的文件

### 文件操作

```sh
# 列出文件
ipfs files ls

# 创建目录
ipfs files mkdir

# 删除文件
ipfs files rm

# 拷贝文件
ipfs files cp [File Hash] /[Dest Dir]

# 移动文件
ipfs files mv [File Hash] /[Dest Dir]

# 状态
ipfs files stat

# 读取
ipfs files read
```

### 使用IPNS来解决文件更新问题

```sh
# 使用IPNS发布内容以自动更新
ipfs name publish [File Hash]

# 查询节点id指向的Hash
ipfs name resolve

# 有多个站点需要更新，可以新产生一个秘钥对，使用新的key发布
ipfs key gen --type=rsa --size=2048 mykey
ipfs name publish --key=mykey  [File Hash] 
```

### Pinning

当我们向IPFS网络请求文件时，IPFS会把内容先同步的本地提供服务，使用Cache机制处理文件以防止存储空间不断增长，如果文件一段时间未被使用则会被“回收”，Pining的作用就是确保文件在本地不被“回收”。

```sh
# pin一个文件
ipfs pin add [File Hash]

# 查询某一个Hash是否被pin
ipfs pin ls [File Hash]

# 删除pin的状态
ipfs pin rm -r [File Hash]

# GC操作
ipfs repo gc
```

## 总结

本文主要在本地部署了IPFS文件系统并对基本操作进行了尝试，基于`macOS 11.2.3`和`go-ipfs_v0.8.0_darwin-amd64`版本，不同系统操作可能会因版本或依赖问题不一样，如有错漏，欢迎交流指正。

## 参考资料

> 1. [IPFS官网](https://ipfs.io)