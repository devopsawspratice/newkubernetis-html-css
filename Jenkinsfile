pipeline {
    agent any

    environment {
         GIT_REPO   = "https://github.com/devopsawspratice/newkubernetis-html-css.git"
        GIT_BRANCH  = "main"
        DOCKER_HUB = "devopsawspratice"   // your DockerHub username
        APP_NAME   = "saran-app"
        BUILD_TAG  = "${BUILD_NUMBER}"
        IMAGE_NAME = "${DOCKER_HUB}/${APP_NAME}:${BUILD_TAG}"
    }

    stages {

    stage('Checkout Code') {
            steps {
                git branch: "${GIT_BRANCH}", url: "${GIT_REPO}"
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
                sed -i "s|image: .*|image: $IMAGE_NAME|g" deployment.yml
                '''
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh 'kubectl apply -f deployment.yml'
                sh 'kubectl apply -f service.yml'
            }
        }
    }
}
