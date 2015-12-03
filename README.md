# HiShop DC 2015
HiShop疯狂的程序员 - 2015 竞技大赛

本次大赛为HiShop组织的第一次开发者竞技形大赛，旨在提升开发者面对极端应用问题的快速分析和解决能力，以及团队的协作能力及技巧。

<a name="赛题" />
## 赛题
当下电商领域一个十分热门的场景，即商品秒杀抢购活动，实现一个最小的可用系统，模拟处理高并发情况的秒杀抢购业务。

## 要求
用自己和所在团队最为擅长的程序设计语言和基础框架搭建一个最小可用的HTTP服务，完整实现抢购业务中的基本流程环节（具体参见以下的[`HTTP服务接口规范`](#HTTP服务接口规范)章节），仅限大赛组织方提供的数据库系统及数据结构，可自选额外的具体性能优化方案。

推荐方案：
> * 系统平台：Windows Server / IIS（ASP.NET）
* 基础框架：.NET Framework 4.5
* 编程语言：C#

> 亦可选择其他的开源平台方案，如 Linux/BSD + PHP / JSP / Node.js / Python 等，需检查阿里云ECS服务中是否提供相应的系统镜像，并自行配置相应的环境，且只能连接组织方规定的数据系统。

## 抢购业务描述
![业务流程](http://him.hishop.com.cn/hishopdc2015/cg.png)

## 数据库及数据结构
![数据库关系](http://him.hishop.com.cn/hishopdc2015/ds.png)

商品表（Products）：
> 此表数据由组织方初始化

| 列名              | 类型      | 长度  | 可空  | 说明                |
| :---------------- | :-------- | :---- | :---- | :------------------ |
| ProductId [PK]    | int       | 4     | N     | 商品编号            |
| ProductName       | nvarchar  | 200   | N     | 商品名称            |
| SaleCounts        | int       | 4     | N     | 销量                |
| Stock             | int       | 4     | N     | 库存                |

抢购活动表（Promotions）：
> 此表数据由组织方初始化，不可修改

| 列名              | 类型      | 长度  | 可空  | 说明                |
| :---------------- | :-------- | :---- | :---- | :------------------ |
| PromotionId [PK]  | int       | 4     | N     | 活动编号            |
| ProductId         | int       | 4     | N     | 商品编号            |
| StartTime         | DateTime  |       | N     | 开始时间            |
| EndTime           | DateTime  |       | N     | 结束时间            |
| Quantity          | int       | 4     | N     | 数量                |
| Price             | Money     |       | N     | 价格                |

会员用户表（Users）：
> 此表数据由组织方初始化

| 列名              | 类型      | 长度  | 可空  | 说明                |
| :---------------- | :-------- | :---- | :---- | :------------------ |
| UserId [PK]       | int       | 4     | N     | 用户编号            |
| UserName          | nvarchar  | 50    | N     | 用户名              |
| RealName          | nvarchar  | 50    | Y     | 真实姓名            |
| CellPhone         | nvarchar  | 50    | Y     | 手机号码            |
| Address           | nvarchar  | 50    | Y     | 收货地址            |
| OrderNumber       | int       | 4     | N     | 下单总数            |
| OrderAmount       | Money     |       | N     | 下单总金额          |

订单表（Orders）：

| 列名              | 类型      | 长度  | 可空  | 说明                |
| :---------------- | :-------- | :---- | :---- | :------------------ |
| OrderId [PK]      | nvarchar  | 50    | N     | 订单编号            |
| UserId            | int       | 4     | N     | 用户编号            |
| PromotionId       | int       | 4     | N     | 活动编号            |
| ProductId         | int       | 4     | N     | 商品编号            |
| OrderTime         | DateTime  |       | N     | 订单提交时间        |
| PayTime           | DateTime  |       | Y     | 订单支付时间        |
| CloseTime         | DateTime  |       | Y     | 订单关闭时间        |

<a name="HTTP服务接口规范" />
## HTTP服务接口规范
由于主要考验参赛者对核心业务的理解和处理能力，于是只要求参赛作品向评分系统输出正确的业务数据（JSON格式）即可，不用返回用于可视化的HTML内容。

所有的未指明错误（如参数无效）均返回：
```
{
  error: 'invalid parameters'
}
```

### 1. 抢购活动实时详情接口（GET方式）
模拟抢购场景中用户不停刷新活动商品详情页面时，对应用服务器及数据库系统的查询负载。

> /promotion/index.ashx

调用参数：

| 名称        | 类型        | 说明          | 示例                    |
| :---------- | :---------- | :------------ | :---------------------- |
| uid         | int         | 用户唯一标识  | 12345                   |
| prom_id     | int         | 抢购活动编号  | 201501                  |
| rnd         | string      | 随机数        | 1448901407550           |

输出示例：
```
{
  username: 'hike001',
  realname: '剁手未遂',
  purchased: 'true',
  product_name: 'HiShop 产品大全',
  start_time: '2015-11-30 08:30:00',
  end_time: '2015-11-30 09:30:00',
  price: '8888.88',
  avl_qty: '15' // 剩余可抢购数量
}
```

### 2. 提交抢购申请（POST方式）
模拟抢购场景中用户向系统确定抢购一件商品。

> /promotion/buy.ashx

调用参数：

| 名称        | 类型        | 说明          | 示例                    |
| :---------- | :---------- | :------------ | :---------------------- |
| uid         | int         | 用户唯一标识  | 12345                   |
| prom_id     | int         | 抢购活动编号  | 201501                  |

输出示例：
```
// 提交成功
{
  order_id: '201511300001',
  username: 'hike001',
  realname: '剁手未遂',
  product_name: 'HiShop 产品大全',
  order_time: '2015-11-30 08:30:00',
}

// 已经抢光
{
  error: 'sold out'
}

// 已经抢过
{
  error: 'already purchased'
}
```

### 3. 支付抢购订单（POST方式）
模拟抢购场景中用户支付已经成功提交的订单。

> /promotion/pay.ashx

调用参数：

| 名称        | 类型        | 说明          | 示例                    |
| :---------- | :---------- | :------------ | :---------------------- |
| uid         | int         | 用户唯一标识  | 12345                   |
| order_id    | string      | 订单号        | 201511300001            |

输出示例：
```
// 提交成功
{
  order_id: '201511300001',
  username: 'hike001',
  realname: '剁手未遂',
  product_name: 'HiShop 产品大全',
  order_time: '2015-11-30 08:30:00',
  pay_time: '2015-11-30 08:30:45'
}

// 支付超时
{
  error: 'timeout',
  close_time: '2015-11-30 08:31:00'
}
```

