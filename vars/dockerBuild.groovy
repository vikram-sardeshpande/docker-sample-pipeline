def call(String imageName, String dockerfilePath = '.') {
        echo "Building Docker image: ${imageName}"
        sh "docker build -t ${imageName} ${dockerfilePath}"
    }
