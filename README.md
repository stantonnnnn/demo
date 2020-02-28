# Introduction

This git repository illustrates a demo workflow for running a Python web app in AWS, but in a relatively secure way.

This is handled through Terraform, Ansible, and Jenkins.

## Terraform

Terraform is utilized for the deployment of EC2 instances into AWS. The `terraform.tstate` files are excluded from commit into the repository.

***FIXME*** *Terraform state should be managed better, instead of relying on the execution host to maintain this file.*

The Terraform deployment ensures that the EC2 instances are able to be accessed by the executor of this playbook only. All other incoming traffic is blocked.

## Ansible

Ansible is utilized to execute Terraform, then build the host. This includes patching the host, installing the Python application, configuring dependent services, and adding in some extra layers of security.

The specifics of these details can be found in the `deploy.yml` file.

## Jenkins

Jenkins is utilized as the automation tool that executes the Ansible and Terraform components above. The `Jenkinsfile` is statically configured to watch this repository only.

The Ansible playbook above requires the Jenkins server to have the following packages installed:

* `git`
* `java`
* `jenkins`
* `jq`

Installation of these prerequisite, and others, may vary depending on your distribution.

## AWS

This workflow also relies upon the [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html) to be configured for the `jenkins` user on the system. This should be set up to access your AWS cloud organization. Otherwise, Terraform won't work without the credentials installed.

### Secrets

The `Jenkinsfile` is statically configured for a number of secrets to allow the workflow to run against AWS and GitHub. The secrets themselves are not configured in this repo (and will never be). However, it is recommended to utilize the same Credential IDs when installing these secrets onto Jenkins servers that will be executing this job.

