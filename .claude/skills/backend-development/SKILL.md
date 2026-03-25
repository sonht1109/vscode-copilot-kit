---
name: backend-development
description: Build a robust backend system with databases, APIs, and server-side logic. Use when designing and implementing APIs, database query optimization, handle security vulnerabilities and other backend system tasks.
---

## Core Conventions

These conventions apply to ALL backend code. They override your defaults because they represent this project's standards, not general best practices.

### JSON Response Format

All JSON response keys MUST use `snake_case`. This is a deliberate project convention — Claude's default is camelCase, which is wrong for this project.

```json
// Correct (this project's convention)
{ "user_id": 1, "first_name": "John", "created_at": "2024-01-01" }

// Wrong (Claude's default)
{ "userId": 1, "firstName": "John", "createdAt": "2024-01-01" }
```

### Structured Logging

Use a structured logger (e.g. `logger.info()`, `logger.error()`, `logger.warn()`), never `console.log` or `console.error`. Structured logs with metadata are essential for observability in production.

```javascript
// Correct
logger.error('Order creation failed', {
  error: error.message,
  user_id: userId,
  product_id: productId,
});

// Wrong
console.error('Order creation failed:', error);
console.log(error);
```

### Input Validation

Use schema validation libraries (`zod`, `Joi`, or `class-validator`) instead of writing manual validation functions. Schema libraries provide consistent error formats, type coercion, and are easier to maintain.

```javascript
// Correct — use zod
const createOrderSchema = z.object({
  user_id: z.number().int().positive(),
  product_id: z.number().int().positive(),
  quantity: z.number().int().positive().max(1000),
});

// Wrong — manual validation
if (!userId || typeof userId !== 'number') { ... }
```

## References

Read the relevant reference when working in that domain:

- [backend-database](./references/backend-database.md): query optimization, transactions.
- [backend-security](./references/backend-security.md): injection prevention, cryptography, logging security, input validation.
- [backend-code-quality](./references/backend-code-quality.md): naming, SRP, error handling, constants.
