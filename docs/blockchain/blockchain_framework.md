## 区块链框架

- 交易
- 钱包
- 签名
- 内存池
- 网络
- 共识机制
- 哈希
- 区块
- 区块链

### 哈希

区块链使用的是SHA256(Secure Hashing Algorithm 256 bits)
![blockchain_sha256](https://raw.githubusercontent.com/pseudoyu/image_hosting/master/hugo_images/blockchain_sha256.png)
```javascript
var SHA256 = require("crypto-js/sha256");

const data1 = "Blockchain Rock!";
const dataObject = {
    id: 1,
    body: "With Object Works too",
    time: new Date().getTime().toString().slice(0,-3)
  };

function generateHash(obj) {
  return SHA256(JSON.stringify(obj));
}

console.log(`SHA256 Hash: ${generateHash(data1)}`);
console.log("************************************");
console.log(`SHA256 Hash: ${generateHash(dataObject)}`);
```

### 区块

**区块头**

- 前一个区块的Hash
- 时间戳
- Merkle Root
- Nonce
    - Block Data + Nonce = Hash value

**挖矿难度**

- 000000HASHVALUE

**区块大小**

- 1MB (Bitcoin)

**哈希**

即使数据产生很微小的变化，哈希值也会截然不同，如以下Demo所示

```javascript
const SHA256 = require('crypto-js/sha256');

class Block {
  constructor(data){
    this.id = 0;
        this.nonce = 144444;
        this.body = data;
        this.hash = "";
    }

    generateHash() {
        let self = this;
        var promise = new Promise((resolve, reject) => {
          setTimeout(() => {
          this.hash = SHA256(self);
            resolve(this);
          }, 1000)

          setTimeout(() => {
            reject("SOMETHING WRONG!!!");
          }, 2000)
        });
        return promise;
    }
}

module.exports.Block = Block;
```

```javascript
const BlockClass = require('./block.js');

const block = new BlockClass.Block("Test Block");

block.generateHash().then((result) => {
  console.log(`Block Hash: ${result.hash}`);
  console.log(`Block: ${JSON.stringify(result)}`);
}).catch((error) => {console.log(error)});
```

### 区块链

存储网络中所有交易历史记录的账本
![blockchain_overview](https://raw.githubusercontent.com/pseudoyu/image_hosting/master/hugo_images/blockchain_overview.png)
[Demo](https://andersbrownworth.com/blockchain/blockchain)

### Network

- P2P网络：不同用户之间共享信息和资源的一种分布式网络
  - 分布式网络：分布在不同地域的网络互相连接
  ![blockchain_network](https://raw.githubusercontent.com/pseudoyu/image_hosting/master/hugo_images/blockchain_network.png)

- 中心化网络：所有人都连接至一个（或一组）中心化网络
- 去中心化网络：没有一个单点网络可以拥有所有的信息
- 分布式网络：每个人都得到一份信息备份，且都拥有访问权限

### 内存池

交易脱离内存池的原因

- 交易过期（14天）
- 在以交易费排序的结构中交易处于内存池底部
- 交易已经被一个区块包含
- 交易有未确认的祖先区块被区块包含

### 共识机制

网络如何对交易达成信任/一致

**PoW(Proof of Work)**

- 计算消耗大（算力），但是很容易检验正确性
- 比特币网络
  - 10分钟左右（6个确认）
  - 动态调整难度
  - 消耗大量能源
  - 如果矿工（矿池）拥有大量资源则有中心化风险

**PoS (Proof of Stake)**

- 通过与系统相关的用户（权益持有者）投票来达成共识
- Nothing at Stake问题：在所有区块都投注
  - 同时在多个链上创建区块的用户会遭到惩罚
  - 在错误链上创建区块的用户会遭到惩罚

应用

- 以太坊正在向PoS转变
- DASH
- LISK
    - DPoS (Delegated Proof of Stake)委任权益证明

**DBFT (Delegated Byzantine Fault Tolerance)**

通过对节点分配不同的角色来达成共识

- 降低开销
- 避免分叉
- 问题
  - 不诚实的发言者
  - 不诚实的委任者

### 钱包

- 私钥
- 公钥
- 钱包地址

**ECDSA (One-way Elliptic Curve Digital Signature Algorithm)**

- 通过私钥生成公钥
- 单向，不能逆推

**生成钱包地址**

- 通过SHA256和RIPEMD160来生成钱包地址
- 通过Base58Check来保障其可读性

**流程**
![blockchain_wallet_generate1](https://raw.githubusercontent.com/pseudoyu/image_hosting/master/hugo_images/blockchain_wallet_generate1.png)
![blockchain_wallet_generate2](https://raw.githubusercontent.com/pseudoyu/image_hosting/master/hugo_images/blockchain_wallet_generate2.png)

**钱包类型**
![blockchain_wallet_type](https://raw.githubusercontent.com/pseudoyu/image_hosting/master/hugo_images/blockchain_wallet_type.png)
- Non-Deterministic Wallet
- Deterministic Wallet
    - Sequential Deterministic Wallet
    - Hierarchical Deterministic (HD) Wallet
        ![blockchain_wallet_hd](https://raw.githubusercontent.com/pseudoyu/image_hosting/master/hugo_images/blockchain_wallet_hd.png)

**私钥**

- 一个256位随机数，介于1和2^256之间
- 格式
  - Hex
  - WIF(Base58Check)
  - WIF-Compressed(Base58Check added suffix 0x01 before encoding)

Entropy 熵

- 混乱与不可预测状态
- 应用
  - Python: Random
  - Java: SecureRandom

### 签名

为区块链上每笔交易提供证明

- 私钥签名
- 公钥验证

**交易周期**

- Inputs
- Outputs
![blockchain_transaction_lifecycle](https://raw.githubusercontent.com/pseudoyu/image_hosting/master/hugo_images/blockchain_transaction_lifecycle.png)

- UTXO (Unspent transaction output in bitcoin)
- 广播到区块链