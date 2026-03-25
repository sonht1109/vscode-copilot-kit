# Backend Database References

## Query optimization

### Ugly OR conditions

`OR` condition might lead to inefficient query plans and slow performance so **MUST** avoid using it if possible. Consider replacing with:

- `IN` clause: in case of multiple equality checks on the same column.
- `UNION` operator: in case of multiple conditions on different columns.

```sql
-- Bad: using OR
SELECT * FROM users WHERE status = 'active' OR status = 'pending' OR status = 'suspended';

-- Good: use IN
SELECT * FROM users WHERE status IN ('active', 'pending', 'suspended');

-- Bad: using OR
SELECT u.id, o.id FROM users u
JOIN orders o ON u.id = o.user_id
WHERE o.status = 'active' or u.id = 1;

-- Good: using OR with UNION
SELECT u.id, o.id FROM users u
JOIN orders o ON u.id = o.user_id
WHERE o.status = 'active'
UNION
SELECT u.id, o.id FROM users u
JOIN orders o ON u.id = o.user_id
WHERE u.id = 1;
```

## Transactions

When multiple database operations must succeed or fail together, wrap them in a transaction. This prevents inconsistent state (e.g., an order created but inventory not decremented).

```javascript
const connection = await db.getConnection();
try {
  await connection.beginTransaction();

  await connection.execute(
    "INSERT INTO orders (user_id, product_id, qty, total) VALUES (?, ?, ?, ?)",
    [userId, productId, quantity, totalPrice],
  );

  await connection.execute(
    "UPDATE inventory SET stock = stock - ? WHERE product_id = ? AND stock >= ?",
    [quantity, productId, quantity],
  );

  await connection.commit();
} catch (error) {
  await connection.rollback();
  throw error;
} finally {
  connection.release();
}
```
