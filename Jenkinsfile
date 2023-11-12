pipeline {
    agent any 
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                credentialsId: 'dd81dd43-34ad-49e5-825d-ce553906822f',
                url: 'git@github.com:ipler/certification_task.git'
            }
        }
        stage('Command') {
            steps {
                sh 'echo "SUCCESS"'
            }
        }
        stage('COPY') {
            steps {
                dir("/var/lib/jenkins") {
                    fileOperations([fileCopyOperation(excludes: '', flattenFiles: true, includes: 'aws___key_pair_rsa_1_.pem', targetLocation: "${WORKSPACE}")])
                }
            }
        }
        stage('Proverka') {
            steps {
                sh "cp ./aws___key_pair_rsa_1_.pem ./ansible && ls -la ./ansible"
                sh "touch ./terraform/hosts"
                //sh "chmod 400 ./aws___key_pair_rsa_1_.pem"
                sh "pwd && ls -la ./"
                sh "ls -la ./ansible"
                sh "cat ./ansible/hosts"
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
                    terraform -chdir='terraform/' plan
                    terraform -chdir='terraform/' apply -auto-approve                
                    """
                }
            }
        }
        stage('Print & Copy /hosts') {
            steps {
                sh "cat ./terraform/hosts"
                sh "cp ./terraform/hosts ./ansible/hosts"
                sh "cat ./ansible/hosts"
                sh "rm ./terraform/hosts && ls -la ./terraform"
                sh "rm ./aws___key_pair_rsa_1_.pem && ls -la ./"
                sh "rm ./ansible/aws___key_pair_rsa_1_.pem && ls -la ./ansible"
            }
        }
        stage('Ansible configuration ec2 instances') {
            steps {
                ansiblePlaybook credentialsId: '7c300873-afd0-4743-ad3e-4e36ddb3c3c0', disableHostKeyChecking: true, installation: 'ansible', inventory: './ansible/hosts', playbook: './ansible/main.yml', vaultTmpPath: ''
            }
        }
        stage('MOVE targetFile to workspace') {
            steps {
                dir("/tmp") {
                    fileOperations([fileCopyOperation(excludes: '', flattenFiles: true, includes: 'hello-1.0.war', targetLocation: "${WORKSPACE}")])
                    //sh "rm /tmp/hello-1.0.war"
                }
            }
        }
		stage('Build image') {
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
		stage('Stop/Pull/Run docker image') {
			steps {
				//sshagent(credentials : ['7c300873-afd0-4743-ad3e-4e36ddb3c3c0']) {
					//sh '''docker stop $(docker container ls | grep 8080 | awk '{print $1}' | head -1)'''
				//	sh 'docker pull gotofront/webapp:1.0 && docker run -d -p 80:8080 gotofront/webapp:1.0'
                //}
				//sh "IP_PROD=\$(awk '/\[PROD\]/{getline; print}' ./ansible/hosts)"
                //enviroment {
                //    IP_PROD = """${sh(grep -A1 '/\[PROD/\]' ./ansible/hosts | grep -v "/\[PROD/\]")}"""
                //}
                sh """
                IP_PROD = \$(grep -A1 '/[PROD/]' ./ansible/hosts | grep -v "/\[PROD/\]")
                """
                sh 'ssh ubuntu@$IP_PROD -i ./aws___key_pair_rsa_1_.pem "docker pull gotofront/webapp:1.0 && docker run -d -p 80:8080 gotofront/webapp:1.0"'
			}
		}       
    }
    
}
