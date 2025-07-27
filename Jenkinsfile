 pipeline {
        agent any
        environment {
        NEXUS_DOCKER_REPO = 'localhost:8082' 
        NEXUS_CREDS_ID = 'nexus' 
        IMAGE_NAME = 'persistentwebapp'
        dockertag = "${NEXUS_DOCKER_REPO}/${IMAGE_NAME}:${env.BUILD_NUMBER}"
        SNYK_TOKEN = credentials('snyk-api-token') 
        }
  stages{
            stage('Cloning Git') {

                steps {
                    git 'https://github.com/vikram-sardeshpande/docker-sample-pipeline.git'
                }
            }

            stage ('sonar scan') {
                steps {
                   withSonarQubeEnv('sonarqube') {
                sh 'mvn package sonar:sonar'
            //  sh 'mvn clean package'
                   }
                  }
            }
    //        stage('Quality Gate Check') {
      //      steps {
       //         waitForQualityGate abortPipeline: true
        //    }
    //    }
      //                  stage('Upload Artifact to Nexus') {
    //            steps {
      //              script {
        //                withCredentials([usernamePassword(credentialsId: 'nexus', passwordVariable: 'NEXUS_PASSWORD', usernameVariable: 'NEXUS_USERNAME')]) {
          //                  nexusArtifactUploader(
        //                        nexusVersion: 'nexus3',
         //                       protocol: 'http',
          //                      nexusUrl: 'localhost:8081',
        //                        version: "${env.BUILD_ID}-${env.BUILD_TIMESTAMP}",
          //                      groupId: 'com.javatpoint',
        //                        repository: 'persistentwebapp',
         //                       credentialsId: 'nexus',
          //                      artifacts: [
        //                            [artifactId: 'PersistentWebApp',
         //                           classifier: '',
          //                          file: 'target/PersistentWebApp.war',
        //                            type: 'war']
         //                       ]
          //                  )
        //                }
         //           }
          //      }
        //                }
        stage('Snyk Scan') {
    steps {
        script {
            try {
                sh 'snyk-linux auth $SNYK_TOKEN'
                sh "snyk-linux test --severity-threshold=high --fail-on=all > snyk-report.txt"
                archiveArtifacts artifacts: 'snyk-report.txt'
            } catch (Exception e) {
                archiveArtifacts artifacts: 'snyk-report.txt'
                echo "Snyk scan failed: ${e.getMessage()}"
                currentBuild.result = 'FAILURE' // Explicitly set build status to FAILURE
                error 'Build failed due to Snyk vulnerabilities.' // Stop the pipeline
            }
        }
    }
}
        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${NEXUS_DOCKER_REPO}/${IMAGE_NAME}:${env.BUILD_NUMBER} ."
                }
            }
        }
        
        stage('Trivy Security Scan') {
            steps {
                script {
                    echo "Running Trivy scan on ${NEXUS_DOCKER_REPO}/${IMAGE_NAME}:${env.BUILD_NUMBER}"

                    // Pulling the Trivy Docker image and scanning the specified Docker image
                    sh "trivy image --exit-code 0 --no-progress ${dockertag} > trivy-report.txt"                    
                    // Archiving the Trivy report in Jenkins
                    archiveArtifacts artifacts: 'trivy-report.txt'
                }
            }
        }
        stage('Docker Login to Nexus') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: NEXUS_CREDS_ID, usernameVariable: 'NEXUS_USER', passwordVariable: 'NEXUS_PASS')]) {
                        sh "docker login -u ${NEXUS_USER} -p ${NEXUS_PASS} ${NEXUS_DOCKER_REPO}"
                    }
                }
            }
        }
        

        stage('Push Docker Image to Nexus') {
            steps {
                script {
                    sh "docker push ${NEXUS_DOCKER_REPO}/${IMAGE_NAME}:${env.BUILD_NUMBER}"
                  //  sh 'docker push ${dockerTag}'
                }
            }
        }
        stage ('Deploy Container') {
                steps {
                    # Stop and remove existing container
                    echo "Attempting to stop and remove existing container..."
                    sh 'docker stop mywebapp || true'
                    sh 'docker rm -f mywebapp || true'
                    echo "Deploy new container"
                    sh 'docker run -it --name mywebapp -d -p 9090:8080 ${dockerTag}'
                    echo "New container deployed"

                  }
            }



  }
  }
