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
WHERE o.status 'active'
UNION
SELECT u.id, o.id FROM users u
JOIN orders o ON u.id = o.user_id
WHERE u.id = 1;
```

### Avoid SELECT *

Should always specify the required columns instead of using `SELECT *`, which can lead to unnecessary data retrieval and impact performance.

```sql
-- Bad: using SELECT *
SELECT * FROM users;

-- Good: specify required columns
SELECT id, name, email FROM users;
```
