CREATE DATABASE Manufacturer;

Use Manufacturer;

CREATE TABLE [Product]
(
	[Product_ID] [int] PRIMARY KEY IDENTITY(1,1),
	[Product_Name] [nvarchar](50) Not NULL,
	[Quantity] [nvarchar](50) Not NULL
	);

CREATE TABLE [Component]
(
	[Component_ID] [int] PRIMARY KEY IDENTITY(1,1),
	[Component_Name] [nvarchar](50) Not NULL,
	[Description_] [nvarchar](50) Not NULL,
	[Quantity] [nvarchar](50) Not NULL,
	[Product_ID] [int] Not NULL,
	);

CREATE TABLE [Supply_Order]
(
	[Order_ID] [int] PRIMARY KEY IDENTITY(1,1),
	[Component_ID] [int] Not NULL,
	[Supplier_ID] [int] Not NULL,
	[Supply_Time] [nvarchar](50) Not NULL,
	[Supply_Quantity] [nvarchar](50) Not NULL,
	);

CREATE TABLE [Supplier]
(
	[Supplier_ID] [int] PRIMARY KEY IDENTITY(1,1),
	[Supplier_Name] [nvarchar](50) Not NULL,
	[Activation_Status] [nvarchar](50) Not NULL,
	);

CREATE TABLE [Recipe]
(
	[Product_ID] INT NOT NULL,
	[Component_ID] INT NOT NULL,
	PRIMARY KEY ([Product_ID], [Component_ID])
	);

ALTER TABLE Component 
ADD CONSTRAINT FK_product FOREIGN KEY (Product_ID) REFERENCES Product (Product_ID)

ALTER TABLE Supply_Order 
ADD CONSTRAINT FK_supply1 FOREIGN KEY (Component_ID) REFERENCES Component (Component_ID)

ALTER TABLE Supply_Order 
ADD CONSTRAINT FK_supply2 FOREIGN KEY (Supplier_ID) REFERENCES Supplier (Supplier_ID)

ALTER TABLE Recipe
ADD CONSTRAINT FK_product1 FOREIGN KEY (Product_ID) REFERENCES Product(Product_ID)

ALTER TABLE Recipe
ADD CONSTRAINT FK_component1 FOREIGN KEY (Component_ID) REFERENCES Component(Component_ID)

INSERT Product
VALUES ('Nut Chocolate',10),
       ('Almond Chocolate',15),
       ('Walnut Chocolate',20),
	   ('Milk Chocolate',25),
	   ('Bitter Chocolate',30)

INSERT Component
VALUES ('Cacao','Kakao','10 kg','2'),
       ('Sugar','Seker','12 kg','3'),
       ('Milk','Süt','14 kg','4'),
       ('Nut','Kakao','16 kg','5'),
       ('Almond','Kakao','18 kg','1'),
       ('Walnut','Kakao','20 kg','2'),
       ('Emulgator','Duzenleyici','22 kg','3'),
       ('Butter','Tereyag','24 kg','4'),
       ('Honey','Bal','26 kg','5'),
       ('Egg','Yumurta','28 kg','1'),
       ('Milk Fat','Sut yagi','30 kg','2')

INSERT Supplier
VALUES ('Company_A','active'),
       ('Company_B','active'),
       ('Company_C','active'),
	   ('Company_D','inactive'),
	   ('Company_E','active')

INSERT Supply_Order
VALUES ('1','1','2022-08-01','20 kg'),
       ('2','2','2022-08-02','30 kg'),
       ('3','3','2022-08-03','40 kg'),
       ('4','4','2022-08-04','50 kg'),
       ('5','5','2022-08-05','60 kg'),
       ('6','1','2022-08-01','20 kg'),
       ('7','2','2022-08-02','30 kg'),
       ('8','3','2022-08-03','40 kg'),
       ('9','4','2022-08-04','50 kg'),
       ('10','5','2022-08-05','60 kg')
