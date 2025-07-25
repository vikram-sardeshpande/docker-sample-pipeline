  pipeline {
        agent any
        environment {
        containerName = "docker-persistentwebapp/tomcatwebapp"
        container_version = "3.0.0.${BUILD_ID}"
        dockerTag = "${containerName}:${container_version}"
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
            //    sh 'mvn clean package'
                   }
                  }
            } 
            stage('Quality Gate Check') {
            steps {
                waitForQualityGate abortPipeline: true 
            }
        }
                        stage('Upload Artifact to Nexus') {
                steps {
                    script {
                        withCredentials([usernamePassword(credentialsId: 'nexus', passwordVariable: 'NEXUS_PASSWORD', usernameVariable: 'NEXUS_USERNAME')]) {
                            nexusArtifactUploader(
                                nexusVersion: 'nexus3',
                                protocol: 'http', 
                                nexusUrl: 'localhost:8081', 
                                version: "${env.BUILD_ID}-${env.BUILD_TIMESTAMP}",
                                groupId: 'com.javatpoint',
                                repository: 'persistentwebapp',
                                credentialsId: 'nexus',
                                artifacts: [
                                    [artifactId: 'PersistentWebApp',
                                    classifier: '',
                                    file: 'target/PersistentWebApp.war', 
                                    type: 'war']
                                ]
                            )
                        }
                    }
                }
			}
        stage ('Build Container') {
            steps {
                sh 'docker build -f "Dockerfile" --no-cache -t ${dockerTag} .'
                //sh 'docker build -f "Dockerfile" -t ${dockerTag} .'
                  }
             }
  
  }
  }
