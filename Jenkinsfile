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
    }
    tools {
        terraform 'terraform-162'
    }
    stages {
        stage ('Terraform Init') {
            steps {
                sh 'terraform init ./terraform'
                sh 'terraform plan ./terraform'
            }
        }
    }
}