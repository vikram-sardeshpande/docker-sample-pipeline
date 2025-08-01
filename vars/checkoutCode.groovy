def call(String repoUrl, String branch = 'master') {
    stage('Checkout from GitHub') {
        checkout([
            $class: 'GitSCM',
            branches: [[name: "*/${branch}"]],
            userRemoteConfigs: [[url: repoUrl]]
        ])
    }
}
