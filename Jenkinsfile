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
        stage('Terraform') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: '8673bf69-dada-4325-b294-0380ba495d02',
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]) {
                    sh """
                    terraform -chdir='./terraform' init
                    terraform -chdir='./terraform' plan -var 'profile=user_1' -auto-approve terraform                  
                    """
                }
            }
        }        
    }
    
}