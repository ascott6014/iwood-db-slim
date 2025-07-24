use iwoodslim;

-- test item triggers
INSERT INTO items (
  item_name, item_color, item_model, description,
  cost, markup_rate, quantity,
  sell_item, repair_item, install_item
)
VALUES (
  'Wooden Cabinet', 'Oak', 'WC-1000', 'Solid oak cabinet with soft-close hinges',
  100.00, 30.00, 10,
  TRUE, FALSE, TRUE
);


UPDATE items
SET cost = 120.00
WHERE item_id = 1;

UPDATE items
SET markup_rate = 35.00
WHERE item_id = 1;

UPDATE items
SET cost = 150.00, markup_rate = 40.00
WHERE item_id = 1;

SELECT * FROM item_price_log WHERE item_id = 1 ORDER BY start_date;

-- test customer visit triggers
INSERT INTO customers (
  first_name, last_name, address, city, state, zip, phone, email
) VALUES (
  'Jamie', 'Smith', '123 Elm Street', 'Marion', 'AR', '72364', '870-555-1212', 'jamie.smith@email.com'
);

INSERT INTO orders (
  customer_id, order_date, order_total
) VALUES (
  1, CURDATE(), 250.00
);

INSERT INTO installs (
  customer_id, description, estimate, install_date, notes
) VALUES (
  1, 'Install oak cabinetry with brass hardware', 400.00, CURDATE(), 'Requested morning time slot'
);

INSERT INTO repairs (
  customer_id, items_brought, problem, solution, estimate,
  status, notes, drop_off_date, pickup_date
) VALUES (
  1, 'Cabinet door hinge', 'Loose hardware', 'Replace with reinforced hinge',
  50.00, 'Completed', 'Fixed within same day', NOW(), NOW()
);

SELECT * FROM customer_visits WHERE customer_id = 1 ORDER BY visit_date;


-- test repair summary view
INSERT INTO customers (
  first_name, last_name, address, city, state, zip, phone, email
) VALUES (
  'Jordan', 'Lee', '789 Silicon Ave', 'Memphis', 'TN', '38103',
  '901-555-4433', 'jordan.lee@techmail.com'
);

INSERT INTO repairs (
  customer_id, items_brought, problem, solution, estimate,
  status, notes, drop_off_date, pickup_date
) VALUES (
  1, 'HP Pavilion Laptop', 'Overheating and random shutdowns',
  'Cleaned fans, applied thermal paste, updated BIOS',
  90.00, 'Completed', 'Returned functioning well after 24h diagnostics',
  NOW(), NOW()
);

INSERT INTO items (
  item_name, item_color, item_model, description, cost,
  markup_rate, quantity, sell_item, repair_item, install_item
) VALUES
  ('Thermal Paste', 'Gray', 'TP-110', 'High-performance paste for CPU/GPU', 5.00, 100.00, 25, FALSE, TRUE, FALSE),
  ('Cooling Fan', 'Black', 'CF-220', 'Replacement laptop fan', 12.00, 50.00, 15, FALSE, TRUE, FALSE);

INSERT INTO repair_items (
  repair_id, item_id, repair_item_quantity, total_price
) VALUES
  (1, 1, 1, 10.00),  -- Thermal paste
  (1, 2, 1, 18.00);  -- Cooling fan

SELECT * FROM vw_repair_summary;


-- test install summary view
INSERT INTO customers (
  first_name, last_name, address, city, state, zip, phone, email
) VALUES (
  'Morgan', 'Reed', '901 Circuit Blvd', 'Marion', 'AR', '72364',
  '870-555-2020', 'morgan.reed@techsetup.com'
);

INSERT INTO installs (
  customer_id, description, estimate, install_date, notes
) VALUES (
  1, 'Smart Home Installation: thermostat, speakers, door sensors',
  200.00, CURDATE(), 'Client requested afternoon slot, includes Alexa integration.'
);

INSERT INTO items (
  item_name, item_color, item_model, description, cost,
  markup_rate, quantity, sell_item, repair_item, install_item
) VALUES
  ('Smart Thermostat', 'White', 'ST-200', 'Wi-Fi thermostat with touch control', 120.00, 50.00, 10, TRUE, FALSE, TRUE),
  ('Wireless Door Sensor', 'Black', 'DS-500', 'Low-profile security sensor', 25.00, 40.00, 20, TRUE, FALSE, TRUE);

INSERT INTO install_items (
  install_id, item_id, install_item_quantity, total_price
) VALUES
  (1, 1, 1, 180.00),  -- 1 x Smart Thermostat
  (1, 2, 2, 70.00);   -- 2 x Wireless Door Sensor

SELECT * FROM vw_install_summary WHERE customer_id = 1;

-- test order summary
INSERT INTO items (
  item_name, item_color, item_model, description, cost,
  markup_rate, quantity, sell_item, repair_item, install_item
) VALUES
  ('Gaming Mouse', 'Black', 'GM-900', 'High-DPI RGB gaming mouse', 25.00, 60.00, 50, TRUE, FALSE, FALSE),
  ('Mechanical Keyboard', 'White', 'MK-200', 'RGB backlit mechanical keyboard', 45.00, 50.00, 30, TRUE, FALSE, FALSE);

INSERT INTO order_items (
  order_id, item_id, order_item_quantity, total_price
) VALUES
  (1, 1, 2, 80.00),   -- 2 x Gaming Mouse
  (1, 2, 1, 67.50);   -- 1 x Mechanical Keyboard

SELECT * FROM vw_order_summary WHERE customer_id = 1;
