create database ql;
use ql;

#vật tư
create table supplies
(
    supplies_id int primary key auto_increment,
    name        varchar(30),
    unit        varchar(30),
    price       int
);

#tồn kho
create table inventory
(
    inventory_id          int primary key auto_increment,
    supplies_id           int,
    number_of_head        int,
    total_amount_entered  int,
    total_export_quantity int,
    foreign key (supplies_id) references supplies (supplies_id)
);

#nhà cung cấp
create table supplier
(
    supplier_id      int primary key auto_increment,
    supplier_code    varchar(10)        not null,
    supplier_name    varchar(30) unique not null,
    supplier_address varchar(70),
    supplier_number  varchar(10) unique not null
);

#đơn hàng
create table orders
(
    orders_id   int primary key auto_increment,
    orders_code varchar(10) unique not null,
    orders_day  date,
    supplier_id int,
    foreign key (supplier_id) references supplier (supplier_id)
);

#phiếu nhập
create table entercoupon
(
    coupon_id   int primary key auto_increment,
    coupon_code varchar(10) unique not null,
    enter_day   date,
    orders_id   int,
    foreign key (orders_id) references orders (orders_id)
);

#phiếu xuất
create table bill
(
    bill_id       int primary key auto_increment,
    bill_code     varchar(10) unique not null,
    enter_day     date,
    customer_name varchar(10)        not null
);

# chi tiết đơn hàng
create table orderdetails
(
    orderdetails_id  int primary key auto_increment,
    orders_id        int,
    supplies_id      int,
    number_of_orders int not null,
    foreign key (orders_id) references orders (orders_id),
    foreign key (supplies_id) references supplies (supplies_id)
);

#chi tiết phiếu nhập
create table entry_ticket_details
(
    id                int primary key auto_increment,
    entercoupon_id    int,
    supplies_id       int,
    number_of_import  int,
    import_unit_price int,
    note              varchar(100),
    foreign key (entercoupon_id) references entercoupon (coupon_id),
    foreign key (supplies_id) references supplies (supplies_id)
);

#chi tiết phiếu xuất
create table exportdetails
(
    exportdetails_id  int primary key auto_increment,
    bill_id           int,
    supplies_id       int,
    number_of_output  int,
    export_unit_price int,
    note              varchar(100),
    foreign key (bill_id) references bill (bill_id),
    foreign key (supplies_id) references supplies (supplies_id)
);

#thêm vật tư
insert into supplies value (null, 'đá', 'mét khối', 30000),
    (null, 'sắt', 'theo cây sắt or cuộn', 96000),
    (null, 'dây điện', 'theo mét', 15000),
    (null, 'ống gen', 'theo bó', 250000),
    (null, 'bóng điện', 'bóng', 30000);

#thêm bản ghi tồn kho
insert into inventory value (null, 1, 1000, 1500, 500),
    (null, 2, 1200, 1350, 590),
    (null, 3, 900, 1800, 300),
    (null, 4, 850, 1500, 500),
    (null, 5, 1100, 1550, 450);

#nhà cung cấp
insert into supplier value (null, '12A3B4', 'Vật Tư Việt Nam', 'lô 12A KDT TTD', '0987456123'),
    (null, '14B52A', 'Tổng Công Ty Liêm Thúy', 'Phú xuyên - hà nội', '0342561573'),
    (null, '6E2A21V', 'Vật Tư Karthus', 'Khu đô thị địa ngục', '0000000000');

#đơn hàng
insert into orders value (null, 'A304', '2021-5-19', 3),
    (null, 'A504', '2021-5-18', 2),
    (null, 'B506', '2021-5-17', 1);

#phiếu nhập
insert into entercoupon value (null, 'G403', '2021-3-2', 1),
    (null, 'E502', '2021-4-15', 2),
    (null, 'P555', '2021-5-1', 3);

#phiếu xuất
insert into bill value (null, 'X101', '2021-3-2', 'Bùi xuân A'),
    (null, 'X102', '2021-5-19', 'Trần Văn B'),
    (null, 'X103', '2021-5-18', 'Nguyễn G');

#chi tiết đơn hàng
insert into orderdetails value (null, 1, 1, 1000),
    (null, 2, 2, 50),
    (null, 3, 3, 100),
    (null, 3, 3, 95),
    (null, 2, 2, 56),
    (null, 1, 1, 42);

#chi tiết phiếu nhập
insert into entry_ticket_details value (null, 1, 1, 500, 1000, 'sau giám giá'),
    (null, 2, 2, 1500, 1500, 'đã xuống hàng'),
    (null, 3, 3, 570, 1900, 'giá sau tăng 10%');

#1
select entercoupon_id    số_phiếu,
       s.supplies_id     mã_đơn,
       number_of_import  số_lượng,
       import_unit_price giá_nhập,
       number_of_import * import_unit_price
from entry_ticket_details e
         join supplies s on e.supplies_id = s.supplies_id;

#2
select entercoupon_id    số_phiếu,
       s.supplies_id     mã_đơn,
       s.name            Tên_vật_tư,
       number_of_import  số_lượng,
       import_unit_price giá_nhập,
       number_of_import * import_unit_price
from entry_ticket_details e
         join supplies s on e.supplies_id = s.supplies_id;

#3
select entercoupon_id    số_phiếu,
       enter_day         ngày_nhập,
       supplier_id       số_đơn_đặt,
       s.supplies_id     mã_đơn,
       number_of_import  số_lượng,
       import_unit_price giá_nhập,
       number_of_import * import_unit_price Tổng_tiền
from entry_ticket_details e
         join supplies s on e.supplies_id = s.supplies_id
         join entercoupon e2 on e.entercoupon_id = e2.coupon_id
         join orders group by coupon_id;

#4
select entercoupon_id    số_phiếu,
       enter_day         ngày_nhập,
       supplier_id       số_đơn_đặt,
       supplier_code     mã_nhà_cc,
       number_of_import  số_lượng,
       import_unit_price giá_nhập,
       number_of_import * import_unit_price Tổng_tiền
from entry_ticket_details e
         join supplies s on e.supplies_id = s.supplies_id
         join entercoupon e2 on e.entercoupon_id = e2.coupon_id
         join supplier;

#5
select entercoupon_id    số_phiếu,
       s.supplies_id     mã_vật_tư,
       number_of_import  số_lượng,
       import_unit_price giá_nhập,

       number_of_import * import_unit_price tongtien
from entry_ticket_details e
         join supplies s on e.supplies_id = s.supplies_id where e.number_of_import > 500;

#6số phiếu nhập hàng, mã vật tư, tên vật tư, số lượng nhập, đơn giá nhập, thành tiền nhập. Và chỉ liệt kê các chi tiết nhập vật tư có đơn vị tính là Bộ.

select coupon_code số_phiếu,
       s.supplies_id     mã_vật_tư,
       s.name            Tên_vật_tư,
       number_of_import  số_lượng,
       import_unit_price giá_nhập,
       number_of_import * import_unit_price
from entry_ticket_details e
         join supplies s on e.supplies_id = s.supplies_id join entercoupon e2 on e.entercoupon_id = e2.coupon_id where s.unit = 'mét khối';
