Day 01 :- Terraform with AWS

What is Infrastructure as a Code ( IaC )

Writing a code to provision your infrastructure like servers or multiple other services in cloud. There are many tools used for IaC example :- Terraform , Pulumi ,

Cloud specific Iac tools 

AWS CloudFormation, AWS CDK (AWS only)

Azure ARM | Bicep (Azure only)


Why do we need Infrastructure as a code?

Manually setting up infrastructure for any enterprise level application takes time for a single environment ( e.g DEV , UAT )
Enterprises have multiple environments for single application like testing , pre-prod, prod and DR.

Without the infrastructure provisioned application development team would not be able to deploy the applications creating a dependency.

Manually setup for infrastructure is very time consuming and requires precision and chances of humar error increases.


Solution :-

Using terraform, Instead of manually setting up infra. The devops team will write terraform config file and then they will use it to provision infrastructure. This approach is very time saving
It will help with any security patches and upgrades 

When you dont need any environments we can destroy them easily using terraform. You are using the same file to provision infra in multiple environments.

It works on "Write once and deploy many" approach




How terraform works ?

The terraform interacts with AWS API to create modify or delete resources in the Cloud Platform.
