
pipeline {
    agent any

    options {
        timestamps()
        disableConcurrentBuilds()
        timeout(time: 45, unit: 'MINUTES')
        skipDefaultCheckout(true)
    }

    environment {
        TF_IN_AUTOMATION   = 'true'
        TF_INPUT           = 'false'
        TF_DIR             = '.'
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

        stage('Check Terraform Configuration') {
            steps {
                dir("${TF_DIR}") {
                    sh '''
                        set -eu

                        if ! find . -maxdepth 1 -type f -name '*.tf' \
                            -print -quit | grep -q .; then
                            echo "ERROR: No Terraform configuration files found."
                            exit 1
                        fi

                        echo "Terraform configuration files found."
                    '''
                }
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
                    sh 'terraform validate -no-color'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir("${TF_DIR}") {
                    sh '''
                        set -eu
                        terraform plan \
                            -input=false \
                            -no-color \
                            -out=tfplan
                        terraform show -no-color tfplan
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
                    sh 'terraform output -no-color'
                }
            }
        }
    }

    post {
        success {
            echo 'Infrastructure pipeline completed successfully!'
        }

        failure {
            echo 'Pipeline failed. Review the console output.'
        }

        always {
            echo 'Infrastructure pipeline execution finished.'
        }
    }
}
