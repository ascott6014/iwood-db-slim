use iwoodslim;

-- customer visit triggers

DELIMITER $$  
CREATE TRIGGER trg_order_visit
AFTER INSERT ON orders
FOR EACH ROW
BEGIN
  INSERT INTO customer_visits (customer_id, visit_type, visit_date)
  VALUES (NEW.customer_id, 'Order', NOW());
END$$  
DELIMITER ;

DELIMITER $$  
CREATE TRIGGER trg_install_visit
AFTER INSERT ON installs
FOR EACH ROW
BEGIN
  INSERT INTO customer_visits (customer_id, visit_type, visit_date)
  VALUES (NEW.customer_id, 'Install', NOW());
END$$  
DELIMITER ;


DELIMITER $$  
CREATE TRIGGER trg_repair_visit
AFTER INSERT ON repairs
FOR EACH ROW
BEGIN
  INSERT INTO customer_visits (customer_id, visit_type, visit_date)
  VALUES (NEW.customer_id, 'Repair', NOW());
END$$  
DELIMITER ;



-- item price log triggers

DELIMITER $$
CREATE TRIGGER trg_item_insert
AFTER INSERT ON items
FOR EACH ROW
INSERT INTO item_price_log (item_id, cost, markup_rate, price, start_date, is_active)
VALUES (NEW.item_id, NEW.cost, NEW.markup_rate, NEW.price, CURDATE(), TRUE);
DELIMITER ;

DELIMITER $$
CREATE TRIGGER trg_item_cost_markup_update
BEFORE UPDATE ON items
FOR EACH ROW
BEGIN
  IF OLD.cost != NEW.cost OR OLD.markup_rate != NEW.markup_rate THEN
    -- End current active price log
    UPDATE item_price_log
    SET end_date = CURDATE(), is_active = FALSE
    WHERE item_id = OLD.item_id AND is_active = TRUE;

    -- Insert new price log entry
    INSERT INTO item_price_log (item_id, cost, markup_rate, price, start_date, is_active)
    VALUES (NEW.item_id, NEW.cost, NEW.markup_rate, NEW.price, CURDATE(), TRUE);
  END IF;
END$$
DELIMITER ;

-- repair item total price trigger
DELIMITER $$  
CREATE TRIGGER trg_repair_items_total_price
BEFORE INSERT ON repair_items
FOR EACH ROW
BEGIN
  DECLARE item_price DECIMAL(10,2);

  SELECT price INTO item_price
  FROM items
  WHERE item_id = NEW.item_id;

  SET NEW.total_price = item_price * NEW.repair_item_quantity;
END$$  
DELIMITER ;

DELIMITER $$  
CREATE TRIGGER trg_repair_items_total_price_update
BEFORE UPDATE ON repair_items
FOR EACH ROW
BEGIN
  DECLARE item_price DECIMAL(10,2);

  SELECT price INTO item_price
  FROM items
  WHERE item_id = NEW.item_id;

  SET NEW.total_price = item_price * NEW.repair_item_quantity;
END$$  
DELIMITER ;


-- install item total price trigger
DELIMITER $$  
CREATE TRIGGER trg_install_items_total_price
BEFORE INSERT ON install_items
FOR EACH ROW
BEGIN
  DECLARE item_price DECIMAL(10,2);

  SELECT price INTO item_price
  FROM items
  WHERE item_id = NEW.item_id;

  SET NEW.total_price = item_price * NEW.install_item_quantity;
END$$  
DELIMITER ;

DELIMITER $$  
CREATE TRIGGER trg_install_items_total_price_update
BEFORE UPDATE ON install_items
FOR EACH ROW
BEGIN
  DECLARE item_price DECIMAL(10,2);

  SELECT price INTO item_price
  FROM items
  WHERE item_id = NEW.item_id;

  SET NEW.total_price = item_price * NEW.install_item_quantity;
END$$  
DELIMITER ;

-- order item total price trigger
DELIMITER $$  
CREATE TRIGGER trg_order_items_total_price
BEFORE INSERT ON order_items
FOR EACH ROW
BEGIN
  DECLARE item_price DECIMAL(10,2);

  SELECT price INTO item_price
  FROM items
  WHERE item_id = NEW.item_id;

  SET NEW.total_price = item_price * NEW.order_item_quantity;
END$$  
DELIMITER ;

DELIMITER $$  
CREATE TRIGGER trg_order_items_total_price_update
BEFORE UPDATE ON order_items
FOR EACH ROW
BEGIN
  DECLARE item_price DECIMAL(10,2);

  SELECT price INTO item_price
  FROM items
  WHERE item_id = NEW.item_id;

  SET NEW.total_price = item_price * NEW.order_item_quantity;
END$$  
DELIMITER ;

-- tax log triggers
DELIMITER //

CREATE TRIGGER trg_insert_tax_log
AFTER INSERT ON tax_rate
FOR EACH ROW
BEGIN
  INSERT INTO tax_log (tax_rate_id, rate, start_date, is_active)
  VALUES (NEW.tax_rate_id, NEW.tax_rate, NOW(), TRUE);
END;
//

DELIMITER ;

DELIMITER //

CREATE TRIGGER trg_tax_rate_change_log
AFTER UPDATE ON tax_rate
FOR EACH ROW
BEGIN
  -- Only act if the tax_rate value changed
  IF OLD.tax_rate <> NEW.tax_rate THEN
    -- Mark previous active logs for this tax_rate_id as inactive
    UPDATE tax_log
    SET is_active = FALSE, end_date = NOW()
    WHERE tax_rate_id = NEW.tax_rate_id AND is_active = TRUE;

    -- Insert new log entry with updated rate
    INSERT INTO tax_log (tax_rate_id, rate, start_date, is_active)
    VALUES (NEW.tax_rate_id, NEW.tax_rate, NOW(), TRUE);
  END IF;
END;
//

DELIMITER ;

