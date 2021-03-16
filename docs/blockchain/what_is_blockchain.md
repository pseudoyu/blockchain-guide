## 区块链概念

### 传统数据库 vs. 区块链数据库

**传统数据库**
- 网络
  - 中心化
- 功能
  - Create 创建
  - Read 读取
  - Update 更新
  - Delete 删除
- 可变性
  - 可变
- 权限
  - 中心化
- 透明度
  - 低

**区块链数据库**
- 网络
  - 去中心化
    - 给予节点控制权
    - 必须达成共识
- 功能
  - Read，Append，Validate
    - 具有准确的历史记录
    - 读取和写入更快
    - 必须达成共识
- 可变性
  - 不可变
    - 永久保存历史记录
    - 占据较大存储空间
- 权限
  - 分布式
    - 安全性高
    - 不能撤回交易
- 透明度
  - 高
    - 每个人都能看到
    - 没有权限控制机制

### 是否需要区块链

- 是否需要数据库？
- 是否需要共享写入权限？
- 是否需要多方达成信任？
- 能否脱离第三方机构运作？
- 能否脱离权限控制机制运作？

### 区块链类型

- 公链：交易是否要公开
- 私链：是否需要其他公司（机构）访问数据
- 联盟链：权限控制

### P2P网络 vs. Client-Server网络

- Client-Server
  - Client发出请求
  - Server响应请求
- P2P网络
  - 网络中多个节点共享信息和资源

### 区块链数据

![blockchain_btc_data](https://raw.githubusercontent.com/pseudoyu/image_hosting/master/hugo_images/blockchain_btc_data.png)

Bitcoin Improvement Proposal (BIP)
- 对Bitcoin core客户端做出改变的提案文件

### 分叉

![blockchain_fork_type](https://raw.githubusercontent.com/pseudoyu/image_hosting/master/hugo_images/blockchain_fork_type.png)

- 硬分叉：永久性改变
  - Bitcoin Cash：提升了比特币区块链大小至2M
- 软分叉：暂时性改变
  - Segregated Witness（Segwit）
- 源码分叉
  - 源程序的一个副本，无关联，一般用于山寨币
    - Litecoin