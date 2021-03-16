### Bitcoin Core客户端

比特币的实现
- Bitcoin-QT
- Satoshi-client

**特点**

- 连接至比特币网络
- 可验证区块链
- 可以发送与接收区块链

**网络**
- Mainnet
- Testnet
- Regnet

![blockchain_bitcoin_core_network](https://raw.githubusercontent.com/pseudoyu/image_hosting/master/hugo_images/blockchain_bitcoin_core_network.png)
![blockchain_bitcoin_core_mainnet_testnet](https://raw.githubusercontent.com/pseudoyu/image_hosting/master/hugo_images/blockchain_bitcoin_core_mainnet_testnet.png)
![blockchain_bitcoin_core_regnet_testnet](https://raw.githubusercontent.com/pseudoyu/image_hosting/master/hugo_images/blockchain_bitcoin_core_regnet_testnet.png)

### Debug Console

与比特币区块链交互的工具

**Blockchain**

- getblockchaininfo: 返回有关区块链处理的各种状态信息
- getblockcount: 返回区块链中的块数
- verifychain: 验证区块链数据库

**Hash**

- getblockhash: 返回所提供的区块哈希值
- getnetworkhashps: 基于指定数量的最近块，返回每秒网络哈希数
- getbestblockhash: 返回最佳块的哈希值

**Blocks**

- getblock: 返回块信息的详细信息
- getblockheader: 返回有关区块头信息
- generate: 立即将指定数量的块挖矿到钱包中的一个地址

**Wallet**

- getwalletinfo: 返回一个对象，该对象包含有关钱包状态的各种信息
- listwallets: 返回当前加载的钱包列表
- walletpassphrasechange: 更改钱包密码

**Mempool**

- getmempoolinfo: 返回内存池活动状态的详细信息
- getrawmempool: 返回内存池中的所有交易详细信息
- getmempoolentry: 返回给定交易的内存池数据

**Transaction**

- getchaintxstats: 计算关于链中交易总数和速率的统计数据
- getrawtransaction: 返回原始交易数据
- listtransactions: 返回给定帐户的交易列表

**Signature**

- signrawtransaction: 签署原始交易的输入
- signmessage: 使用地址的私钥对信息进行签名
- dumpprivkey: 获取私钥

**Network**

- getnetworkinfo: 返回P2P网络的状态信息
- getpeerinfo: 返回每个连接网络节点的数据
- getconnectioncount: 返回节点的连接数

**Mining**

- getmininginfo: 返回包含挖掘相关信息的对象
- getblocktemplate: 返回构造块所需的数据
- prioritisetransaction: 以较高或较低的优先级接受交易进入挖掘的块