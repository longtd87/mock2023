pipeline {
    agent any
    environment{
        DOCKER_IMAGE = "webapp"
        AWS_DEFAULT_REGION = "us-east-1" 
        ECR_URL = "541253215789.dkr.ecr.us-east-1.amazonaws.com"
        ECR_REPO = "longtd27-mock"
        //AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        //AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        
    }
    stages {
        stage("Build and Push image to ECR"){
            options {
                timeout(time: 10, unit: 'MINUTES')
            }
            environment {
                DOCKER_TAG="${GIT_BRANCH.tokenize('/').pop()}-${GIT_COMMIT.substring(0,7)}"
            }
            steps {
                script {
                       def awsAccessKeyId = credentials('AWS_ACCESS_KEY_ID')
                       def awsSecretAccessKey = credentials('AWS_SECRET_ACCESS_KEY')
        
                       
                       sh '''
                            docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} . 
                            docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${ECR_URL}/${ECR_REPO}:${DOCKER_IMAGE}_latest
                            docker image ls | grep ${DOCKER_IMAGE}            
                            aws configure set aws_access_key_id $awsAccessKeyId
                            aws configure set aws_secret_access_key $awsSecretAccessKey
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
