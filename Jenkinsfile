```groovy
pipeline {
    agent { label 'terraform-aws' }

    options {
        timestamps()
        disableConcurrentBuilds()
        timeout(time: 45, unit: 'MINUTES')
    }

    environment {
        TF_IN_AUTOMATION = 'true'
        TF_INPUT         = 'false'
        TF_DIR           = 'terraform'
        AWS_DEFAULT_REGION = 'us-east-1'
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out Terraform code from GitHub...'

                git branch: 'master',
                    url: 'https://github.com/pkhachane207/git-for-devops-workshop.git'
            }
        }

        stage('Tool Validation') {
            steps {
                sh '''
                    set -eu
                    terraform version
                    aws --version
                    aws sts get-caller-identity
                '''
            }
        }

        stage('Terraform Format') {
            steps {
                dir("${TF_DIR}") {
                    sh 'terraform fmt -check -recursive'
                }
            }
        }

        stage('Terraform Init') {
            steps {
                dir("${TF_DIR}") {
                    sh 'terraform init -input=false'
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                dir("${TF_DIR}") {
                    sh 'terraform validate'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir("${TF_DIR}") {
                    sh '''
                        terraform plan \
                            -input=false \
                            -out=tfplan
                    '''
                }
            }
        }

        stage('Approval') {
            steps {
                input message: 'Review the Terraform plan. Approve infrastructure changes?',
                      ok: 'Approve and Apply'
            }
        }

        stage('Terraform Apply') {
            steps {
                dir("${TF_DIR}") {
                    sh 'terraform apply -input=false tfplan'
                }
            }
        }

        stage('Verify Infrastructure') {
            steps {
                dir("${TF_DIR}") {
                    sh 'terraform output'
                }

                echo 'Terraform apply completed. Verify AWS resources and application health.'
            }
        }
    }

    post {
        success {
            echo 'Infrastructure pipeline completed successfully!'
        }

        failure {
            echo 'Pipeline failed. Review the Jenkins console output.'
        }

        always {
            echo 'Infrastructure pipeline execution finished.'
        }
    }
}
```
