---
name: docs-seeker
description: Search library/framework documentation via llms.txt (context7.com). Use for API docs, GitHub repository analysis, technical documentation lookup, latest library features. Common pattern use case: "How to use [component] in [library]?", "How can I integrate [component] in [library]?", "How to setup [component] in [library]?".
---

# docs-seeker Skill

## Prerequisites

- Setup CONTEXT7_API_KEY in .env file with your API key from context7.com.
- Setup `context7-mcp` server running locally.

## Steps

1. **Detect User Intent**: Only use if the user query indicates they are looking for documentation or code examples related to a specific library, framework, or API. Look for keywords like "how to use", "integrate", "setup", "documentation", "API reference", etc. If yes, proceed to step 2. If no, skip this skill.

2. **Prepare query**: From the user query, extract the library/framework name. Also, update the query to specifically ask for code examples if not already included. Output:
- prepared_query
- library_name

3. **Extract library id**: Use #tool:context7-mcp/resolve-library-id to get exact library id.
- input:
```json
{
  "query": "<prepared_query>",
  "library": "<library_name>"
}
```

- output: output will be a list of result object. Eg:
```json
[
  {
    "id": "/facebook/react",
    "name": "React",
    "description": "A JavaScript library for building user interfaces",
    "totalSnippets": 1250,
    "trustScore": 95,
    "benchmarkScore": 88,
    "versions": ["v18.2.0", "v17.0.2"]
  }
]
```

Get the top 3 results with highest trustScore and benchmarkScore. For each result, extract the id field as `library_id` to use in next step until you get relevant documentation in step 4.

4. **Fetch documentation**: Use #tool:context7-mcp/query-docs to get the relevant documentation and code examples.
- input:
```json
{
  "libraryId": "<library_id>",
  "query": "<prepared_query>",
  "type": "json", // or txt
}
```

5. **Format and return results**: Format the output from the previous step to return relevant documentation snippets and code examples to the user. Ensure the response is concise and directly addresses the user's query.

## Notes
- If fails to use mcp server, inform user to solve issue.
- If fails to get docs or docs return empty, inform user that no relevant documentation was found for their query.
