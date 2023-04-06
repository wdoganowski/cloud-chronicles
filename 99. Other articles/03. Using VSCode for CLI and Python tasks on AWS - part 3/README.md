# Using VSCode for CLI and Python tasks on AWS

![VSCode example](images/vscode.png)




## VSCode extensions

The VSCode extensions provide a powerful way to customize and enhance VS Code for specific programming languages, workflows, and development environments.

I suggest to install the [Python Extension Pack](https://marketplace.visualstudio.com/items?itemName=donjayamanne.python-extension-pack), which is a collection of extensions for Visual Studio Code that are focused on Python development. The extension pack includes several popular extensions for Python developers, such as:

1. Python - Linting, Debugging (multi-threaded, remote), Intellisense, code formatting, refactoring, unit tests, snippets, Data Science (with Jupyter), PySpark and more.
1. Jinja - Jinja template language support for Visual Studio Code.
1. Django - Beautiful syntax and scoped snippets for perfectionists with deadlines.
1. Visual Studio IntelliCode - Provides AI-assisted productivity features for Python developers in Visual Studio Code with insights based on understanding your code combined with machine learning..
1. Python Environment Manager - Provides the ability to view and manage all of your Python environments & packages from a single place.
1. Python Docstring Generator - Quickly insert Python comment blocks with contextually inferred parameters for classes and methods based on multiple, selectable template patterns.
1. Python Indent - Correct Python indentation in Visual Studio Code.
1. Jupyter - Provides Jupyter notebook support for Python language, used for data science, scientific computing, and machine learning.

As you can see the Python Extension Pack provides a convenient way for Python developers to quickly set up a productive development environment in Visual Studio Code

### Install Python extension

To install the Python Extension Pack in Visual Studio Code, you can follow these steps:

1. In Visual Studio Code click on the "Extensions" icon on the left-hand side of the window, or press Ctrl+Shift+X (Windows/Linux) or Cmd+Shift+X (macOS) to open the Extensions view.
1. In the search bar, type "Python Extension Pack" and press Enter.
1. The extension pack should appear in the search results. Click on the "Install" button to install it.
1. After installation, you may be prompted to reload VS Code for the changes to take effect. If so, click on the "Reload" button.

![Python extension pack](images/python_extension.png)

That's it! The Python Extension Pack is now installed and ready to use in Visual Studio Code. You can start using the Python-specific features and functionality provided by the extensions included in the pack.

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