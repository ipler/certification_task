pipeline {
    agent any 
    stages {
        stage('Checkout GitHub') {
            steps {
                git branch: 'main',
                credentialsId: 'dd81dd43-34ad-49e5-825d-ce553906822f',
                url: 'git@github.com:ipler/certification_task.git'
            }
        }
        stage('Copy aws_private_key in workspace') {
            steps {
                dir("/var/lib/jenkins") {
                    fileOperations([fileCopyOperation(excludes: '', 
                                                        flattenFiles: true, includes: 'aws___key_pair_rsa_1_.pem', 
                                                        targetLocation: "${WORKSPACE}/ansible")])
                }
            }
        }
        stage('Create file /terraform/hosts') {
            steps {
                sh "touch ./terraform/hosts"
            }
        }
        stage('Terraform initializing ec2 instances') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: '8673bf69-dada-4325-b294-0380ba495d02',
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]) {
                    sh """
                    terraform -chdir='terraform/' init
                    terraform -chdir='terraform/' apply -auto-approve                
                    """
                }
            }
        }
        stage('Creating /ansible/hosts') {
            steps {
                sh "mv ./terraform/hosts ./ansible/hosts"
            }
        }
        stage('Ansible configuration ec2 instances') {
            steps {
                ansiblePlaybook credentialsId: '7c300873-afd0-4743-ad3e-4e36ddb3c3c0', 
                disableHostKeyChecking: true, 
                installation: 'ansible', 
                inventory: './ansible/hosts', 
                playbook: './ansible/main.yml', 
                vaultTmpPath: ''
            }
        }
        stage('Moving targetFile to workspace') {
            steps {
                dir("/tmp") {
                    fileOperations([fileCopyOperation(excludes: '', 
                                                        flattenFiles: true, 
                                                        includes: 'hello-1.0.war', 
                                                        targetLocation: "${WORKSPACE}")])
                }
            }
        }
		stage('Build docker image') {
			steps {
				sh 'docker build -t gotofront/webapp:1.0 .'
			}
		}
		stage('DockerHub login & Push') {
			steps {
				withDockerRegistry(credentialsId: '377826f5-81fd-4c82-bc20-90ae1d50f2f5', url: 'https://index.docker.io/v1/') {
					sh 'docker push gotofront/webapp:1.0'
				}
			}
		}
		stage('Pull/Run docker image on a remote host') {
			steps {
                sh "chmod +x script.sh && ./script.sh"
			}
		}       
    }
}
