# Flutter Amplify ToDo Demo App

This demo project demonstrates the use of AWS Amplify to create a serverless ToDo app with Flutter.

## Getting Started

_Note: If not described otherwise, execute commands in the project root folder._

### Prerequisites

Install following tools:
- [git](https://git-scm.com/)
- [Flutter](https://flutter.dev/docs/get-started/install)
- [Node.js](https://nodejs.org/)
- [npm](https://www.npmjs.com/get-npm)

Create an [AWS account](https://portal.aws.amazon.com/billing/signup?redirect_url=https%3A%2F%2Faws.amazon.com%2Fregistration-confirmation#/start)
(in case you do not already have one)

### Configure Amplify CLI

- Install CLI via ```npm install -g @aws-amplify/cli```
- Configure CLI with your AWS profile via ```amplify configure```
- Initialize Amplify in this project via ```amplify init``` (use the AWS profile configured in the previous step)

### Configure Amplify Auth

Execute ```amplify add auth``` with following configuration:
````
 Do you want to use the default authentication and security configuration? 
 Default configuration
 
 How do you want users to be able to sign in? 
 Username
 
 Do you want to configure advanced settings? 
 No, I am done.
````

Push your changes using ```amplify push```.
