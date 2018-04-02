pipeline {
    agent {
        dockerfile true
    }
    parameters {
        string(name: 'TAG_NAME', defaultValue: 'v2017.1.5', description: 'Release tag on gluon git repository.')
        string(name: 'GLUON_RELEASE', defaultValue: '4.0.1', description: 'Firmware release number.')
        string(name: 'COMMUNITY', defaultValue: 'westerwald', description: 'Community name. Can be: westerwald, neuwied, altenkirchen or limburg')
        string(name: 'GLUON_BRANCH', defaultValue: 'stable', description: 'Gluon branch name. Can be: stable, beta, exprimental')
        string(name: 'GLUON_PRIORITY', defaultValue: '4', description: 'Defines the priority of an automatic update.')
    }
    stages {
        stage('Fetch sources') {
            steps {
                checkout poll: false, scm: [$class: 'GitSCM', branches: [[name: 'refs/tags/${TAG_NAME}']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/freifunk-gluon/gluon.git']]]
                checkout poll: false, scm: [$class: 'GitSCM', branches: [[name: 'refs/tags/${GLUON_RELEASE}']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: 'sites']], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/FreifunkWesterwald/sites.git']]]
            }
        }
        stage('Build gluon') {
            environment {
                GLUON_SITEDIR = '${WORKSPACE}/sites/${COMMUNITY}'
                GLUON_LANGS = 'de en'
                GLUON_REGION = 'eu'
                SECRETKEY_PAFFY = credentials('7f642a46-f47e-4038-bd9a-5bf8dbf3a4d6')
            }
            steps {
                sh 'make update'
                sh 'make GLUON_TARGET=ar71xx-generic V=s -j6'
                sh 'make GLUON_TARGET=ar71xx-tiny V=s -j6'
                sh 'make GLUON_TARGET=ar71xx-nand V=s -j6'
                sh 'make GLUON_TARGET=brcm2708-bcm2708 V=s -j6'
                sh 'make GLUON_TARGET=brcm2708-bcm2709 V=s -j6'
                sh 'make GLUON_TARGET=mpc85xx-generic V=s -j6'
                sh 'make GLUON_TARGET=x86-generic V=s -j6'
                sh 'make GLUON_TARGET=x86-64 V=s -j6'
                sh 'make manifest'
                sh 'contrib/sign.sh ${SECRETKEY_PAFFY} ${WORKSPACE}/output/images/sysupgrade/${GLUON_BRANCH}.manifest'
            }
        }
    }
}
