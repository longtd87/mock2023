pipeline {
    agent any
    environment{
        DOCKER_IMAGE = "longtd27/nginx"
        AWS_DEFAULT_REGION = "us-east-1"  // E.g., us-east-1
        ECR_REPO = "test"
        
    }
    stages {
        stage("Build"){
            options {
                timeout(time: 10, unit: 'MINUTES')
            }
            environment {
                DOCKER_TAG="${GIT_BRANCH.tokenize('/').pop()}-${GIT_COMMIT.substring(0,7)}"
            }
            steps {
                sh '''
                    sudo docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} . 
                    sudo docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest
                    sudo docker image ls | grep ${DOCKER_IMAGE}'''
                    
                withCredentials([usernamePassword(credentialsId: 'aws-secret-key', usernameVariable: 'AWS_ACESS_KEY_ID', passwordVariable: 'AWS_ACCESS_SECRET_KEY')]) {
                    sh "aws configure set aws_access_key_id $AWS_ACESS_KEY_ID"
                    sh "aws configure set aws_secret_access_key $AWS_ACCESS_SECRET_KEY"
                    sh "sudo aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $ECR_REPO"
                    sh "sudo docker tag $ECR_REPO/${DOCKER_IMAGE}:latest"
                    sh "sudo docker push $ECR_REPO/${DOCKER_IMAGE}:latest"
                }
                //clean to save disk
                //sh "sudo docker image rm ${DOCKER_IMAGE}:${DOCKER_TAG}"
                //sh "sudo docker image rm ${DOCKER_IMAGE}:latest"
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
