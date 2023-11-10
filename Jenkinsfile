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
                sh "touch ./terraform/hosts"
                //sh "chmod 400 ./aws___key_pair_rsa_1_.pem"
                sh "pwd && ls -la ./"
                sh "ls -la ./ansible"
                sh "cat ./ansible/hosts"
            }
        }
        stage('Terraform') {
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
            }
        }
    }
    
}
