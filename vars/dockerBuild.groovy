def call(String imageName, String dockerfilePath = '.') {
    stage('Build Docker Image') {
        sh "docker build -t ${imageName} ${dockerfilePath}"
    }
}
