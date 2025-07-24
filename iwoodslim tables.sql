drop database if exists iwoodslim;
create database iwoodslim;
use iwoodslim;

-- Customer info

create table customers (
	customer_id int primary key auto_increment,
    first_name 	varchar(255) not null,
    last_name 	varchar(255) not null,
    address 	varchar(255),
    city		varchar(255),
    state		varchar(2),
    zip			varchar(10),
    phone		varchar(20) not null,
    email 		varchar(255)
);

create table customer_visits (
	customer_visits_id		int primary key auto_increment,
    customer_id				int not null,
    visit_type				enum('Order', 'Repair', 'Install', 'New Customer') not null,
    visit_date				datetime not null default current_timestamp,
    CONSTRAINT customer_visits_fk_customers FOREIGN KEY (customer_id) REFERENCES customers (customer_id)
);

create table items (
  item_id 		int primary key auto_increment,
  item_name		varchar(255) not null,
  item_color  varchar(255) not null,
  item_model  varchar(255) not null,
  description 	varchar(255) not null,
  cost        decimal(10,2) not null,
  markup_rate	decimal(10,2) not null,
  price			decimal(10,2) generated always as (cost * (1 + markup_rate / 100)) stored,
  quantity		int not null,
  sell_item    boolean not null,
  repair_item  boolean not null,
  install_item boolean not null
);

create table item_price_log (
	item_price_log_id		int primary key auto_increment,
    item_id					int not null,
    cost					decimal(10,2),
    markup_rate				decimal(10,2),
    price					decimal(10,2),
    start_date				date not null,
    end_date				date,
    is_active				boolean,
    CONSTRAINT item_price_log_fk_items FOREIGN KEY (item_id) REFERENCES items(item_id)
);

create table installs (
	install_id		int primary key auto_increment,
    customer_id		int not null,
    description 	text,
    estimate		decimal(10,2) not null,
    install_date	date,
    notes			text,
    CONSTRAINT installs_fk_customers FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);



create table repairs (
	repair_id 			int primary key auto_increment,
    customer_id 		int not null,
    items_brought		text not null,
    problem				varchar(255) not null,
    solution 			varchar(255),
    estimate			decimal(10,2) not null,
    status				enum("Not Started", "In Progress", "Completed", "Unsuccessful"),
    notes				text,
    drop_off_date		datetime not null,
    pickup_date			datetime,
    CONSTRAINT repairs_fk_customers FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

create table orders (
	order_id 		int primary key auto_increment,
    customer_id		int not null,
    order_date		date not null,
	CONSTRAINT orders_fk_customers FOREIGN KEY (customer_id) REFERENCES customers (customer_id)
);

create table install_items (
  install_item_id   		int primary key auto_increment,
  install_id        		int not null,
  item_id           		int not null,
  install_item_quantity   	int not null,
  total_price				decimal(10,2),
  CONSTRAINT install_items_fk_installs FOREIGN KEY (install_id) REFERENCES installs (install_id),
  CONSTRAINT install_items_fk_items FOREIGN KEY (item_id) REFERENCES items (item_id)
);

create table repair_items (
	repair_item_id 				int primary key auto_increment,
    repair_id 					int not null,
    item_id 					int not null,
    repair_item_quantity		int not null,
    total_price					decimal(10,2) not null,
    CONSTRAINT repair_items_fk_repairs FOREIGN KEY (repair_id) REFERENCES repairs (repair_id),
    CONSTRAINT repair_items_fk_items FOREIGN KEY (item_id)	REFERENCES items (item_id)
);

create table order_items (
	order_item_id				int primary key auto_increment,
    order_id					int not null,
    item_id						int not null,
    order_item_quantity			int not null,
    total_price				decimal(10,2),
    CONSTRAINT order_items_fk_orders FOREIGN KEY (order_id) REFERENCES orders(order_id),
    CONSTRAINT order_items_fk_items FOREIGN KEY (item_id) REFERENCES items(item_id)
);

create table tax_rate (
	tax_rate_id		int primary key auto_increment,
    tax_rate		decimal(10,2)
);

create table tax_log (
	tax_log_id		int primary key auto_increment,
    tax_rate_id		int not null,
    rate			decimal(10,2) not null,
    start_date		datetime not null,
    end_date		datetime,
    is_active		boolean,
    CONSTRAINT tax_log_fk_tax_rate FOREIGN KEY (tax_rate_id) REFERENCES tax_rate (tax_rate_id)
);





-- invoice info
-- create table invoices (
-- 	invoice_id			int primary key auto_increment,
--     customer_id			int not null,
--     install_id    		int,
--     repair_id     		int,
--     order_id      		int,
--     invoice_date		date not null,
--     status				enum('Unpaid', 'Paid', 'Partially Paid', 'Overdue') default 'Unpaid',
--     subtotal			decimal(10,2) not null,
--     discount_percent	decimal(10,2) not null,
--     tax_rate_id			int not null,
--     tax_amount			decimal(10,2) not null,
--     total				decimal(10,2) not null,
--     CONSTRAINT invoices_fk_customers FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
--     CONSTRAINT invoices_fk_installs FOREIGN KEY (install_id) REFERENCES installs (install_id),
--     CONSTRAINT invoices_fk_repairs FOREIGN KEY (repair_id) REFERENCES repairs (repair_id),
--     CONSTRAINT invoices_fk_orders FOREIGN KEY (order_id) REFERENCES orders (order_id),
--     CONSTRAINT invoices_fk_tax_rate	 FOREIGN KEY (tax_rate_id) REFERENCES tax_rate(tax_rate_id)
-- );

-- create table payments (
-- 	payment_id			int primary key auto_increment,
--     invoice_id			int not null,
--     payment_amount		decimal(10,2) not null default 0,
--     payment_method		varchar(255) not null,
-- 	payment_date		datetime not null,
--     CONSTRAINT payments_fk_invoices FOREIGN KEY (invoice_id) REFERENCES invoices (invoice_id)    
-- );

-- Employee info

-- create table employees (
-- 	employee_id	 int primary key auto_increment,
--     first_name   varchar(255) not null,
--     last_name    varchar(255) not null,
--     phone        varchar(20) not null,
--     email        varchar(255) not null,
-- 	address      varchar(255) not null,
--     city         varchar(255) not null,
--     state        varchar(255) not null,
--     zip          varchar(10) not null
-- );


-- create table titles (
--   title_id    int primary key auto_increment,
--     title_name    varchar(255) not null,
--     description   text not null
-- );

-- create table title_log (
--   title_log_id    int primary key auto_increment,
--     title_id      int not null,
--     employee_id   int not null,
--     start_date    datetime not null,
--     end_date      datetime,
--     is_active	  boolean,
--     CONSTRAINT title_log_fk_titles FOREIGN KEY (title_id) REFERENCES titles (title_id),
--     CONSTRAINT tile_log_fk_employees FOREIGN KEY (employee_id) REFERENCES employees (employee_id)
-- );

-- create table tenure (
--   tenure_id   int primary key auto_increment,
--     employee_id   int not null,
--     start_date    datetime not null,
--     end_date      datetime,
--     end_reason    text,
--     CONSTRAINT tenure_fk_employees FOREIGN KEY (employee_id) REFERENCES employees (employee_id)
-- );

-- create table time_sheets (
--   time_sheet_id   int primary key auto_increment,
--   employee_id     int not null,
--   start_date      date not null,
--   end_date        date not null,
--   hours_worked    decimal (10,2) not null default 0,
--   CONSTRAINT time_sheets_fk_employees FOREIGN KEY (employee_id) REFERENCES employees (employee_id)
-- );

-- create table pay_rates (
--   pay_rate_id     int primary key auto_increment,
--     employee_id     int not null,
--     hourly_rate     decimal(10,2) not null,
--     start_date      datetime not null,
--     end_date        datetime,
--     is_active       boolean not null,
--     CONSTRAINT pay_rates_fk_employees FOREIGN KEY (employee_id) REFERENCES employees (employee_id)
-- );

-- create table pay_log (
--   pay_log_id          int primary key auto_increment,
--   employee_id         int not null,
--   payment_date        datetime not null,
--   gross_amount        decimal(10,2),
--   net_amount          decimal(10,2),
--   CONSTRAINT pay_log_fk_employees FOREIGN KEY (employee_id) REFERENCES employees (employee_id)
-- );

-- create table employee_installs (
-- 	employee_install_id		int primary key auto_increment,
-- 	install_id				int not null,
--     employee_id				int not null,
--     install_status			enum("Not Started", "In Progress", "Completed", "Unsuccessful"),
--     CONSTRAINT employee_installs_fk_employees FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
--     CONSTRAINT employee_installs_fk_installs FOREIGN KEY (install_id) REFERENCES installs(install_id)
-- );