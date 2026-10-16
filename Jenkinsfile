
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

        stage('Terraform Destroy Plan') {
            steps {
                dir("${TF_DIR}") {
                    sh '''
                        set -eu

                        terraform plan \
                            -destroy \
                            -input=false \
                            -no-color \
                            -out=tfplan

                        terraform show -no-color tfplan
                    '''
                }
            }
        }

        stage('Approval to Destroy') {
            steps {
                input message: 'WARNING: Review the destroy plan. Approve deletion of the planned AWS resources?',
                      ok: 'Destroy Infrastructure'
            }
        }

        stage('Terraform Destroy') {
            steps {
                dir("${TF_DIR}") {
                    sh 'terraform apply -input=false tfplan'
                }
            }
        }

        stage('Verify Destruction') {
            steps {
                dir("${TF_DIR}") {
                    sh '''
                        set -eu
                        terraform plan \
                            -destroy \
                            -input=false \
                            -no-color
                    '''
                }
            }
        }
    }

    post {
        success {
            echo 'Terraform destroy pipeline completed successfully!'
        }

        failure {
            echo 'Destroy pipeline failed. Review the console output and Terraform state.'
        }

        always {
            echo 'Infrastructure destroy pipeline execution finished.'
        }
    }
}
