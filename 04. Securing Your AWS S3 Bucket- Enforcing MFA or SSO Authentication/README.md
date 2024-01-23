# Securing Your AWS S3 Bucket: Enforcing MFA and SSO Authentication

In the ever-evolving landscape of cloud security, safeguarding sensitive data stored in Amazon Web Services (AWS) S3 buckets is paramount. I'm sure you're well aware that the foundation of cloud security lies not only in robust encryption and access controls but also in ensuring that only authorized users can access your valuable assets.

This article delves into an advanced yet crucial aspect of AWS security—configuring your S3 bucket to grant access solely to users who have authenticated using Multi-Factor Authentication (MFA) or have logged in through Single Sign-On (SSO) with MFA authentication. We'll navigate through the intricacies of this setup, equipping you with the knowledge and expertise to fortify your AWS environment against unauthorized access.

If you are interested in finding out how to set your AWS account to allow accessing it using the AWS IAM Identity Center SSO instead of logging to the individual accounts in your AWS Organisation (which requires you to remember multiple users and passwords), please read my another article [Easier access to multiple accounts with IAM Identity Center](../02.%20Easier%20access%20to%20your%20accounts%20with%20IAM%20Identity%20Center/README.md).

Coming back to enforcing MFA, in a world where security breaches and data leaks are ever-present threats, our journey to secure AWS S3 buckets begins with a deeper understanding of MFA, SSO with MFA, and the pivotal role they play in enhancing your cloud security posture. Let's embark on this exploration together and empower ourselves with the knowledge and tools to safeguard our digital assets effectively.

So, dear AWS aficionados, fasten your seatbelts as we unlock the secrets to enforcing MFA and SSO authentication in your AWS S3 bucket, ensuring that only the right keys can unlock the treasure chest of your cloud data. In the next few minutes, you'll be well on your way to becoming an expert in securing your AWS S3 resources like a pro.

- [Securing Your AWS S3 Bucket: Enforcing MFA and SSO Authentication](#securing-your-aws-s3-bucket-enforcing-mfa-and-sso-authentication)
  - [Setting the Stage](#setting-the-stage)
    - [The Stakes Are High](#the-stakes-are-high)
    - [AWS Shared Responsibility Model](#aws-shared-responsibility-model)
    - [The Need for Strong Authentication](#the-need-for-strong-authentication)
  - [Applying the Policy to Your S3 Bucket](#applying-the-policy-to-your-s3-bucket)
    - [Step 1: Navigate to Your S3 Bucket](#step-1-navigate-to-your-s3-bucket)
    - [Step 2: Access Permissions Configuration](#step-2-access-permissions-configuration)
    - [Step 3: Edit Bucket Policy](#step-3-edit-bucket-policy)
    - [Step 4: Paste Your IAM Policy](#step-4-paste-your-iam-policy)
    - [Step 5: Test the Configuration](#step-5-test-the-configuration)
      - [Testing using SSO user](#testing-using-sso-user)
      - [Testing using the user without MFA enabled](#testing-using-the-user-without-mfa-enabled)
      - [Testing using the user with MFA enabled](#testing-using-the-user-with-mfa-enabled)
  - [Testing and Verification in Production Environment](#testing-and-verification-in-production-environment)
    - [User Testing](#user-testing)
    - [Access Logging](#access-logging)
    - [Periodic Testing](#periodic-testing)
  - [Additional Considerations](#additional-considerations)
  - [Conclusions](#conclusions)

## Setting the Stage

The digital age has ushered in a transformative era for businesses, enabling them to store, manage, and share data with unprecedented ease and efficiency. One of the cornerstones of this data-driven revolution is the adoption of cloud computing, and Amazon Web Services (AWS) has emerged as a leading player in this domain. AWS S3 (Simple Storage Service) stands as a linchpin in this cloud ecosystem, serving as a secure and scalable storage solution for countless organizations worldwide.

As organizations migrate their data and workloads to AWS S3, the question of security takes center stage. The cloud, while offering remarkable advantages in terms of accessibility and scalability, also introduces a host of new security challenges. In this landscape, the protection of your S3 buckets becomes a critical concern. Unprotected or inadequately secured S3 buckets can lead to unauthorized access, data breaches, compliance violations, and reputational damage.

### The Stakes Are High

Imagine your S3 buckets as digital treasure chests, holding valuable assets such as sensitive customer data, intellectual property, confidential documents, and critical backups. Unauthorized access to these buckets can have dire consequences, ranging from financial losses to legal ramifications and a tarnished brand image. Furthermore, with the ever-increasing sophistication of cyber threats, the importance of a robust defense cannot be overstated.

To underscore the significance of securing your S3 buckets, consider the following scenarios:

Data Privacy Regulations: As global data privacy regulations like GDPR and CCPA become more stringent, organizations face hefty fines for data breaches. A well-secured S3 bucket is your first line of defense against costly compliance violations.

Corporate Espionage: Competitors or malicious actors may attempt to gain unauthorized access to your confidential information, jeopardizing your organization's strategic advantages.

Data Integrity: Unauthorized tampering with your data could lead to misinformation, damaged trust, and compromised decision-making.

### AWS Shared Responsibility Model

In the AWS cloud, security is a shared responsibility between AWS and its customers. While AWS is responsible for the security of the cloud infrastructure, including the physical facilities and network infrastructure, customers are responsible for securing their data and applications within AWS. This means that you have a crucial role to play in implementing effective security measures for your AWS resources, including S3 buckets.

### The Need for Strong Authentication

Authentication is a fundamental building block of any security strategy, and when it comes to AWS S3, enforcing strong authentication mechanisms is imperative. This is where Multi-Factor Authentication (MFA) and Single Sign-On (SSO) with MFA authentication come into play.

In the next sections of this article, we will explore in detail how to configure your S3 buckets to allow access only to users who have authenticated through MFA or SSO with MFA authentication. By the time we're done, you'll be well-equipped to bolster your AWS security posture and ensure that your S3 buckets are protected from unauthorized access.

So, fasten your seatbelts as we embark on this journey to fortify your AWS environment and safeguard your digital assets. We're about to dive deep into the world of MFA and SSO authentication, empowering you with the expertise to secure your AWS S3 resources like a seasoned professional.

## Applying the Policy to Your S3 Bucket

Now that we've crafted a robust IAM policy enforcing Multi-Factor Authentication (MFA) or Single Sign-On (SSO) with MFA authentication, it's time to apply this policy to your AWS S3 bucket. This step is crucial to ensure that only authorized users with the appropriate authentication credentials can access your valuable data.

### Step 1: Navigate to Your S3 Bucket

Log in to your AWS Management Console with the appropriate credentials.

From the AWS dashboard, navigate to the S3 service.

Select the specific S3 bucket to which you want to apply the IAM policy. Keep in mind that you should have the necessary IAM permissions to make changes to the bucket's access policies.

### Step 2: Access Permissions Configuration

Once you've selected the desired bucket, click on the "Permissions" tab. Here, you'll be able to manage the bucket's access control settings.

### Step 3: Edit Bucket Policy

Under the "Permissions" tab, you'll see several sections related to access control. Look for the "Bucket Policy" section and click on "Edit."

### Step 4: Paste Your IAM Policy

In the policy editor, paste the IAM policy listed below. This policy explicitly specifies that only authenticated users with MFA or SSO-MFA authentication are granted access. Be careful when pasting the policy to ensure there are no formatting errors. Remember to replace the `your-bucket-name`.

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Deny",
            "Principal": {
                "AWS": "*"
            },
            "Action": [
                "s3:ListBucket",
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject"
            ],
            "Resource": [
                "arn:aws:s3:::your-bucket-name",
                "arn:aws:s3:::your-bucket-name/*"
            ],
            "Condition": {
                "Null": {
                    "aws:MultiFactorAuthPresent": "true"
                }
            }
        }
    ]
}
```

You can also upload the policy using the CLI, assuming you are logged in with enough permissions:

```sh
$ aws s3api create-bucket --bucket your-bucket-name --region us-east-1
{
    "Location": "/your-bucket-name"
}
$ aws s3api put-bucket-policy --bucket your-bucket-name --policy file://bucket_require_mfa_policy.json
```

Remember to save the above policy to [bucket_require_mfa_policy.json](bucket_require_mfa_policy.json) file.

Note that you can employ an MFA condition in a policy to assess the following attributes:

Presence — to confirm that the user has authenticated using MFA, you can verify the existence of the `aws:MultiFactorAuthPresent` key by employing a Boolean condition. This key is exclusively present when the user has authenticated using short-term credentials. It is important to note that long-term credentials, such as access keys, do not include this key.

Duration — if your objective is to permit access only within a specified time frame after MFA authentication, you can utilize a numeric condition type to compare the age of the `aws:MultiFactorAuthAge` key to a specified value (e.g., 3600 seconds). It's worth mentioning that the `aws:MultiFactorAuthAge` key is absent if MFA has not been utilized.

### Step 5: Test the Configuration

Before your setup is complete, it's essential to test the configuration thoroughly. Try accessing the S3 bucket with different IAM user accounts and confirm that only those with MFA or SSO-MFA authentication can access the contents. This testing phase ensures that your security measures are functioning as intended.

#### Testing using SSO user

To test the configuration using the CLI, you can first log in to the account having full access to S3 using SSO. Ensure you log in using MFA (this is the standard practice) and you will be able to access your test bucket without any issues.

```sh
$ aws sso login --profile your-profile
```

Follow the login process. Then you can try to upload a test file:

```sh
$ touch testfile.txt
$ aws s3 cp testfile.txt s3://your-bucket-name
upload: ./testfile.txt to s3://your-bucket-name/testfile.txt
```

There should be no error displayed.

#### Testing using the user without MFA enabled

Now create a user with full S3 access but without MFA enabled. Accessing the bucket by this user should not be allowed.

The following are required commands.

```sh
$ aws iam create-user --user-name test-user
{
    "User": {
        "Path": "/",
        "UserName": "test-user",
        "UserId": "XXXXXXXXXXXXXXXXXXXXX",
        "Arn": "arn:aws:iam::123456789000:user/test-user",
        "CreateDate": "2023-10-07T18:27:07+00:00"
    }
}
$ aws iam attach-user-policy --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess --user-name test-user
$ aws iam create-access-key --user-name test-user
{
    "AccessKey": {
        "UserName": "test-user",
        "AccessKeyId": "XXXXXXXXXXXXXXXXXXXXX",
        "Status": "Active",
        "SecretAccessKey": "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
        "CreateDate": "2023-10-07T18:28:27+00:00"
    }
}
```

Create a profile for the test user and use the access keys generated earlier

```sh
$ aws configure --profile test-user
AWS Access Key ID [None]: XXXXXXXXXXXXXXXXXXXXX
AWS Secret Access Key [None]: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
Default region name [None]: us-east-1
Default output format [None]: json
```

Now try to upload the `testfile.txt` using the `test-user` account:

```sh
$ aws s3 cp testfile.txt s3://your-bucket-name --profile test-user
upload failed: ./testfile.txt to s3://your-bucket-name/testfile.txt An error occurred (AccessDenied) when calling the PutObject operation: Access Denied
```

Note the operation failed.

#### Testing using the user with MFA enabled

First, we need to create a virtual MFA device:

```sh
$ aws iam create-virtual-mfa-device --virtual-mfa-device-name test-user-mfa-device --outfile qr.png --bootstrap-method QRCodePNG
{
    "VirtualMFADevice": {
        "SerialNumber": "arn:aws:iam::123456789000:mfa/test-user-mfa-device"
    }
}
```

This command will create the `qr.png` with the QR code and return the ARN of the virtual device. You need to display the `qr.png` and scan it with e.g. `Google Authenticator`. Remember to delete the `qr.pnp` after it has been used.

Once you've generated a fresh virtual MFA device, you have the option to link it to a user using `enable-mfa-device`. This command ensures synchronization with AWS by incorporating the initial two codes in sequence from the virtual MFA device.

```sh
$ aws iam enable-mfa-device --user-name test-user --serial-number arn:aws:iam::123456789000:mfa/test-user-mfa-device --authentication-code1 448283 --authentication-code2 032162
```

Finally, we can acquire the temporary session for the `test-user` logged-in with MFA. Of course, you need to replace the codes and the token with your own values from the authenticator app.

```sh
$ aws sts get-session-token --serial-number arn:aws:iam::123456789000:mfa/test-user-mfa-device --token-code 567843 --profile test-user
{
    "Credentials": {
        "AccessKeyId": "XXXXXXXXXXXXXXXXXXXXX",
        "SecretAccessKey": "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
        "SessionToken": "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
        "Expiration": "2023-10-08T07:27:46+00:00"
    }
}
$ export AWS_ACCESS_KEY_ID=XXXXXXXXXXXXXXXXXXXXX
$ export AWS_SECRET_ACCESS_KEY=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
$ export AWS_SESSION_TOKEN=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
```

Now, attempt to upload a file from the AWS CLI again, without specifying the profile. You can log out from SSO to ensure that you are using the temporary session. On top, you can call `get-caller-idendity` to double-check.

```sh
$ aws sso logout
$ aws sts get-caller-identity
{
    "UserId": "XXXXXXXXXXXXXXXXXXXXX",
    "Account": "123456789000",
    "Arn": "arn:aws:iam::123456789000:user/test-user"
}
$ aws s3 cp testfile.txt s3://your-bucket-name
upload: ./testfile.txt to s3://your-bucket-name/testfile.txt
```

Full success.

By following these steps, you've successfully applied a stringent IAM policy to your AWS S3 bucket, ensuring that only authenticated users with MFA or SSO-MFA authentication can access your data. This granular control over access helps fortify your cloud security, making it significantly more challenging for unauthorized users to breach your S3 bucket.

## Testing and Verification in Production Environment

Now that we've configured your AWS S3 bucket to enforce Multi-Factor Authentication (MFA), it's crucial to thoroughly test and verify the setup. This phase ensures that your security measures are effective and that only authorized users gain access.

### User Testing

Begin by selecting a few representative users from your organization. These users should have the necessary permissions to access the S3 bucket.

Ask these users to log in and attempt to access the S3 bucket. Make sure they follow the MFA or SSO-MFA authentication process as required.

Verify that users who haven't completed the MFA or SSO-MFA authentication process are denied access to the S3 bucket.

### Access Logging

Enable access logging for your S3 bucket, if it's not already enabled. This allows you to monitor who is attempting to access your bucket.

Review the access logs to confirm that only authenticated users with MFA or SSO-MFA authentication are successfully accessing the bucket. Look for any unauthorized access attempts or anomalies.

### Periodic Testing

Regularly conduct testing and verification to ensure the continued effectiveness of your security setup. As your organization evolves, so may your user base and access requirements.

By diligently testing and verifying your MFA and SSO-MFA authentication setup, you can be confident that your S3 bucket remains protected against unauthorized access. Regular monitoring and periodic testing are essential components of a robust security strategy.

## Additional Considerations

In addition to the core implementation steps, there are several best practices and further considerations to enhance your AWS S3 bucket security:

1. Regular Policy Reviews
Regularly review and update your IAM policies to align with changing security requirements. This proactive approach ensures that your security measures remain effective over time.

2. Logging and Monitoring
Implement robust logging and monitoring practices. Set up alerts to notify you of any suspicious activity in your S3 bucket, such as repeated failed access attempts.

3. Least Privilege Principle
Follow the principle of least privilege when assigning permissions. Only grant users and applications the minimum access necessary to perform their tasks, reducing the potential attack surface.

4. Auditing and Compliance
Consider conducting regular security audits and assessments to ensure compliance with industry regulations and internal security standards.

5. Multi-Layered Security
Implement a multi-layered security approach that includes encryption, access controls, and regular backups to safeguard your data comprehensively.

By incorporating these best practices and additional considerations into your AWS S3 bucket security strategy, you can fortify your defenses and stay resilient against evolving security threats.

## Conclusions

In this journey toward securing your AWS S3 bucket with Multi-Factor Authentication (MFA) and Single Sign-On (SSO) with MFA authentication, you've acquired valuable insights and practical knowledge. Let's recap the key takeaways:

Security Imperative: The need to secure your S3 buckets cannot be overstated, given the potential risks and consequences of unauthorized access.

Shared Responsibility: In the AWS cloud, security is a shared responsibility between AWS and customers. You play a pivotal role in securing your data.

MFA and SSO-MFA: Multi-Factor Authentication (MFA) and Single Sign-On with MFA authentication are powerful tools to enhance security.

Configuration and Testing: Configuring your IAM policies, testing user access, and verifying security measures are critical steps.

Troubleshooting: Be prepared to troubleshoot common issues that may arise during implementation.

Best Practices: Embrace best practices, including policy reviews, logging, least privilege, auditing, and a multi-layered security approach.

As an AWS Solution Architect Associate, you now have the expertise to secure your AWS S3 resources with confidence. Remember that security is an ongoing process, and staying vigilant is key to protecting your digital assets in the ever-evolving cloud landscape. Continue to adapt and refine your security strategy to address emerging threats and safeguard your organization's data and reputation.
