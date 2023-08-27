pipeline {
    agent any
    environment{
        DOCKER_IMAGE = "longtd27/nginx"
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
                

                //clean to save disk
                sh "sudo docker image rm ${DOCKER_IMAGE}:${DOCKER_TAG}"
                sh "sudo docker image rm ${DOCKER_IMAGE}:latest"
            }
        }
       /* stage("Deploy"){
            options {
                timeout(time: 10, unit: 'MINUTES')
            }
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    ansiblePlaybook(
                        credentialsId: 'private_key',
                        playbook: 'playbook.yml',
                        inventory: 'hosts',
                        become: 'yes',
                        extraVars: [
                            DOCKER_USERNAME: "${DOCKER_USERNAME}",  
                            DOCKER_PASSWORD: "${DOCKER_PASSWORD}" 
                        ]
                    )
                }
                
            }
        }*/
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
