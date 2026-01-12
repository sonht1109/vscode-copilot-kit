---
description: 'Use this instruction when creating unit tests/integration tests for the given code to ensure its correctness and reliability.'
name: Unittest Rules
---

# Unit Test Instructions

When creating unit tests for the given code, follow these guidelines to ensure the tests are effective and maintainable:

## Core Guidelines

1. **Comprehensive Coverage**: Ensure that all critical functionalities of the code are covered by tests. Focus on:
- Happy cases
- Error cases
- Edge cases if possible
- Input validation if possible
2. **Grouping Similar Cases**: If multiple test cases share the same expected behavior, group them together to avoid redundancy. For example:

```javascript,typescript
// Good - Group similar test cases together
describe('FunctionName', () => {
  it('should handle error case when input is invalid', () => {
    // given that invalidInput is 0, false, null, undefined, etc.
    const error = new Error('Invalid input');
    // Test implementation
    expect(functionName(0)).toThrow(error);
    expect(functionName(null)).toThrow(error);
    expect(functionName(undefined)).toThrow(error);
    expect(functionName(false)).toThrow(error);
  });
  // More tests...
});

// Bad - Redundant test cases
describe('FunctionName', () => {
  it('should handle error case when input is 0', () => {
    const error = new Error('Invalid input');
    expect(functionName(0)).toThrow(error);
  });
  it('should handle error case when input is null', () => {
    const error = new Error('Invalid input');
    expect(functionName(null)).toThrow(error);
  });
  // More tests ...
});
```
3. **Correctness**: Write tests based on the expected correct behavior of the function. If you identify any issues in the code while writing tests, document them clearly without modifying the tests to accommodate incorrect behavior.
4. **Execution**: Always run the test file after creating or editing it to ensure it works as intended. Make sure coverage is at least 80%.