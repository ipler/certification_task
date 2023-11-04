pipeline {
    agent any {
        stages {
            stage('Checkout') {
                steps {
                    git branch: 'main',
                    credentialsId: '4bae5d92-9ac0-4f06-8fb5-d1555d2c96ff',
                    url: 'https://github.com/ipler/certification_task.git'
                }
            }
        }
    }
}