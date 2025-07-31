 def call(String imageName, String registryUrl, String kubernetesNamespace) {
        echo "Pushing Docker image to registry: ${registryUrl}/${imageName}"
        sh "docker push ${registryUrl}/${imageName}"
