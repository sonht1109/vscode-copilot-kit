# Backend Code Quality References

## Clean Code Practices

### Meaningful Naming

```javascript
// Good: descriptive variable names
const userProfile = getUserProfile(userId);
// Bad: vague variable names
const up = getUserProfile(uid);
```

### Single Responsibility Principle

```javascript
// Good: function does one thing
function calculateTotalPrice(items) {
  return items.reduce((total, item) => total + item.price, 0);
}
// Bad: function does multiple things
function processOrder(order) {
  const totalPrice = order.items.reduce((total, item) => total + item.price, 0);
  saveOrderToDatabase(order);
  sendOrderConfirmationEmail(order);
  return totalPrice;
}
```

### Avoid magic numbers

```javascript
// Good: use named constants
const MAX_LOGIN_ATTEMPTS = 5;
if (loginAttempts > MAX_LOGIN_ATTEMPTS) {
  lockAccount();
}
// Bad: use magic numbers
if (loginAttempts > 5) {
  lockAccount();
}
```

### Error Handling

Use specific error handling with a structured logger — never `console.log` or `console.error` for error reporting in production code.

```javascript
// Good: specific error handling with structured logging
try {
  const data = fetchData();
} catch (error) {
  if (error instanceof NetworkError) {
    logger.error("Network error occurred while fetching data", {
      error: error.message,
      endpoint: url,
    });
    handleNetworkError();
  } else if (error instanceof DatabaseError) {
    logger.error("Database error occurred while fetching data", {
      error: error.message,
    });
    handleDatabaseError();
  } else {
    logger.error("Unexpected error occurred", {
      error: error.message,
      stack: error.stack,
    });
    Sentry.captureException(error);
  }
}
// Bad: generic error handling with console
try {
  const data = fetchData();
} catch (error) {
  console.error("An error occurred:", error);
  handleError();
}
```

### Don't Repeat Yourself (DRY)

```javascript
// Good: reusable function
function calculateArea(width, height) {
  return width * height;
}
const area1 = calculateArea(5, 10);
const area2 = calculateArea(7, 14);
// Bad: repeated code
const area1 = 5 * 10;
const area2 = 7 * 14;
```
