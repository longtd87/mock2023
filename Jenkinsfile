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
                withCredentials([awsCredentials(credentialsId: 'aws-access-keys', variable: 'AWS_CREDENTIALS')])
                {
                    sh '''
                        echo \${AWS_CREDENTIALS} | base64 --decode | awk -F: '{print $2}' | tr -d '\n' | docker login --username AWS --password-stdin https://${ECR_REPO}
                        docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${ECR_REPO}/${DOCKER_IMAGE}:${DOCKER_TAG}
                        docker tag ${DOCKER_IMAGE}:latest ${ECR_REPO}/${DOCKER_IMAGE}:latest
                        docker push ${ECR_REPO}/${DOCKER_IMAGE}:${DOCKER_TAG}
                        docker push ${ECR_REPO}/${DOCKER_IMAGE}:latest '''
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
