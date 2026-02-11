# Backend Testing References

## Core Guidelines

1. **Comprehensive Coverage**: Ensure that all critical functionalities of the code are covered by tests. Focus on:

- Happy cases
- Error cases
- Edge cases if possible
- Input validation if possible

2. **Correctness**: MUST Write tests based on the expected correct behavior of the function, NOT the current implementation. If you identify any issues in the code while writing tests, document them clearly without modifying the tests to accommodate incorrect behavior.

3. **Execution**: Always run the test file after creating or editing it to ensure it works as intended. Make sure coverage is at least 80%.

**_IMPORTANT_**: Should always group similar cases if possible into a single test using loops or parameterized tests to avoid redundancy and improve maintainability.
Eg:

```javascript
// GOOD
describe('should throw error if input is invalid', () => {
  it.each([
    { input: null, description: 'null' },
    { input: undefined, description: 'undefined' },
    { input: '', description: 'empty string' },
    { input: 123, description: 'number' },
    { input: {}, description: 'object' },
  ])('throws error for $description input', ({ input }) => {
    expect(() => {
      myFunction(input);
    }).toThrow('Invalid input');
  });
});

// BAD
describe('should throw error if input is invalid', () => {
  it('throws error for null input', () => {
    expect(() => {
      myFunction(null);
    }).toThrow('Invalid input');
  });
  it('throws error for undefined input', () => {
    expect(() => {
      myFunction(undefined);
    }).toThrow('Invalid input');
  });
  it('throws error for empty string input', () => {
    expect(() => {
      myFunction('');
    }).toThrow('Invalid input');
  });
  // ...
});
```
