---
title: Hyperledger Fabric 系统架构详解
aliases:
  - /docs/hyperledger_fabric/blockchain_hyperledger_fabric_structure.html
---

# Hyperledger Fabric 系统架构详解

## 前言

因为毕业 Case Study 的项目主要是基于`Ethereum`公链，也没有面向企业的应用场景，所以之前对`Hyperledger Fabric`的了解大多只是停留在它的权限管理机制、通道、灵活的智能合约编写等几个特色的概念，对它的架构、各个节点的角色、运行机制等都是一知半解。最近在上 HKU 的`<FITE3011 Distributed Ledger and Blockchain>`课程，教授对`Hyperledger Fabric`的工作原理、网络搭建及链码相关的知识做了很详细的讲解，受益匪浅，通过本文来梳理一下，如有错漏，欢迎交流指正。

## Hyperledger 概述

要学习`Hyperledger Fabric`，先来看看它的母项目`Hyperledger`是什么。

企业级应用有较复杂的业务逻辑和参与者角色划分，对于业务执行效率、安全性要求很高，并且针对常见的如支付、数据/信息交易等场景，隐私保护也是重中之重，因此，常见的比特币、以太坊等公链并不符合大部分企业应用需求。但是区块链的分布式、不可篡改的历史账本等特性在溯源、跨境电商等场景中又能够避免因各个国家/地区法律法规、货币等造成的复杂操作流程，大大提高效率。因此，针对企业的联盟链也在不断发展。

联盟链严格意义上并不是真正的“去中心化”，它通过引入了权限管理机制（结合企业在现实业务中的角色）来弱化对节点作恶的预防机制，从而能提高效率、应对复杂的业务逻辑。

其中，`Hyperledger`是由 Linux 基金会维护的一组专注于跨行业分布式技术的开源项目，旨在创建企业级、开源、分布式的分类框架和代码库来支持业务用例，提供中立、开放和社区驱动的基础设施；建立技术社区并推广，开发区块链和共享账本概念验证、使用案例、试验和部署；建立行业标准，鼓励更多企业参与到分布式账本技术的建设和应用中来，形成一个开放的生态体系；教育公众关于区块链科技的市场机会。

### 设计理念

![hyperledger_design_philosophy](https://cdn.jsdelivr.net/gh/pseudoyu/image-hosting@master/images/hyperledger_design_philosophy.png)

`Hyperledger`有如下几个核心设计理念：

1. 它针对企业具体的业务场景提升效率，并且对溯源等场景有着独特优势，每个企业都可以针对自己的场景维护独立的`Hyperledger`项目，因此，它不需要像公链一样通过数字货币来激励用户参与区块链系统。
2. 企业的应用场景较为复杂，往往 Hyperledger 只是在其中参与了某个或某些环节，因此与其他现有系统的交互必不可少，因此 Hyperledger 在设计上注重配备完整的 API 以供其他系统调用与交互。
3. `Hyperledger`的框架结构是模块化、可拓展，企业可以根据具体的业务需求选择不同的模块，避免复杂的业务逻辑和臃肿的系统。
4. 企业应用的安全性是重中之重，尤其是许多应用场景牵扯到高价值交易或敏感数据，因此提供了很多机制来保障安全性（如`Fabric`的通道机制等）
5. 除了与现有的系统交互外，企业未来的区块链应用中还可能会和很多不同的区块链网络进行交互，因此大部分智能合约/应用应该具备跨区块链网络的可移植性，以形成更复杂和强大的网络。

![hyperledger_family](https://cdn.jsdelivr.net/gh/pseudoyu/image-hosting@master/images/hyperledger_family.png)

#### 框架

`Hyperledger`下有如下几个项目，其中`Fabric`目前应用最为广泛，本文也将主要介绍`Fabric`区块链网络
- Burrow
- Fabric
- Grid
- Indy
- Iroha
- Sawtooth

#### 工具

1. `Hyperledger Cello`。主要用于更方便地搭建和管理区块链服务，降低项目框架部署、维护的复杂度；可以用来搭建区块链 BaaS 平台；可以通过 Dashboard 来创建和管理区块链，技术人员可以更方便地进行开发和部署；可以将 SaaS 部署模型引入区块链系统，帮助企业进一步开发框架。
2. `Hyperledger Explorer`。是一个可视化区块链的操作工具，可以用于创建对用户友好的 Web 应用程序；是首个`Hyperledger`的区块链浏览器，用户可以查看/调用/部署/查询交易、网络、智能合约、存储等信息。

## Hyperledger Fabric

我们着重来讲讲其中应用最广泛的`Fabric`项目，它是由 Linux 基金会维护的一个模块化、可拓展的区块链联盟链项目，不依赖任何加密货币，它对有着共同目标（业务需求）但彼此不完全信息的实体之间的业务提供了保护，例如跨境电商、资金交易、溯源等。

### 架构

![ethereum_architecture_simple](https://cdn.jsdelivr.net/gh/pseudoyu/image-hosting@master/images/ethereum_architecture_simple.png)

在大部分公链中，架构为`Order - Execute - Validate - Update State`。如比特币区块链中，如果有一个新交易，会先采用 PoW 机制对 Block 进行排序，然后比特币网络中的每个节点逐个进行验证，最后更新状态。因为需要依序进行验证，这种方式决定了其执行效率相对较低。

而`Fabric`采用了`Execute - Order - Validate - Update State`架构。

![hyperledger_fabric_architecture](https://cdn.jsdelivr.net/gh/pseudoyu/image-hosting@master/images/hyperledger_fabric_architecture.png)

收到一笔新的交易后，首先提交至背书节点本地模拟交易执行（并背书），再将已背书交易排序并广播，各个节点对交易进行验证后更新状态。

![hyperledger_fabric_architecture_complete](https://cdn.jsdelivr.net/gh/pseudoyu/image-hosting@master/images/hyperledger_fabric_architecture_complete.png)

正如上述联盟链特性中所述，`Fabric`网络的加入需要得到许可（身份验证），`Fabric`网路中的每个节点都有自己的身份。

总的来说，`Fabric`通过模块化、可插拔的架构来支持企业的复杂业务场景，通过身份验证（绑定现实身份）来弱化节点作恶，使用通道机制大大提升了系统的安全性和隐私保护。

#### MSP 成员服务提供商

那么，参与`Fabric`网络的身份是怎样管理的呢？

`Fabric`有一个 MSP(Membership Service Provider)成员管理提供商，它主要用来管理 CA 证书来验证哪些成员是可信任的。`Fabric CA`模块是独立的，可以管理证书服务，也可以允许第三方 CA 的接入，大大拓展的系统的应用范围。

![hyperledger_fabric_ca_structure](https://cdn.jsdelivr.net/gh/pseudoyu/image-hosting@master/images/hyperledger_fabric_ca_structure.png)

如上图所示，`Fabric CA`提供了客户端和 SDK 两种方式来和 CA 进行交互，每个`Fabric CA`都有一个根 CA 或中间 CA，为了进一步提高 CA 的安全性，可以采用集群来搭建中间 CA。

![hyperledger_fabric_ca_hierarchy](https://cdn.jsdelivr.net/gh/pseudoyu/image-hosting@master/images/hyperledger_fabric_ca_hierarchy.png)

更具体一点看 CA 的层级体系，一般是采用根 CA、业务 CA 和用户 CA 三层树结构，所有的下层 CA 会继承上层 CA 的信任体系。根 CA 用来签发业务 CA，业务 CA 用来签发具体的用户 CA（身份认证 CA、交易签名、安全通讯 CA 等）

#### 通道

上文提到`Fabric`用 Channel 通道机制来保障交易的安全和隐私性，本质上每一个通道就是一个独立的账本，也是一个独立的区块链，有着不同的世界状态，网络中的一个节点可以同时加入多个通道。这种机制可以很好地划分不同的业务场景，也不用担心交易信息泄漏问题。

#### 链码

`Fabric`也有类似以太坊的智能合约，称为 Chaincode 链码，智能合约使外部的应用程序可以和`Fabric`网络中的账本进行交互。不同于`Ethereum`，`Fabric`使用 Docker 而不是特定的虚拟机来存放链码，提供了一个安全、轻便的语言执行环境。

链码主要分成系统链码和用户链码两种，系统链码嵌入在系统内，提供对系统进行配置、管理的支持；而用户链码则是运行在单独的 Docker 容器中，提供对上层应用的支持，用户通过链码相关的 API 编写用户链码，即可对账本中状态进行更新操作。

链码经过安装和实例化操作后即可被调用，在安装的时候需要指定具体安装到哪个 Peer 节点（有的节点可以没有链码），实例化时还需要指定通道及背书策略。

链码之间也可以相互调用，从而创建更灵活的应用逻辑。

#### 共识机制

`Fabric`中广义的共识机制包括背书、排序和验证三个环节，狭义的共识是指排序，

`Fabric`区块链网络中，不同参与者之间交易必须按照发生的顺序写到分布式账本中，依赖共识机制，主要有三种：
- SOLO（只限于开发）
- Kafka（一种消息平台）
- Raft（相比 Kafka 更中心化）

#### 网络协议

那`Fabric`网络中各个节点的状态分发又是怎么进行的呢？

外界的客户端是通过`gRPC`来对`Fabric`网络中的各个节点进行远程调用，而`P2P`网络中各个节点之间的同步是通过`Gossip`协议来进行的。

`Gossip`协议主要是用于网络中多个节点之间的数据交换，比较容易实现且容错率很高，原理就是数据发送一方从网络中随机选取若干个节点发送过去，等几个节点接收到这些数据后再随机发送给除了发送方外的若干节点，不断重复，最终所有节点达成一致（复杂度为 LogN）。

#### 分布式账本

最终所有的交易都会记录到分布式账本中，这也是区块链诸多特性的核心。`Fabric`中交易可以存储相关业务信息，区块是一组排列后的交易集合，将区块通过密码算法链接起来就是区块链。分布式账本主要记录世界状态（最新的分布式账本状态，一般使用`CouchDB`以方便查询）和事务日志（世界状态的更新历史，记录区块链结构，使用`LevelDB`），对账本的每个操作都会记录在日志中，不可篡改。

#### 应用编程接口

对于基于`Fabric`的应用，则主要提供了 SDK 开发工具包和 CLI 命令行两种方式进行交互。

### Fabric 区块链核心角色

首先要提的是`Fabric`网络中的角色都是逻辑角色，比如 Peer 节点 A 可能既是排序节点，也可能在某些业务中是背书节点，而一个角色也不仅仅由单一节点担任。

接下来介绍一下各个角色的作用和职能。

Clients 客户端主要给交易签名，提交交易 Proposal 给背书节点，接收已经背书后的交易广播给排序节点；背书节点则是本地模拟执行交易 Proposal 验证交易（策略由 Chaincode 制定），签名并返回已背书交易；排序节点则将交易打包为 block 然后广播至各个节点，不参与交易的执行和验证，多个排序节点可以组成 OSN；所有的节点都维护区块链账本。

### 优势总结

`Fabric`通过将企业应用的各个复杂环节分配到各个逻辑角色节点（背书、排序等），不需要所有节点都承担如排序这样资源消耗较大的操作，消除了网络瓶颈；分配了角色后某些交易只在特定的节点部署和执行，且可以并发执行，大大提升效率和安全性，也隐藏了一些商业逻辑；因此，可以根据不同的业务需要来形成多种灵活的分配方案，极大增强了系统的拓展性。

将共识机制、权限管理、加密机制、账本等模块都设置为可插拔，且不同的链码可以设置不同的背书策略，信任机制更加灵活，这样可以根据业务需要设置自己的高效系统。

成员身份管理的`Fabric CA`作为单独的项目，能够提供更多功能，也能够与很多第三方 CA 直接进行接入和交互，功能更强大，适合企业复杂的场景。

多通道的特性是不同通道之间的数据彼此隔离，提高了安全性和隐私保护。

链码支持如`Java`、`Go`、`Node`等不同的编程语言，更加灵活，也支持更多第三方拓展应用，降低了业务迁移和维护成本。

### Fabric 应用开发及交互

![hyperledger_fabric_application_interact](https://cdn.jsdelivr.net/gh/pseudoyu/image-hosting@master/images/hyperledger_fabric_application_interact.png)

上图就是作为一个区块链开发者在应用`Fabric`区块链中的开发和交互流程。

开发者主要负责开发应用和智能合约（链码），应用通过 SDK 与智能合约进行交互，而智能合约的逻辑可以对账本进行`get`、`put`、`delete`等操作。

### Fabric 工作流程

![hyperledger_fabric_transaction_flow](https://cdn.jsdelivr.net/gh/pseudoyu/image-hosting@master/images/hyperledger_fabric_transaction_flow.png)

接下来通过一个完整的交易流来梳理一下`Fabric`网络的工作原理

0. 在所有操作之前，需要向 CA 获取合法身份并且指定通道
1. 首先，Client 提交交易 Proposal（含自己的签名）至背书节点
2. 背书节点接收到交易 Proposal 后用本地状态模拟执行，对交易进行背书、签名并返回（其中包含 Read-Write Set、签名等）
3. Client 收集到足够的背书后（策略由 Chaincode 制定，如图中示例为得到 2 个背书）提交已背书交易至排序节点（OSN）
4. 排序节点将交易打包成 blocks，排序（不执行或验证交易正确性）并广播至所有节点
5. 所有节点对新 blocks 进行验证并提交至账本

![hyperledger_fabric_processes](https://cdn.jsdelivr.net/gh/pseudoyu/image-hosting@master/images/hyperledger_fabric_processes.png)

接下来对每个环节进行一些详细的拆解

#### 执行/背书环节

Client 提交交易 proposal 后，背书节点会首先核对 Client 的签名，用本地状态模拟执行，对交易进行签名和 Read-Write Set 回 Clients，R-W Sets 主要包含`key`, `version`, `value`三个属性，Read-Set 包含交易执行中读取的所有变量和其`version`，对账本进行 write 操作的话`version`会产生变化，Write-Set 包含所有被编辑的变量及其新值。

背书节点在执行交易时值根据本地区块链的状态检查链码是否正确，执行并返回。

Fabric 支持多种背书策略，Client 在提交至排序节点前会验证是否满足背书要求，值得注意的是如果只做了查询账本操作，Client 不会提交至 OSN。

上文所提到的交易 proposal 主要包括链码、链码的输入值、Client 的签名，而背书节点返回至 Client 的信息则包括返回值、模拟执行结果的 R-W Set 以及背书节点的签名，组合起来则是已背书节点。

背书是相关组织对交易的认可，即相关节点对交易进行签名。对于一个链码交易来说，背书策略是在链码实例化的时候指定的，一笔有效交易必须是背书策略相关组织签名才能生效，本质上`Fabric`区块链中的交易验证是基于对背书节点的信任，这也是称`Fabric`并不是严格意义上的去中心化的原因之一。

以下是一个简单的链码执行示例

```go
func (t *SimpleChaincode) InitLedger(ctx contractapi.TransactionContextInterface) error {
    var product = Product { Name: "Test Product", Description: "Just a test product to make sure chaincode is running", CreatedBy: "admin", ProductId: "1" }

    productAsBytes, err := json.Marshal(product)

    err = ctx.GetStub().PutState("1", productAsBytes)

    if err != nil {
        return err
    }
}
```

在这个简单示例中，链码的主要操作就是更新了`key-value`值，经过了这个操作后，`version`会变化。

执行后返回的 R-W Set 为

```go
key: 1
value: Product { Name: "Test Product", Description: "Just a test product to make sure chaincode is running", CreatedBy: "admin", ProductId: "1" } 的Json形式
```

#### 排序环节

Client 提交已背书交易至排序节点（排序节点可通过一些共识策略组成 OSN），排序节点接收到交易后，会打包成 blocks 并按照配置中的规则进行排序，在此过程中，只执行排序操作，而不进行任何执行或验证，排序完成后发送至所有节点。

排序服务用来对全网交易达成一致，只负责对交易顺序达成一致，避免了整个网络瓶颈，更容易横向拓展以提升网络效率，目前支持`Kafka`和`Raft`两种，`Fabric`区块链网络的统一/完整性依赖于排序节点的一致性。

Raft 共识机制属于非拜占庭共识机制，使用了领导者和跟随者（Leader 和 Follower）模型，当一个 Leader 被选出，日志信息会从 Leader 向 Follower 单向复制，更容易管理，在设计上允许所有节点都可以称为 Orderer 节点，相比 Kafka 更中心化，其实也允许采用 PBFT 共识机制，但是性能往往很差。

#### 验证环节

当节点接收到由排序节点发送来的区块时，会对区块中的所有交易进行验证并标记是否可信，主要验证两个方面：1.是否满足背书策略。2.交易结构的合法性，是否有状态冲突，如 Read-Set 中的`version`是否一致等。

## 总结

以上就是对`Hyperledger Fabric`架构的梳理了，虽然取舍了部分去中心化的理念，但是作为一个面向企业应用的开源联盟链，它鼓励了更多企业参与到分布式账本技术的建设和应用中来，现在国内也有很多联盟链的自研平台，如蚂蚁链、趣链等，相信未来会有更多企业参与到这个开放的生态体系！

## 参考资料

> 1. [FITE3011 Distributed Ledger and Blockchain](https://www.cs.hku.hk/index.php/programmes/course-offered?infile=2019/fite3011.html), *Allen Au，HKU*
> 2. [企业级区块链实战教程](https://github.com/yingpingzhang/enterprise_blockchain_tutorial)，*张应平*