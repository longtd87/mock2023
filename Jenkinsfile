pipeline {
    agent any
    environment{
        DOCKER_IMAGE = "webapp"
        AWS_DEFAULT_REGION = "us-east-1" 
        ECR_URL = "541253215789.dkr.ecr.us-east-1.amazonaws.com"
        ECR_REPO = "longtd27-mock"
        DOCKER_TAG="${GIT_BRANCH.tokenize('/').pop()}-${GIT_COMMIT.substring(0,7)}"
        
    }
    stages {     
        stage("BUILD AND PUSH IMAGE TO ECR"){
            options {
                timeout(time: 5, unit: 'MINUTES')
            }
            steps {                     
                    withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws_credentails_key',
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                    ]]) {
                            ansiblePlaybook(
                                credentialsId: 'private_key',
                                playbook: 'playbook.yml',
                                inventory: 'hosts',
                                become: 'yes',
                                extraVars: [
                                     AWS_ACCESS_KEY_ID: "${AWS_ACCESS_KEY_ID}",  
                                     AWS_SECRET_ACCESS_KEY: "${AWS_SECRET_ACCESS_KEY}", 
                                     DOCKER_IMAGE: "${DOCKER_IMAGE }",
                                     AWS_DEFAULT_REGION: "${AWS_DEFAULT_REGION }",
                                     ECR_URL: "${ECR_URL }",
                                     ECR_REPO: "${ECR_REPO}",
                                     DOCKER_TAG: "${DOCKER_TAG}"
                                ]
                            )
                    }               
                
            }
        }                  
            
    }
    post {
        success {
            echo "SUCCESSFULL"
        }
        failure {
            echo "FAILED"
        }
    }
}
