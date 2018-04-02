pipeline {
    agent {
        dockerfile true
    }
    stages {
        stage('Fetch Gluon') {
            steps {
                checkout poll: false, scm: [$class: 'GitSCM', branches: [[name: 'refs/tags/${TAG_NAME}']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/freifunk-gluon/gluon.git']]]
            }
        }
        stage('Fetch sites') {
            steps {
                checkout poll: false, scm: [$class: 'GitSCM', branches: [[name: 'refs/tags/${GLUON_RELEASE}']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: 'sites']], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/FreifunkWesterwald/sites.git']]]
            }
        }
   }
}
