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

