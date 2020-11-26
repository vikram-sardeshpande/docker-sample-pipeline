pipeline {
    agent any
    environment {
        containerName = "vikramsardeshpande/docker-sample-pipeline"
        container_version = "1.0.0.${BUILD_ID}"
        dockerTag = "${containerName}:${container_version}"
    }
    stages{
        
            stage('Cloning Git') {
                steps {
                    git 'https://github.com/vikram-sardeshpande/docker-sample-pipeline.git'
                }
            }
            
            stage ('Build Container') {
                steps {
                    sh 'docker build -f "Dockerfile" --no-cache -t ${dockerTag} .'
                
                  }
            }
            stage ('Deploy Container') {
                steps {
                    sh 'docker rm -f test'
                    sh 'docker run -it --name test -d -p 9000:80 ${dockerTag}'
                
                  }
            }
    }
    post {
        always {
            echo 'Clean up work directory'
            deleteDir() /* clean up our workspace */
        }
    }
}
