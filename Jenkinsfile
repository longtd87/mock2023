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
               withCredentials([
                        string(credentialsId: 'aws-access-keys', variable: 'AWS_ACCESS_KEY_ID'),
                        string(credentialsId: 'aws-access-keys', variable: 'AWS_SECRET_ACCESS_KEY')
                    ]) {
                        sh "aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $ECR_REPO"
                        sh "docker tag $ECR_REPO/${DOCKER_IMAGE}:latest"
                        sh "docker push $ECR_REPO/${DOCKER_IMAGE}:latest"
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
