pipeline {
    agent any
    environment{
        DOCKER_IMAGE = "webapp"
        AWS_DEFAULT_REGION = "us-east-1" 
        ECR_URL = "541253215789.dkr.ecr.us-east-1.amazonaws.com"
        ECR_REPO = "longtd27-mock"
        //AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        //AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        DOCKER_TAG="${GIT_BRANCH.tokenize('/').pop()}-${GIT_COMMIT.substring(0,7)}"
    }
    stages {
        stage("Build Image"){
            options {
                timeout(time: 10, unit: 'MINUTES')
            }
            /*environment {
                //DOCKER_TAG="${GIT_BRANCH.tokenize('/').pop()}-${GIT_COMMIT.substring(0,7)}"
            }*/
            steps {                     
                    sh '''
                        docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} . 
                        docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${ECR_URL}/${ECR_REPO}:${DOCKER_IMAGE}_latest
                        docker image ls | grep ${DOCKER_IMAGE}              
                    '''
                    }               
                
            }     
 
        stage("Approve") {
            steps {
                script {
                    emailext {
                            subject: 'In Stage Approve',
                            body: ' PLEASE checkout $BUILD_URL to APPROVE PIPELINE TO CONTINUE' 
                            recipientProviders: [$class: 'CulpritsRecipientProvider'],
                            to: 'longtd99@gmail.com',
                            from: 'web.secc@gmail.com'
                    }
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

        stage("Push Image to ECR"){
            options {
                timeout(time: 10, unit: 'MINUTES')
            }
            steps {    
                    
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws_credentails_key',
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]) {
                        sh '''           
                            aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
                            aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
                            aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $ECR_URL
                            docker push ${ECR_URL}/${ECR_REPO}:${DOCKER_IMAGE}_latest
                        '''
                        }                              
                //clean to save disk
                sh "docker image rm ${DOCKER_IMAGE}:${DOCKER_TAG}"
                sh "docker image rm ${ECR_URL}/${ECR_REPO}:${DOCKER_IMAGE}_latest"
                
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
