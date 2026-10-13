pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                echo 'Pipeline started successfully!'
                git branch: 'master',
                    url: 'https://github.com/pkhachane207/git-for-devops-workshop.git'
            }
        }

        stage('Build') {
            steps {
                echo 'Build stage completed!'
            }
        }

        stage('Test') {
            steps {
                echo 'Test stage completed!'
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check the console output.'
        }
    }
}
