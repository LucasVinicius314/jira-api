# jira-api

 

## About

A project that makes use of a [Typescript](https://www.typescriptlang.org/) back end and a [Flutter](https://flutter.dev/) web front end to consume the [Jira API](https://developer.atlassian.com/cloud/jira/platform/rest/v3/intro/) in order to visualize and interact with issues.

## Build & run

Both the back end and the front end have their respective launch configuration files inside their own `.vscode` folders.

Don't forget to set up your own `.env` config file for the back end, using the `.env.example` as an example.

## Configuration

```diff
PORT             => the port that the back end will be running on
DATABASE_URL     => your PostgreSQL connection string
SECRET           => the secret that will be used to sign JWTs
MASTER_KEY       => the security key that's needed to grant the user creation permission
NODE_ENV         => the node's environment mode
```

[Environment](sure-jira-api.herokuapp.com/)
