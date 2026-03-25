---
name: test-writing
description: This skill focuses on writing/designing effective and comprehensive tests for code. It emphasizes the importance of covering various scenarios, including happy cases, error cases, edge cases, and input validation. The skill also highlights the need to write tests based on expected correct behavior rather than current implementation, and to maintain a high level of coverage (at least 80%).
---

# Test Writing

## Core Guidelines

1. **Comprehensive Coverage**: Ensure that all critical functionalities of the code are covered by tests. Focus on:

- Happy cases
- Error cases
- Edge cases if possible
- Input validation if possible

2. **Correctness**: Test on function behavior, not implementation. If the function is wrong, create tests based on the expected behavior, not the actual implementation and report the issue to the user.

3. **Execution**: Always run the test file after creating or editing it to ensure it works as intended.

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

4. **Coverage**: Make sure coverage is at least 80%.

5. **Meaningful Test Names**: Use descriptive names for test cases that clearly indicate what is being tested and the expected outcome. Description and expectation must match.

## Tips

- Never edit original code.
- Remove unnecessary details and focus on the core functionality being tested.
- If result is mocked, no need to validate the result, just validate the input and the call to the mocked function. Eg:

```javascript
// GOOD
it('should propagate error from database', async () => {
  const mockError = new Error('Database error');
  database.query.mockRejectedValue(mockError);

  await expect(myFunction()).rejects.toThrow('Database error');
  expect(database.query).toHaveBeenCalledWith(expectedQuery);
});

// BAD: those errors are mocked errors, we should not validate the result of the mocked function.
// Just merge those into one genric test case for error handling, no need to validate the specific error message, just validate the call to the mocked function.
it('should throw if query is timeout', async () => {
  const mockError = new Error('query timeout');
  database.query.mockRejectedValue(mockError);
  await expect(myFunction()).rejects.toThrow('query timeout');
  expect(database.query).toHaveBeenCalledWith(expectedQuery);
});

it('should throw if database is down', async () => {
  const mockError = new Error('database is down');
  database.query.mockRejectedValue(mockError);
  await expect(myFunction()).rejects.toThrow('database is down');
  expect(database.query).toHaveBeenCalledWith(expectedQuery);
});

// GOOD
it('should return correct result', async () => {
  const mockResult = { id: 1, name: 'Test' };
  database.query.mockResolvedValue(mockResult);

  const result = await myFunction();
  expect(result).toEqual(mockResult);
  expect(database.query).toHaveBeenCalledWith(expectedQuery);
});

// BAD: those results are mocked results, we should not validate the result of the mocked function
// Just merge those into one genric test case for correct result, no need to validate the specific result, just validate the call to the mocked function.
it('should return correct result', async () => {
  const mockResult = { id: 1, name: 'Test' };
  database.query.mockResolvedValue(mockResult);
  const result = await myFunction();
  expect(result).toEqual(mockResult);
  expect(database.query).toHaveBeenCalledWith(expectedQuery);
});

it('result should have correct name', async () => {
  const mockResult = { id: 1, name: 'Test' };
  database.query.mockResolvedValue(mockResult);
  const result = await myFunction();
  expect(result.name).toBe('Test');
  expect(database.query).toHaveBeenCalledWith(expectedQuery);
});
```

- If its unitest, focus on creating unit tests that isolate individual functions or components to verify their behavior in isolation. Do mock on other dependencies if necessary.

- If its integration test or API test:
  - Focus on creating integration tests that verify the interactions between different components or modules to ensure they work together as expected
  - Only do mock on repository/database layer if necessary
  - Focus on input validation, error handling, and the overall flow of data through the system.
