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

```javascriptjavascript
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

```javascript
// Good: specific error handling and logging
try {
  const data = fetchData();
} catch (NetworkError) {
  logger.error('Network error occurred while fetching data');
  handleNetworkError();
} catch (DatabaseError) {
  logger.error('Database error occurred while fetching data');
  handleDatabaseError();
} catch(unknownError) {
  logger.error('An unknown error occurred', unknownError);
  handleUnknownError();
  Sentry.captureException(unknownError);
}
// Bad: generic error handling
try {
  const data = fetchData();
} catch (error) {
  console.error('An error occurred:', error);
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
