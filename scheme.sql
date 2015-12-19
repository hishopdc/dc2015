CREATE TABLE [Products]
(
  [ProductId] [int] NOT NULL,
  [ProductName] [nvarchar] (200) NOT NULL,
  [SaleCounts] [int] NOT NULL,
  [Stock] [int] NOT NULL
  CONSTRAINT [PK_Products] PRIMARY KEY NONCLUSTERED 
  (
    [ProductId] ASC
  )WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
)

GO
CREATE TABLE [Promotions]
(
  [PromotionId] [int] NOT NULL,
  [ProductId] [int] NOT NULL,
  [StartTime] [datetime] NOT NULL,
  [EndTime] [datetime] NOT NULL,
  [Quantity] [int] NOT NULL,
  [Price] [money] NOT NULL
  CONSTRAINT [PK_Promotions] PRIMARY KEY NONCLUSTERED 
  (
    [ProductId] ASC
  )WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
)

GO

CREATE TABLE [Users] (
  [UserId] [int] NOT NULL,   
  [UserName][nvarchar] (50) NOT NULL,
  [RealName][nvarchar] (50) NULL,
  [CellPhone][nvarchar] (50) NULL,
  [Address][nvarchar] (50) NULL,
  [OrderNumber] [int] NOT NULL,
  [OrderAmount] [money] NOT NULL
  CONSTRAINT PK_Users PRIMARY KEY NONCLUSTERED  
  ([UserId] ASC)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
)

CREATE TABLE [Orders]
(
  --订单基本信息
  [OrderId] [nvarchar] (50) NOT NULL,
  [UserId] [int] NOT NULL,
  [PromotionId] [int] NOT NULL,
  [ProductId] [int] NOT NULL,
  [OrderTime] [datetime] NOT NULL,
  [PayTime] [datetime] NULL,
  [CloseTime] [datetime] NULL
  CONSTRAINT [PK_Orders] PRIMARY KEY NONCLUSTERED
  (
    [OrderId] ASC
  )WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
)
