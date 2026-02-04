# Backend Security References

## Common Security Vulnerabilities

### Injection Attacks

- Use parameterized queries or prepared statements to prevent SQL injection attacks.

```javascript
// Good: Using parameterized queries
const query = 'SELECT * FROM users WHERE id = ?';
db.execute(query, [userId]);

// Bad: Directly concatenating user input
const query = `SELECT * FROM users WHERE id = ${userId}`;
db.execute(query);
```

### Cryptographic Practices

- MUST Use strong hashing algorithms (e.g., bcrypt, Argon2) for storing passwords.
- Avoid using outdated or weak algorithms (e.g., MD5, SHA1).
- Implement proper key management practices.
- Use TLS/SSL to encrypt data in transit.
- MUST Regularly update and patch cryptographic libraries.
- Avoid hardcoding sensitive information like API keys and passwords in your codebase.

### Logging and Monitoring

- Log security-relevant events (e.g., failed login attempts, access to sensitive data).
- Ensure logs do not contain sensitive information (e.g., passwords, credit card numbers, phone number, user identity number).

### Vulnerable Components

- Regularly update and patch third-party libraries and frameworks.

```bash
npm audit fix
pip-audit --fix
```

## Input Validation and Sanitization

- Validate and sanitize all user inputs (never trust client-side).
- Use libraries like `zod`, `Joi`, or `class-validator` for schema validation.

```javascript
// Using zod
import { z } from 'zod';
const userSchema = z.object({
  username: z.string().min(3).max(30),
  email: z.string().email(),
  age: z.number().min(0).optional(),
});

// Using class-validator
import { IsEmail, IsInt, IsOptional, IsString, Length, Min } from 'class-validator';
class User {
  @IsString()
  @Length(3, 30)
  username: string;
  @IsEmail()
  email: string;
  @IsInt()
  @Min(0)
  @IsOptional()
  age?: number;
}
```
