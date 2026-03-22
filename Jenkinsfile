pipeline {
    agent any

    environment {
        DOCKER_HUB = "devopsawspratice"   // your DockerHub username
        APP_NAME   = "saran-app"
        BUILD_TAG  = "${BUILD_NUMBER}"
        IMAGE_NAME = "${DOCKER_HUB}/${APP_NAME}:${BUILD_TAG}"
    }

    stages {

        stage('Clone Code') {
            steps {
                git 'https://github.com/devopsawspratice/newkubernetis-html-css.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Login to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh 'echo $PASS | docker login -u $USER --password-stdin'
                }
            }
        }

        stage('Push Image') {
            steps {
                sh 'docker push $IMAGE_NAME'
            }
        }

        stage('Update Deployment Image') {
            steps {
                sh '''
                sed -i "s|image: .*|image: $IMAGE_NAME|g" deployment.yaml
                '''
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh 'kubectl apply -f deployment.yaml'
                sh 'kubectl apply -f service.yaml'
            }
        }
    }
}
