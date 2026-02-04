# Backend API Design References

## RESTful principles

### Resource Naming

```
// Good: use nouns for resources
GET /users
POST /orders

// Bad: use verbs for resources
GET /get-users
POST /create-order

// Good: use kebab-case
GET /user-profiles

// Bad: use camelCase or underscores
GET /userProfiles
GET /user_profiles

// Good: clear relationships
GET /users/:user_id/orders

// Bad: unclear relationships
GET /getUserOrders/:user_id
```

### Request/Response Structure

```json
// Good: use snake_case for JSON keys
{
  "user_id": 1,
  "first_name": "John",
  "last_name": "Doe"
}

// Bad: use camelCase for JSON keys
{
  "userId": 1,
  "firstName": "John",
  "lastName": "Doe"
}
```
