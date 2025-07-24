use iwoodslim;

-- repair summary
CREATE VIEW vw_repair_summary AS
SELECT
  c.customer_id,
  c.first_name,
  c.last_name,
  c.address,
  c.city,
  c.state,
  c.zip,
  c.phone,
  c.email,
  r.repair_id,
  r.items_brought,
  r.problem,
  r.solution,
  r.estimate,
  r.status,
  r.notes,
  r.drop_off_date,
  r.pickup_date,
  COALESCE(SUM(ri.total_price), 0) AS repair_items_total,
  r.estimate + COALESCE(SUM(ri.total_price), 0) AS final_price
FROM
  repairs r
JOIN customers c ON r.customer_id = c.customer_id
LEFT JOIN repair_items ri ON r.repair_id = ri.repair_id
GROUP BY r.repair_id;

-- install summary
CREATE VIEW vw_install_summary AS
SELECT
  c.customer_id,
  c.first_name,
  c.last_name,
  c.address,
  c.city,
  c.state,
  c.zip,
  c.phone,
  c.email,
  ins.install_id,
  ins.description,
  ins.estimate,
  ins.install_date,
  ins.notes,
  COALESCE(SUM(ii.total_price), 0) AS install_items_total,
  ins.estimate + COALESCE(SUM(ii.total_price), 0) AS final_price
FROM
  installs ins
JOIN customers c ON ins.customer_id = c.customer_id
LEFT JOIN install_items ii ON ins.install_id = ii.install_id
GROUP BY ins.install_id;

-- order summary
CREATE VIEW vw_order_summary AS
SELECT
  c.customer_id,
  c.first_name,
  c.last_name,
  c.phone,
  c.email,
  o.order_id,
  o.order_date,
  COALESCE(SUM(oi.total_price), 0) AS order_total,
  COALESCE(SUM(oi.total_price), 0) AS final_price  -- or modify based on tax/shipping later
FROM
  orders o
JOIN customers c ON o.customer_id = c.customer_id
LEFT JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id;


