USE iwoodslim;

DELIMITER //

-- Add Customer + Order
CREATE PROCEDURE AddCustomerAndOrder (
  IN first_name VARCHAR(50),
  IN last_name VARCHAR(50),
  IN address VARCHAR(255),
  IN city VARCHAR(100),
  IN state VARCHAR(50),
  IN zip VARCHAR(20),
  IN phone VARCHAR(20),
  IN email VARCHAR(100),
  IN order_date DATE
)
BEGIN
  INSERT INTO customers (first_name, last_name, address, city, state, zip, phone, email)
  VALUES (first_name, last_name, address, city, state, zip, phone, email);

  SET @cust_id = LAST_INSERT_ID();

  INSERT INTO orders (customer_id, order_date)
  VALUES (@cust_id, order_date);
END;
//

-- Add Customer + Install
CREATE PROCEDURE AddCustomerAndInstall (
  IN first_name VARCHAR(50),
  IN last_name VARCHAR(50),
  IN address VARCHAR(255),
  IN city VARCHAR(100),
  IN state VARCHAR(50),
  IN zip VARCHAR(20),
  IN phone VARCHAR(20),
  IN email VARCHAR(100),
  IN description TEXT,
  IN estimate DECIMAL(10,2),
  IN install_date DATE,
  IN notes TEXT
)
BEGIN
  INSERT INTO customers (first_name, last_name, address, city, state, zip, phone, email)
  VALUES (first_name, last_name, address, city, state, zip, phone, email);

  SET @cust_id = LAST_INSERT_ID();

  INSERT INTO installs (customer_id, description, estimate, install_date, notes)
  VALUES (@cust_id, description, estimate, install_date, notes);
END;
//

-- Add Customer + Repair
CREATE PROCEDURE AddCustomerAndRepair (
  IN first_name VARCHAR(50),
  IN last_name VARCHAR(50),
  IN address VARCHAR(255),
  IN city VARCHAR(100),
  IN state VARCHAR(50),
  IN zip VARCHAR(20),
  IN phone VARCHAR(20),
  IN email VARCHAR(100),
  IN items_brought TEXT,
  IN problem TEXT,
  IN solution TEXT,
  IN estimate DECIMAL(10,2),
  IN status VARCHAR(20),
  IN notes TEXT,
  IN drop_off DATE
)
BEGIN
  INSERT INTO customers (first_name, last_name, address, city, state, zip, phone, email)
  VALUES (first_name, last_name, address, city, state, zip, phone, email);

  SET @cust_id = LAST_INSERT_ID();

  INSERT INTO repairs (customer_id, drop_off_date, items_brought, problem, solution, estimate, status, notes)
  VALUES (@cust_id, drop_off, items_brought, problem, solution, estimate, status, notes);
END;
//

-- Add Install for Existing Customer
CREATE PROCEDURE AddInstallForCustomer (
  IN customer_id INT,
  IN description TEXT,
  IN estimate DECIMAL(10,2),
  IN install_date DATE,
  IN notes TEXT
)
BEGIN
  INSERT INTO installs (customer_id, description, estimate, install_date, notes)
  VALUES (customer_id, description, estimate, install_date, notes);
END;
//

-- Add Repair for Existing Customer
CREATE PROCEDURE AddRepairForCustomer (
  IN customer_id INT,
  IN items_brought TEXT,
  IN problem TEXT,
  IN solution TEXT,
  IN estimate DECIMAL(10,2),
  IN status VARCHAR(20),
  IN notes TEXT,
  IN drop_off DATE
)
BEGIN
  INSERT INTO repairs (customer_id, items_brought, problem, solution, estimate, status, notes, drop_off_date)
  VALUES (customer_id, items_brought, problem, solution, estimate, status, notes, drop_off);
END;
//

-- Add Order for Existing Customer
CREATE PROCEDURE AddOrderForCustomer (
  IN customer_id INT,
  IN order_date DATE
)
BEGIN
  INSERT INTO orders (customer_id, order_date)
  VALUES (customer_id, order_date);
END;
//

DELIMITER ;
