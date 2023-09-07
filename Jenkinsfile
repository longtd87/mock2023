pipeline {
    agent any
    environment{
        DOCKER_IMAGE = "longapp"
        AWS_DEFAULT_REGION = "us-east-1" 
        ECR_URL = "541253215789.dkr.ecr.us-east-1.amazonaws.com"
        ECR_REPO = "longtd27-mock"
        DOCKER_TAG="${GIT_BRANCH.tokenize('/').pop()}-${GIT_COMMIT.substring(0,7)}"
        
    }
    stages {
        stage("Build Image"){
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
                                credentialsId: 'test_key',
                                playbook: 'playbook_build.yml',
                                inventory: 'hosts',
                                become: 'yes',
                                extraVars: [
                                     DOCKER_IMAGE: "${DOCKER_IMAGE }",
                                     ECR_URL: "${ECR_URL }",
                                     ECR_REPO: "${ECR_REPO}",
                                     DOCKER_TAG: "${DOCKER_TAG}"
                                ]
                            )
                    }               
                
            }
        }     
 
        stage("Approve") {
            steps {
                script {
                    emailext (
                        subject: 'In Stage APPROVAL pipeline $JOB_NAME ',
                        body: ' Please checkout the pipeline $JOB_NAME $BUILD_URL TO APPROVE', 
                        to: 'longtd99@gmail.com',
                        from: 'web.secc@gmail.com'
                    )

                    def userInput = input(
                        id: 'auditorApproval',
                        message: 'Auditor approval required. Type "APPROVE" to continue:',
                        parameters: [string(name: 'userInput', defaultValue: '', description: '')]
                    )
                    
                    if (userInput == 'APPROVE') {
                        echo 'Auditor approved. Continuing with the pipeline...'
                    } else {
                        error 'Auditor did not approve. Pipeline aborted.'
                    }
                }
            }
        }

        stage("PUSH IMAGE TO ECR"){
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
                                playbook: 'playbook_push.yml',
                                inventory: 'hosts',
                                become: 'yes',
                                extraVars: [
                                     AWS_ACCESS_KEY_ID: "${AWS_ACCESS_KEY_ID}",  
                                     AWS_SECRET_ACCESS_KEY: "${AWS_SECRET_ACCESS_KEY}", 
                                     DOCKER_IMAGE: "${DOCKER_IMAGE }",
                                     AWS_DEFAULT_REGION: "${AWS_DEFAULT_REGION }",
                                     ECR_URL: "${ECR_URL}",
                                     ECR_REPO: "${ECR_REPO}",
                                     DOCKER_TAG: "${DOCKER_TAG}"
                                ]
                            )
                    }               
                
            }
        } 

        stage("DEPLOY APP TO EKS"){
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
                                playbook: 'playbook_deploy.yml',
                                inventory: 'hosts',
                                become: 'yes',
                                extraVars: [
                                     AWS_ACCESS_KEY_ID: "${AWS_ACCESS_KEY_ID}",  
                                     AWS_SECRET_ACCESS_KEY: "${AWS_SECRET_ACCESS_KEY}", 
                                     AWS_DEFAULT_REGION: "${AWS_DEFAULT_REGION }",
                                     ECR_URL: "${ECR_URL}",
                                     
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
