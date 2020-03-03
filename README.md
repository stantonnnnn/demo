# Introduction

This git repository illustrates a demo workflow for running a Python web app in AWS, but in a relatively secure way.

This is handled through Terraform, Ansible, Docker, and Jenkins.

## Terraform

Terraform is utilized for the deployment of EC2 instances into AWS. The `terraform.tstate` files are excluded from commit into the repository.

***FIXME*** *Terraform state should be managed better, instead of relying on the execution host to maintain this file.*

The Terraform deployment ensures that the EC2 instances are able to be accessed by the executor of this playbook only. All other incoming traffic is blocked.

## Ansible

Ansible is utilized to execute Terraform, then build the host. This includes patching the host, installing Docker, and adding in some extra layers of security.

The specifics of these details can be found in the `deploy.yml` file.

## Docker

Docker is utilized to run the required Python application, along with the public-facing NGINX container. Both environments are based off of [Publisher Images](https://docs.docker.com/docker-hub/publish/customer_faq/#what-is-the-difference-between-a-community-user-and-a-verified-publisher), with a few required customization pieces being put into the Python image.

This is deployed through Ansible, instead of Docker Compose, since we already have Ansible in place for the rest of the deployment. This may be changed in the future.

## Jenkins

Jenkins is utilized as the automation tool that executes the Ansible and Terraform components above. The `Jenkinsfile` is statically configured to watch this repository only.

The Ansible playbook above requires the Jenkins server to have the following packages installed:

* `git`
* `java`
* `jenkins`
* `jq`

Installation of these prerequisite, and others, may vary depending on your distribution.

### Secrets

The `Jenkinsfile` is statically configured for a number of secrets to allow the workflow to run against AWS and GitHub. The secrets themselves are not configured in this repo (and will never be). However, it is recommended to utilize the same Credential IDs when installing these secrets onto Jenkins servers that will be executing this job.

## AWS

This workflow also relies upon the [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html) to be configured for the `jenkins` user on the system. This should be set up to access your AWS cloud organization. Otherwise, Terraform won't work without the credentials installed.

