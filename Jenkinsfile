```groovy
pipeline {
    agent any

    options {
        timestamps()
        disableConcurrentBuilds()
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Check Terraform Installation') {
            steps {
                sh 'terraform version'
            }
        }

        stage('Terraform Format Check') {
            steps {
                sh 'terraform fmt -check -recursive'
            }
        }

        stage('Terraform Initialize') {
            steps {
                sh 'terraform init -backend=false'
            }
        }

        stage('Terraform Validate') {
            steps {
                sh 'terraform validate'
            }
        }
    }

    post {
        success {
            echo 'Terraform validation completed successfully!'
        }

        failure {
            echo 'Pipeline failed. Check Console Output.'
        }
    }
}
```
