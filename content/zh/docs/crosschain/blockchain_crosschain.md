---
title: 跨链技术原理与实战
aliases:
  - /docs/crosschain/blockchain_crosschain.html
---

# 跨链技术原理与实战

## 前言

目前区块链底层平台日渐多样，如老牌的 Hyperledger Fabric、Ethereum 等，以及国内的 Hyperchain、Z-ledger 等，而随着区块链应用生态越来越复杂，单链的性能有一定瓶颈，链与链之间的协同与交互（信息同步、共享、合约互操作等）也成为了链和应用生态发展的重要部分。

本文是对跨链技术的概念与主流解决方案的梳理。

## 跨链技术概览

因为底层链设计、共识算法、网络结构等组件的相似性，同构区块链之间的交互比较容易，但异构区块链则相对复杂，往往难以直接进行交互，而需要两条链之间有一些辅助平台/服务来进行数据格式转换等。

### 跨链机制

目前跨链主要由以下几种解决方案：

1. 公证人机制
2. 哈希锁定
3. 分布式私钥控制
4. 侧链/中继链

#### 公证人机制

公证人机制是一种通过第三方中介协助不同链之间交互的机制，本质上是两方共同信任一个第三方，让其对跨链数据或跨链交互操作进行验证和转发。这种方式能很好地支持异构区块链，但是是一种中心化方式。

很多数字货币交易所就是通过这样的方式进行不同数字货币之间的交易和转换，本质上是交易所在撮合交易，效率等都较高，但是存在一定安全风险，且只支持资产的交换。

#### 哈希锁定

哈希锁定最早出现在比特币的闪电网络，是通过哈希锁和时间锁保障跨链双方资产的一种方式。其中时间锁是将交易限制在一定时间内，超时则交易失效，从而避免损失，但这种方式同样只能实现资产的交换，而无法实现资产的转移。

#### 侧链

侧链是一种双向锚定的技术，最开始的侧链是相对于比特币主链而言的，如 BTC-Relay，在这条侧链上可以对比特币进行新特性的研发和测试，且当大量用户在比特币网络上进行交易时，使用侧链可以有效地拓展网络的吞吐量。例如，在 Ethereum 主链上进行资产交易和价值转移，而在 Ethereum 侧链上可以进行一些对 tps 要求较高的 DApp 运行等。

而同一条主链的不同侧链也可以借助主链来进行一些交互，这就是借助测链进行跨链的基本原理。

#### 中继链

中继链则是上述侧链和公证人机制的一种综合应用，通过设定跨链交互机制（如 Cosmos 的 IBC）来实现异构链之间的信息共享与交互。需要进行跨链的各个平行链连接到一个中继链来辅助交易的验证和交互。


## 跨链技术实践

### 开发实战

目前在做一个 BaaS 平台的跨链功能，其基础架构如下：

![cross_chain_framework](https://cdn.jsdelivr.net/gh/pseudoyu/image-hosting@master/images/cross_chain_framework.svg)

子链主要是实现各类业务和应用的链，当子链要与其他链进行跨链业务交互时，它需要执行跨链合约，而我们提供了一个跨链网关来对这些跨链合约进行监听。针对异构区块链。如 Hyperledger Fabric、Ethereum，我们将提供不同的适配器来实现跨链 SDK 与跨链网关之间的交互，适配器提供跨链合约信息查询功能。当另一条业务链的 SDK 接收到跨链合约方法时，如果是合约互调用或数据传递，则直接调用对应的合约方法。

我主要做的是跨链适配器接口这一部分，适配器作为针对不同链的插件嵌入跨链网关中从而适配不同的应用链，能够很好地协助跨链网关实现对交易的监听、同步与执行。

而在具体实现中，如在 Fabric 网络中，则是通过子链调用跨链业务合约，而跨链业务合约统一调用一个适配器的合约，在这个适配器合约中，我们实现了交易信息传入，通过 Fabric 事件机制来进行监听（即在合约中实现 `SetEvent` 方法，而在适配器中对相应事件进行注册，从而实现对跨链合约的监听。

关于 Fabric 事件监听相关细节及实现详情见 《[Hyperledger Fabric Go SDK 事件分析](../hyperledger_fabric/blockchain_hyperledger_fabric_gosdk_event.md)》。

### 功能拓展

目前趣链科技的 [BitXHub 跨链平台](https://meshplus.github.io/bitxhub/bitxhub/introduction/summary/)是业界实现得比较完善的开源跨链解决方案，其架构如下：

![bitxhub_structure](https://cdn.jsdelivr.net/gh/pseudoyu/image-hosting@master/images/bitxhub_structure.png)

主要通过中继链、网关和插件机制对跨链流程中的功能、安全性和灵活性等进行了优化，并且设计了 IBTP 链间通用传输协议配合“网关+中继链”的架构来解决跨链交易中的验证、路由等问题。

## 总结

以上就是对跨链技术的概念梳理与实战总结，为了对跨链机制的各个环节有更深入的了解，之后也将会对目前正在做的跨链服务和 BitXHub 平台进行更深入的剖析和源码解读。

## 参考资料

> 1. [关于跨链技术的分析和思考](https://tech.hyperchain.cn/blockchain-interoperability/)
> 2. [跨链的简要研究：从原理到技术](https://zhuanlan.zhihu.com/p/92667917)
> 3. [跨链技术平台 BitXHub](https://github.com/gocn/opentalk/tree/main/PhaseTen_BitXHub)
> 4. [区块链跨链技术之哈希时间锁](https://yuanxuxu.com/2020/08/05/区块链跨链技术之哈希时间锁/)
> 5. [Hyperledger Fabric Go SDK 事件分析](https://www.pseudoyu.com/zh/2021/09/01/blockchain_hyperledger_fabric_gosdk_event/)
> 6. [BitXHub Document](https://meshplus.github.io/bitxhub/bitxhub/introduction/summary/)
> 7. [十问 BitXHub:谈谈跨链平台的架构设计](https://tech.hyperchain.cn/bitxhub-design-thinking/)