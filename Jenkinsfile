pipeline {
	agent any
	stages {
		stage('Deploy Python Web App') {
			steps {
				ansiColor('xterm') {
					timestamps {
						// /bin/false doesn't look at /usr/local/bin by default.
						withEnv(['PATH=$PATH:/usr/local/bin']) {
							checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'e658f47f-641c-45f9-aaa0-626f23525ce1', url: 'https://github.com/stantonnnnn/demo.git']]])
							ansiblePlaybook colorized: true, credentialsId: 'cd52d0cc-091c-41b6-a6dd-64628eb5cc5c', disableHostKeyChecking: true, inventory: 'hosts.ini', playbook: 'deploy.yml', vaultCredentialsId: 'ccda5d23-37ec-469a-914f-8af41b88c4d2'
						}
					}
				}
			}
		}
	}
}
