def call(String pomPath = '.') {
    stage('Build Maven Project') {
        sh "mvn -f ${pomPath}/pom.xml clean install"
    }
}
