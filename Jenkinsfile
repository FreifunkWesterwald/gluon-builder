pipeline {
    agent {
        dockerfile true
    }
    stages {
        stage('Fetch sources') {
            steps {
                checkout poll: false, scm: [$class: 'GitSCM', branches: [[name: 'refs/tags/${TAG_NAME}']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/freifunk-gluon/gluon.git']]]
                checkout poll: false, scm: [$class: 'GitSCM', branches: [[name: 'refs/tags/${GLUON_RELEASE}']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: 'sites']], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/FreifunkWesterwald/sites.git']]]
            }
        }
        stage('Build gluon for Westerwald') {
            environment {
                GLUON_SITEDIR = "${WORKSPACE}/sites/westerwald"
            }
            steps {
                echo "${env.GLUON_SITEDIR}"
            }
        }
    }
}
