pipeline {
    agent {
        dockerfile {
            dir 'image'
        }
    }
    parameters {
        string(name: 'VERSION', defaultValue: 'v2017.1.5', description: 'Release tag on gluon git repository.')
        string(name: 'RELEASE', defaultValue: '4.0.2', description: 'Firmware release number.')
        string(name: 'COMMUNITY', defaultValue: 'westerwald', description: 'Community name. Can be: westerwald, neuwied, altenkirchen or limburg')
        string(name: 'BRANCH', defaultValue: 'stable', description: 'Gluon branch name. Can be: stable, beta, exprimental')
        string(name: 'PRIORITY', defaultValue: '4', description: 'Defines the priority of an automatic update.')
    }
    stages {
        stage('Fetch sources') {
            steps {
                checkout poll: false, scm: [$class: 'GitSCM', branches: [[name: "refs/tags/${params.VERSION}"]], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: 'gluon']], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/freifunk-gluon/gluon.git']]]
                checkout poll: false, scm: [$class: 'GitSCM', branches: [[name: "refs/tags/${params.RELEASE}"]], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: 'sites']], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/FreifunkWesterwald/sites.git']]]
            }
        }
        stage('Build gluon') {
            environment {
                GLUON_SITEDIR = "${WORKSPACE}/sites/${params.COMMUNITY}"
                GLUON_LANGS = 'de en'
                GLUON_REGION = 'eu'
                GLUON_RELEASE = "${params.RELEASE}"
                GLUON_BRANCH = "${params.BRANCH}"
                GLUON_PRIORITY = "${params.PRIORITY}"
            }
            steps {
                dir('gluon') {
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
                    withCredentials([file(credentialsId: '7f642a46-f47e-4038-bd9a-5bf8dbf3a4d6', variable: 'SECRETKEY')]) {
                        sh 'contrib/sign.sh ${SECRETKEY} output/images/sysupgrade/${GLUON_BRANCH}.manifest'
                    }
                    sh 'sha256sum output/images/sysupgrade/${GLUON_BRANCH}.manifest > output/images/sysupgrade/${GLUON_BRANCH}.manifest.sha256sum'
                }
            }
        }
        stage('Publish build') {
            environment {
                GLUON_BRANCH = "${params.BRANCH}"
            }
            steps {
                dir('gluon') {
                    sshPublisher(publishers: [sshPublisherDesc(configName: 'web.thepaffy.de:/opt/images', transfers: [sshTransfer(excludes: '', execCommand: '', execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: "${params.COMMUNITY}/testing", remoteDirectorySDF: false, removePrefix: 'output/images', sourceFiles: 'output/images/**/*')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false)])
                    archiveArtifacts "output/images/sysupgrade/${GLUON_BRANCH}.manifest.sha256sum"
                    fingerprint "output/images/sysupgrade/${GLUON_BRANCH}.manifest.sha256sum"
                }
            }
        }
        stage('Trigger E-Mail') {
            steps {
                emailext body: '''${JOB_NAME} - Build # ${BUILD_NUMBER} - "${currentBuild.result}":

Check console output at "${currentBuild.absoluteUrl}" to view the results.''', subject: '${JOB_NAME} - Build # ${BUILD_NUMBER} - "${currentBuild.result}"!', to: 'noc@freifunk-westerwald.de,mail@thepaffy.de'
            }
        }
    }
}
