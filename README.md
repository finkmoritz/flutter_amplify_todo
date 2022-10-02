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

### Configure Amplify DataStore

Execute ```amplify add api``` with following configuration:
````
Select from one of the below mentioned services: 
GraphQL

Here is the GraphQL API that we will create. Select a setting to edit or continue (Use arrow keys)
Name: <provide any name>
Authorization modes: Cognito User Pool
Conflict detection (required for DataStore): Enabled 
Conflict resolution strategy: Auto Merge 

Choose a schema template: 
Single object with fields (e.g., “Todo” with ID, name, description)
````

Push your changes using ```amplify push```.

### Configure Amplify Storage

Execute ```amplify add storage``` with following configuration:
````
Select from one of the below mentioned services: 
Content (Images, audio, video, etc.)
Provide a friendly name for your resource that will be used to label this category in the project:
<provide any name>
Provide bucket name:
<provide any name>
Who should have access:
Auth users only
What kind of access do you want for Authenticated users?
create/update, read, delete
Do you want to add a Lambda Trigger for your S3 Bucket? (y/N)
no
````

Push your changes using ```amplify push```.

### Configure Amplify Analytics

Execute ```amplify add analytics``` with following configuration:
````
Select an Analytics provider 
Amazon Pinpoint
Provide your pinpoint resource name:
<provide any name>
Apps need authorization to send analytics events. Do you want to allow guests and unauthenticated users to send analytics events? (we recommend you allow this when getting started)
Yes
````

Push your changes using ```amplify push```.
