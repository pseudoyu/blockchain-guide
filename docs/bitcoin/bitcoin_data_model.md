## 比特币数据模型

### 区块头

- 前一个区块的哈希值
- 时间戳
- Merkle Root
- Nonce

### Block Body
![blockchain_bitcoin_data_transaction](https://raw.githubusercontent.com/pseudoyu/image_hosting/master/hugo_images/blockchain_bitcoin_data_transaction.png)
- 交易
    - 输入
        - UTXO: Unspent outputs from another Transaction
            - 必须以整体被花费，不能划分，多余部分转回源账户
        - 所有输入都可以追溯至输出
    - 输出
    - 双重Hash形式
      - SHA256(SHA256(源交易)) = Transhaction Hash

## 交易模型
![blockchain_bitcoin_data_transaction_detail](https://raw.githubusercontent.com/pseudoyu/image_hosting/master/hugo_images/blockchain_bitcoin_data_transaction_detail.png)

- Version
- Input count
- Input info - Unlocking Script
    - Input来源
    - 核对Input是否可用
    - Input info细节
    ![blockchain_bitcoin_data_transaction_input_info](https://raw.githubusercontent.com/pseudoyu/image_hosting/master/hugo_images/blockchain_bitcoin_data_transaction_input_info.png)
      - **Previous output hash** - 所有输入都能追溯回一个输出(UTXO)，这指向包含将在该输入中花费的UTXO，该UTXO的哈希值在这里以相反的顺序保存
      - **Previous output index** - 一个交易可以有多个由它们的索引号引用的UTXO，第一个索引是0
      - **Unlocking Script Size** - Unlocking Script的字节大小
      - **Unlocking Script** - 满足UTXO Unlocking Script的哈希
      - **Sequence Number** - 默认为ffffffff
- Output Count
- Output Info - Locking Script
    - 输出了多少比特币
    - 未来支出的条件
    - 存储在输出信息中的数据
    ![blockchain_bitcoin_data_transaction_output_info](https://raw.githubusercontent.com/pseudoyu/image_hosting/master/hugo_images/blockchain_bitcoin_data_transaction_output_info.png)
        - **Amount** - 以Satoshis(最小的比特币单位)表示的输出比特币数量，10^8 Satoshis = 1比特币
        - **Locking Script Size** - 这是Locking Script的字节大小
        - **Locking Script** - 这是Locking Script的哈希，它指定了使用此输出必须满足的条件
- Locktime
    - 一个交易可以被最早添加到区块链的时间/块
    - 如果 <500 million，读取块高度
    - 如果 >500 million，读取时间戳

## 比特币脚本

记录在每个交易中的指令列表，当被执行时确定交易是否有效以及比特币是否可以使用

### 脚本
![blockchain_bitcoin_script_detail](https://raw.githubusercontent.com/pseudoyu/image_hosting/master/hugo_images/blockchain_bitcoin_script_detail.png)
```bash
<sig> <pubKey> OP_DUP OP_HASH160 <pubKeyHash> OP_EQUALVERIFY OP_CHECKSIG
```
- 基于Stack
- 存储常数
- 使用Opcodes
    - Push (Add)
    - Pop (Remove)
    - Etc.
- 从左至右执行

### 交易
![blockchain_bitcoin_script_locking_unlocking](https://raw.githubusercontent.com/pseudoyu/image_hosting/master/hugo_images/blockchain_bitcoin_script_locking_unlocking.png)
![blockchain_bitcoin_script_relationship](https://raw.githubusercontent.com/pseudoyu/image_hosting/master/hugo_images/blockchain_bitcoin_script_relationship.png)

### 标准脚本符号
- <>包含的是要被推入stack的数据
- 没有<>包含，以OP_为前缀的是操作符（OP可省略）

### 脚本的特征
- 非图灵完备
    - 没有循环或者复杂的流程控制
    - 执行是确定性的
    - 简单、安全
- 无状态验证
    - 脚本执行之前或之后没有保存任何状态
    - 脚本之间是独立的
    - 无论脚本在哪里执行，都提供可预测性

### 可以嵌入数据
![blockchain_bitcoin_script_embedding_data](https://raw.githubusercontent.com/pseudoyu/image_hosting/master/hugo_images/blockchain_bitcoin_script_embedding_data.png)