# Project Name

This project is an AWS API Gateway that uses Lambda as an endpoint. It is built using Terraform for infrastructure provisioning and management.
In addition, there is an AWS CodePipeline with CodeBuild that updates the Lambda.

## Prerequisites

Before getting started, make sure you have the following:

- AWS CLI configured with your AWS credentials.
- Create a GitHub v2 connection for your AWS pipeline and update the `variables.tf` file with the ARN.
    You can do so when you go into AWS CodePipeline, Settings and Connections.
- Create a Secret in AWS Secrets Manager. You can use an empty one if you dont need one yet.
    But this Config needs one if you want to add real secrets to your Lambda later on.

## Getting Started

To get started with this project, follow these steps:

1. Click on "Use this Template" in the upper right corner and click create a new repository

2. Give this repository a name of your liking and clone it to your machine

```bash
git clone <REPOSITORY_LINK_OF_YOUR_CREATED_REPO>
```

3. Change the variable names as you like in the  `variables.tf`. Make sure to leave the config as it is. Only change names.

VERY IMPORTANT!!!! DON'T FORGET THE GITHUB CONNECTION ARN AND AWS SECRETS ARN AND I

If you don't want to use secrets at any point, remove the secrets from the configuration.
To do so, go into the lambda.tf and remove the lambda environment and the one statement of the policy

4. Change the variables (S3-Bucket and Tablename) to something unique and choose your region in the setup.sh at the top
    This is important. S3 Bucket Names are globally unique, so be creative.

5. Run the `setup.sh` script to set up the necessary dependencies.
```bash
./setup.sh
```
6. If there is a permission problem change it" should be "5. If there is a permission problem, change it

7. If there is a permission problem change it
```bash
chmod 700 setup.sh deploy.sh
```

## Customizing the Code of your Lambda

To customize the code to fit your needs, follow these steps:

1. Open the `index.js` file in the lambda directory and make the necessary changes to meet your requirements.
2. Save the changes.

## Deployment

Once you're done with the first version or left the demo as it is, run the deployment script
```bash
./deploy.sh
```

If everything was successfull try the curl request with the provided Staging URL
```bash
curl "STAGINGURL/verify?token=asdfasdf"
```

If you want to make some changes to the code now, you only have to push your repo. The pipeline should do the rest.