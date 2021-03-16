## 比特币的数据结构

### 哈希指针 Hash Pointers

哈希指针指向一个结构体的哈希值（整个区块+其H()一起算出下一个值）

特征

- tamper-evident log
- 如果这个区块被篡改，则会影响后续所有区块，最终导致和本地存储的哈希指针对不上

### 默克尔树 Merkle Tree

比特币中，每个数据块其实是一种交易transaction

- 区块
    - Block header 块头：有根哈希值，没有交易具体内容
    - Block body 块身：有交易列表

Merkle Tree

- 节点类型
    - Full Node 全节点：保存Block header和Block body
    - Light Node 轻节点：只保存Block Header，如手机上的比特币钱包
- 只要存放root hash，就能检测出树中任意节点的修改
- Merkle proof：如何向轻节点证明某个交易写入区块链（复杂度为O(logN)，Proof of Membership）
- Proof of non-membership
    - 遍历验证，复杂度为O(n)
    - 可以对叶节点按哈希值大小进行排序，用二分法对相邻的数据块分别向上取哈希值，直到root hash验证，复杂度为O(logN)，称为sorted merkle tree，比特币没有采用

### 问题：央行如何发行数字货币

- 谁有权力发行
- 怎么验证交易有效性，防止双花攻击
    - 数字货币交易
        - Input：说明币的来源和支付人的公钥
        - Output：说明接收者的公钥Hash（即地址）
    - 交易信息写进区块链
        - 账本的内容需要取得分布式共识（Distributed consensus）
        - 分布式哈希表，即系统里许多节点共同维护

FLP Impossibility：在一个异步系统里，网络传输延迟没有上限，哪怕系统中有一个进程失败，无法达成共识

CAP Theorem，三个要素最多只能同时实现两点

- 一致性 Consistency
- 可用性 Availability
- 分区容错性 Partition tolerance

### 比特币共识协议

解决系统中有部分节点是恶意的，解决思路为过半数同意，其中谁有投票权

- 风险：Sybil attack 女巫攻击，利用少数节点控制多个虚假身份
- 比特币解决方案：工作量证明机制（算力投票机制）
    - 全网广播新的数据记录
    - 全网执行共识算法，即暴力求解数学难题
    - 率先解出难题的矿工获得记账权，产生新区块
    - 对外广播新区块，其他节点验证通过后加至主链
- 最长合法链
    - 分叉攻击
- 同时挖到矿，出现两个等长区块，则会维持一段时间，看哪个区块先被接上

## 比特币系统的实现

基于交易的账本模式

- UTXO: Unspent Transaction Outputs，未花费交易输出
- 比特币系统中，要确认一个地址的余额需要回顾以前所有的交易，并且找到所有给自己的比特币并相加

预防双花的机制

- 假设Alice收了了两笔交易，共计5 BTC（2+3）
- Alice拥有了两笔UTXO，可作为未来转钱给别人的input
- 当Alice想要转账给别人，矿工需要验证的是有没有在其他交易在先前的区块中已经使用过这笔Unspent Output
- 如果同一笔输出已经被发送过，就不是Unspent了

区块链是不可篡改的账本的特性只是概率上的保证，刚写入block的区块是容易篡改的，比特币采用6个confirmation来保障。

## 比特币网络工作原理

### 设计原则

simple, robust but not efficient

- 应用层 - 运行Bitcoin Blockchain
- 网络层 - 运行P2P Overlay Network

### 节点工作流程

每个节点都要维护一个等待上链的交易的集合，一个区块大小为1M，需要几秒才能传到大多数节点

- 监听到A→B的交易，就将其写入集合
- 如果同时有A→C的双花攻击，该节点不会再写入
- 如果监听到有同样一笔A→B交易，会将该集合中的该笔交易删除
- 如果监听到有一笔A→C的交易（同一个币来源），也会将该集合中A→这笔交易删除

## 比特币挖矿

为什么要挖矿

- Block reward 出块奖励：coinbase tx是唯一一个产生新币的途径
- 矿工费

挖矿：不断尝试nonce值，是Block header立德hash值≤给定的目标阈值

H(block header) ≤ target （target是难度为1的时候所对应的阈值，target越小，挖矿难度越大）

difficulty = (difficulty - 1 - target) / target

挖矿过程

- 每一次挖矿过程都是随机测试
- 每次试nonce构成了无记忆性
- 次数很多，但是成功率很低
- 出块时间服从指数分布
- 从任何一点开始，成功概率不变，所以给予算力成比例优势
- 挖矿并不是解数学题，挖矿难度是人为设定的

### 为什么要调整难度

出块时间太短容易出现分叉，分叉过多则会影响系统达成共识，危害系统安全性

BTC的储廥速度是10分钟，ETH出块速度是15秒（意味着ETH需要新的协议，ghost → orphan block不能简单丢弃，而是要给奖励，uncle reward）

### 如何调整挖矿难度

每2016个区块（约两周）调整一次目标阈值，存在Block header中，有个nbits，是编码的版本

target = target * (actual time / expected time)

actual time → 系统中产生2016个区块花费的时间

expected time → 产生2016个区块预计花费的时间（约14天）

恶意节点不调整代码中的target的话，诚实的矿工则不会认可

全节点

- 一直在线
- 在本地硬盘上维护完整的区块链信息
- 在内存里维护UTXO集合，以便于快速检验交易的正确性
- 监听比特币网络上的交易信息，验证每个交易的合法性
- 决定哪些交易会被打包到区块里
- 监听别的矿工挖出来的区块，验证其合法性
- 挖矿
    - 决定沿着哪条链挖下去
    - 当出现等长的分叉时，选择哪一个分叉

轻节点

- 不是一直在线
- 不用保存整个区块链，只需要保存每个区块的块头
- 不用保存全部交易，只需要保存与自己有关的交易
- 无法检验大多交易的合法性，只能检验与自己相关的那些交易的合法性
- 无法检测网上发布区块的正确性
- 可以验证挖矿的难度
- 只能检测哪个是最长链，不知道哪个是最长合法链

### 挖矿设备

- CPU
- GPU → 主要用于通用并行计算
- ASIC → Application Specific Integrated circuit
- 大型矿池
    - Pool Manager：负责全节点要做的事
    - Miner：计算hash值，通过POW分配收益
    - 如矿池达到51%以上算力
        - Forking attack，回滚交易
        - Boycott，全网抵制与B有关的任何交易

## 比特币分叉

### 分叉类型

- state fork
    - forking attack (deliberate fork)
- protocol fork（因为对BTC协议产生分歧而造成的分叉）
    - hard fork
        - 例如对block size limit的变化 1M  → 4M
        - 产生了永久性分叉
        - 两条链平行发展，各挖各的，互不认可，形成两种币
    - soft fork
        - 例如对block size limit的变化 1M  → 0.5M
        - 新节点挖小区块，即使旧节点挖出了大区块，也会被放弃，再次出现分叉
        - 旧节点挖大区块
        - 出现软分叉的情况
            - coinbase内容修改
            - P2SH: Pay to Script Hash

## 比特币的匿名性

### 破坏匿名性的方法

- 即使一笔交易生成多个inputs和outputs，这些inputs和outputs的地址也可能被人关联
- 地址账户和现实世界中的真实身份也可能产生关联
    - 防范比特币洗钱：盯住资金转入转出链

### 提高匿名性的方法

- Application Layer: coin mixing 把各种人混在一起
- Network Layer: 多路径转发以避免从节点的ip地址推算出真实身份

### 零知识证明

一方（证明者）向另一方（验证者）证明一个陈述是正确的，而无需透露除该陈述是正确的以外的人和信息

- 同态隐藏
    - 给定E(x)和E(y)，可以很容易计算出某些关于x,y的加密函数值（同态运算）
        - Alice把E(x)和E(y)发给Bob
        - Bob通过收到的E(x)和E(y)计算出E(x+y)的值
        - Bob同时计算E(7)的值，如果E(x+y)和E(7)相等，验证通过
- 盲签
    - 用户提供SerialNum（暗文），银行在不知道SerialNum的情况下返回签名Token，减少A的存款
    - 用户A把SerialNum和Token交给B完成交易
    - 用户B拿SerialNum和Token给银行验证，银行验证通过，增加B的存款
    - 银行无法把A和B联系起来
- 例如：证明某个比特币账户是我的（不泄露私钥） - 由私钥产生一个签名来证明所有权
- BTC的每一笔转账交易都要说明币的来源
- Zerocoin可以证明花的币是合法存在的，但不知道具体是哪一个

## 总结思考

- 转账交易不需要接收者在线
- 私钥丢失则失去对币的所有权，除非存在交易所中，但交易所有风险
- 私钥泄漏需要立即将账户中的钱转到另外的账户
- 转账时写错地址无法取消交易，也没办法追回
- 既然所有要写入区块链的交易都需要被验证正确性，为什么proof of burn中OP_RETURN会被区块接收：
    - 对于某个交易，我们需要验证输入脚本和输出脚本，而OP_RETURN是写在当前交易的输出脚本的，因此在本次验证中不会被检查到
- 在coinbase transaction中有收款人的地址，矿工如果想要偷答案则需要修改地址，会导致merkle tree发生改变，从而改变root hash，block header会发生改变，nonce也作废了
- 比特币系统里并没有取得严格意义上的共识，如分叉