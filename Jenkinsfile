pipeline {
    agent any
    environment {
        DOCKERHUB_USER = 'taibaton'
        IMAGE_NAME = "${DOCKERHUB_USER}/frontend"
        DOCKER_CREDS = 'dockerhub-credentials-id' 
        GIT_CREDS = 'github-pat-credentials-id'
    }

    stages {
        stage('Checkout') {
            steps {
                cleanWs()
                // Thay URL github của bạn vào đây
                git branch: 'main', credentialsId: 'github-pat-credentials-id', url: 'https://github.com/asbass/qlbh-web.git'
            }
        }
        
        stage('Build & Push Docker') {
            steps {
                script {
                    echo "--- Build Docker Image trực tiếp từ source ---"
                    // Docker sẽ tự copy toàn bộ file trong workspace vào Nginx
                    sh "docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} -t ${IMAGE_NAME}:latest ."
                    
                    echo "--- Push lên DockerHub ---"
                    withCredentials([usernamePassword(credentialsId: "${DOCKER_CREDS}", 
                                    passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                        sh "echo $PASS | docker login -u $USER --password-stdin"
                        sh "docker push ${IMAGE_NAME}:${BUILD_NUMBER}"
                        sh "docker push ${IMAGE_NAME}:latest"
                    }
                }
            }
        }

        stage('Update K8s') {
            steps {
                sshagent([GIT_CREDS]) {
                    sh '''
                        rm -rf k8s
                        git clone git@github.com:asbass/k8s.git
                        cd k8s
                        sed -i "s|image: ${DOCKERHUB_USER}/frontend:.*|image: ${IMAGE_NAME}:${BUILD_NUMBER}|g" frontend/deployment.yaml
                        git add frontend/deployment.yaml
                        git commit -m "Update frontend image ${BUILD_NUMBER}"
                        git push origin main
                    '''
                }
            }
        }
    }
    post {
        always {
            sh 'docker rmi ${IMAGE_NAME}:${BUILD_NUMBER} || true'
            cleanWs()
        }
    }
}
