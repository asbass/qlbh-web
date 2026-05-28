pipeline {
    agent any
    // Chúng ta cần Node.js để build AngularJS
    tools {
        nodejs 'Node-18' // Hãy chắc chắn bạn đã cài "NodeJS Plugin" và đặt tên này trong Global Tool Config
    }
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
                git branch: 'main', credentialsId: 'github-pat-credentials-id', url: 'https://github.com/asbass/qlbh-web.git'
            }
        }
        
        stage('Build Frontend & Docker') {
            steps {
                script {
                    echo "--- Cài đặt thư viện Node ---"
                    sh 'npm install'
                    
                    echo "--- Build code AngularJS (tạo thư mục dist) ---"
                    sh 'npm run build' // Đảm bảo trong package.json của bạn có script này
                    
                    echo "--- Build Docker Image ---"
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

        stage('Update K8s Repo (GitOps)') {
            steps {
                sshagent([GIT_CREDS]) {
                    sh '''
                        rm -rf k8s
                        git clone git@github.com:asbass/k8s.git
                        cd k8s
                        sed -i "s|image: ${DOCKERHUB_USER}/frontend:.*|image: ${IMAGE_NAME}:${BUILD_NUMBER}|g" frontend/deployment.yaml
                        git config user.email "jenkins@jenkins.com"
                        git config user.name "Jenkins"
                        git add frontend/deployment.yaml
                        git commit -m "Update frontend image to ${BUILD_NUMBER}"
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