# Using VSCode for CLI and Python tasks on AWS

![VSCode example](images/vscode.png)

As part of my upgrade path, I have taken the [Cloud Mastery Bootcamp](https://digitalcloud.training/cloud-mastery-bootcamp) course from [Digital Cloud Training](https://digitalcloud.training/). The company I work with is migrating the Over The Top (OTT) video service to the AWS cloud and being the solution architect of the OTT service I needed to refresh my knowledge and upgrade my cloud skills.

The course is great and includes the AWS Solution Architecture topics, DevOps, Infrastructure as a Code, as well as elements of Linux and Python. In the Python class, we are using the Cloud9 IDE as it is easier to have everyone in a pre-configured environment. Cloud9 is a great AWS IDE, which runs on an EC2 instance in the AWS cloud.

I like it, but I like the Visual Studio Code (a.k.a. VSCode) more. Especially since it is free and runs locally, not on EC2 through the browser window. I decided to ask ChatGPT to help me to write this article, which explains step by step how to get a local environment equivalent to the AWS Cloud9 IDE allowing access to AWS resources using Python and CLI. It should allow to:

1. VSCode IDE - the core of the development environment providing the code editing and the terminal window
2. AWS extension - allowing direct access to AWS resources from VSCode
3. Python3 - Python interpreter
4. Boto3 - The library allowing access to AWS resources from Python
5. AWS CLI - allowing access to AWS resources from the command prompt
6. Of course the Chat GPT extension for VSCode
7. An extra tool allows assuming the roles from CLI, which I will reveal at the end of this article

If you are not sure about the above tools, I will provide some explanations and use cases together with the installation steps below.

As I'm working on my MacBook, so I needed ChatGPT to help me with the information what are the equivalent steps for Ubuntu Linux and Windows. I hope they are not wrong, as I don't have a real way to check them, although I have verified them online, as much as I could. Let me know.

Here are the steps to set up Python3 and VSCode on MacBook, Ubuntu Linux, and Windows PC, and configure it to allow access to AWS resources from the CLI in the VSCode terminal and Python scripts:

## Python3

Python is a popular language for developing applications and scripts for use on the AWS platform. There are several ways in which Python can be used with AWS, including:

Writing AWS Lambda functions: AWS Lambda is a serverless computing service that allows you to run code without provisioning or managing servers. Python is a popular language for developing Lambda functions, which can be triggered by events in other AWS services, such as S3, DynamoDB, and Kinesis.

Developing AWS applications: Python can be used to develop applications that interact with AWS services, such as the AWS SDK for Python (boto3). This allows you to create custom solutions for your specific needs, whether you're building a web application, data pipeline, or machine learning model.

Automating AWS tasks: Python scripts can be used to automate tasks on AWS, such as creating and managing EC2 instances, managing S3 buckets, and managing IAM users and roles. This can help to streamline your workflow and reduce the amount of manual intervention required.

Integrating with AWS services: Python can be integrated with other AWS services, such as Amazon SageMaker, to build and deploy machine learning models. Python can also be used with AWS IoT to build applications that interact with IoT devices, and with AWS Glue to perform ETL (extract, transform, load) operations on data stored in AWS.

### Install Python3 on macOS

Python 3.x is now pre-installed on macOS. You can verify the installation by opening Terminal and running the command:

```sh
$ python3 --version
Python 3.11.2
```

In case the version is not 3.x, you need to install Python 3. I'm not going to repeat the steps, which are greatly presented here: https://docs.python-guide.org/starting/install3/osx/.

### Install Python3 on Ubuntu

In the case of Ubuntu, it is simple, just open the Terminal and run:

```sh
sudo apt update
sudo apt install python3
```

### Install Python3 on Windows

Download the latest Python3 installer from the official website: https://www.python.org/downloads/windows/ and run the installer. Make sure to select "Add Python 3. x to PATH" during the installation process.

## VSCode

Visual Studio Code (VSCode) is a free and open-source code editor developed by Microsoft. It is available on multiple platforms, including Windows, macOS, and Linux, and is designed to be lightweight and customizable. VSCode has several features that make it popular among developers, including support for syntax highlighting, code completion, debugging, Git integration, and a wide range of extensions that can be used to customize and extend its functionality.

It is also highly configurable, with a wide range of settings that can be adjusted to suit individual preferences and workflows. VSCode can be a very useful tool for AWS developers in the following ways:

AWS extensions: There are many extensions available for VSCode that are specifically designed to work with AWS services. For example, the AWS Toolkit for VSCode provides an integrated development environment (IDE) experience for developing serverless applications on AWS, including support for AWS Lambda, AWS SAM, and AWS CloudFormation.

Debugging: VSCode has a powerful built-in debugger that can be used to debug AWS applications running locally or in the cloud. This can be especially helpful for debugging Lambda functions or other serverless applications.

Git integration: VSCode has built-in Git integration that can be used to manage source code and deploy AWS applications using version control. This can help to streamline the development process and ensure that changes are tracked and managed effectively.

Terminal integration: VSCode has a built-in terminal that can be used to interact with the AWS CLI, run scripts, and execute commands. This can be especially helpful for managing AWS resources and running tests.

Customization: VSCode is highly customizable, with a wide range of settings and extensions that can be used to tailor the environment to suit individual preferences and workflows. This can help to improve productivity and make working with AWS more efficient.

### Install VSCode

Download the appropriate installer for your OS from the official website: https://code.visualstudio.com/download and install VSCode by following the instructions for your OS.

Finally, launch VSCode.

Open the terminal (Command Prompt on Windows) in VSCode. Now we are already aligned between the system and we have the same terminal running on each, although still there will be differences between available commands, which depend on the shell, which is available on your machine. The good thing is that the AWS CLI will be common between our three platforms.

## AWS CLI

The AWS CLI (Command Line Interface) is a powerful tool for managing your AWS resources and services through a command-line interface. It allows you to interact with AWS resources using commands in your terminal (or Command Prompt on Windows) rather than using the AWS Management Console or SDK.

The AWS CLI can be useful in a variety of scenarios, including:

Automating repetitive tasks: If you have to perform the same AWS-related tasks regularly, you can use the AWS CLI to automate these tasks by writing scripts that perform the required actions.

Developing and testing applications: Developers can use the AWS CLI to test and deploy their applications using scripts or automation tools. This can help streamline the development and deployment process.

Managing AWS resources in a serverless environment: The AWS CLI is especially useful for managing AWS resources in a serverless environment, where you might be creating and deploying Lambda functions, API Gateway, S3 buckets, and other serverless components using the AWS CLI.

Managing AWS resources across multiple accounts and regions: With the AWS CLI, you can manage AWS resources across multiple accounts and regions using a single tool, making it easy to automate and manage complex AWS environments.

Integrating with other tools and services: The AWS CLI can be integrated with other tools and services, such as Jenkins, Git, and Docker, to automate the deployment and management of AWS resources in these environments.

Overall, the AWS CLI is a versatile and powerful tool that can help automate and streamline your management of AWS resources, whether you're a developer, DevOps engineer, or system administrator.

### Install AWS CLI on macOS

If you have _sudo_ permissions, you can install the AWS CLI for all users on the computer:

```sh
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /
```

In case you are not able to do this, you can follow the instructions from AWS: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html.

### Install AWS CLI on Ubuntu

Run:

```sh
sudo apt install awscli
```

### Install AWS CLI on Windows

Download the MSI installer from the official website: https://aws.amazon.com/cli/ and run the installer. Make sure to select "Add Python to environment variables" during the installation process.

## Configure AWS access

Run:

```sh
aws configure
```

Enter your AWS access key ID, secret access key, default region name, and output format

## AWS SDK for Python (Boto3)

### Install Boto3 on macOS and Ubuntu

In the VSCode terminal window run:

```sh
sudo apt install python3-pip
pip3 install boto3
```

### Install Boto3 on Windows

In the VSCode terminal window run:

```sh
pip3 install boto3
```

## VSCode extensions

### Install Python extension

Click on the "Extensions" icon on the left-hand side panel
Search for "Python" in the search bar and click "Install"
Create a new Python file and add code to access AWS resources:

### PEP8

### ChatGPT

## Python use case

Open VSCode
Create a new Python file by clicking on "File" > "New File"
Save the file with a .py extension
Add your Python code to access AWS resources. Here is a sample code snippet to get you started:
python
Copy code
import boto3

# Create an S3 client
s3 = boto3.client('s3')

# List all S3 buckets in your account
response = s3.list_buckets()

# Print the bucket names
for bucket in response['Buckets']:
    print(bucket['Name'])
That's it! You should now be able to run Python scripts that access AWS resources from the CLI in VSCode terminal and Python scripts on all three OS.

## CLI

once you have installed the AWS CLI and configured your credentials using the aws configure command, you will have access to the AWS CLI from your terminal (or Command Prompt on Windows).

You can open the terminal (or Command Prompt) in VSCode by pressing Ctrl+Shift+ (backtick) or by clicking on "Terminal" > "New Terminal" in the VSCode menu.

From there, you can use any AWS CLI command just like you would in a regular terminal outside of VSCode. For example, to list all your S3 buckets, you can run the following command in the terminal:

bash
Copy code
aws s3 ls
Similarly, you can run any AWS CLI command in the terminal, whether it's for S3, EC2, or any other AWS service.

## Extra tool

Assume role