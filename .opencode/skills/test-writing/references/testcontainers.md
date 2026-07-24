# Testcontainers

## What is Testcontainers?

Testcontainers is library that provides throwaway instances of databases, message brokers, web browsers, or anything else that can run in a Docker container. It enables developers to write reliable integration tests by spinning up real service dependencies in isolated containers, eliminating the need for mocks or complex local setups. The library automatically manages container lifecycle, port mapping, and cleanup.

Testcontainers supports a wide range of databases (e.g., PostgreSQL, MySQL, MongoDB), message brokers (e.g., RabbitMQ, Kafka), and other services. It is available for multiple programming languages, including Java, Node.js, Python, and .NET.

## How to use Testcontainers in integration tests?

Example of Node.js integration test using Testcontainers with Jest:

```javascript
// jest.config.js
module.exports = {
  globalSetup: "./jest.global-setup.js",
  globalTeardown: "./jest.global-teardown.js",
  setupFiles: ["./jest.setup.js"],
};
```

```javascript
// jest.global-setup.js

// setup testcontainers for PostgreSQL and Redis before running tests

const { PostgreSqlContainer } = require("@testcontainers/postgresql");
const { RedisContainer } = require("@testcontainers/redis");
const fs = require("fs");
const { Client } = require("pg");

module.exports = async function () {
  const pgContainer = await new PostgreSqlContainer(
    "postgres:18-alpine",
  ).start();
  const redisContainer = await new RedisContainer("redis:7-alpine").start();

  global.__PG_CONTAINER__ = pgContainer;
  global.__REDIS_CONTAINER__ = redisContainer;

  console.log("Database configuration:", pgContainer.getConnectionUri());
  console.log("Redis configuration:", redisContainer.getConnectionUrl());

  const envContent = [
    `DATABASE_URL=${pgContainer.getConnectionUri()}`,
    `REDIS_URL=${redisContainer.getConnectionUrl()}`,
  ].join("\n");

  fs.writeFileSync(".env.test", envContent);

  // setup database schema once here or seed data if needed
  const client = new Client({
    connectionString: pgContainer.getConnectionUri(),
  });
  await client.connect();
  await client.query(`CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
  )`);
  await client.end();
};
```

```javascript
// jest.global-teardown.js

// stop testcontainers after running tests
const fs = require("fs");

module.exports = async function () {
  await global.__PG_CONTAINER__.stop();
  await global.__REDIS_CONTAINER__.stop();

  // remove .env.test file
  if (fs.existsSync(".env.test")) {
    fs.unlinkSync(".env.test");
  }
};
```

```javascript
// jest.setup.js

// load environment variables from .env.test
require("dotenv").config({ path: ".env.test", override: true });
```

For more details on how to use Testcontainers, use `/docs-seeking` skills to find the official documentation and examples for your specific programming language and testing framework.
