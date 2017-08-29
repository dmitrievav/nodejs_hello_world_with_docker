#!groovy

properties(
    [
        [
            $class: 'BuildDiscarderProperty',
            strategy: [$class: 'LogRotator', numToKeepStr: '10']
        ],
        pipelineTriggers([cron('H/1 * * * *')]),
    ]
)

stage('build') {
    node('swarm') {
        checkout scm
        sh 'hostname; pwd; ls -laFh; env'
        sh 'git branch; git status; git log --pretty=format:\"%h %ad | %s%d [%an]\" --graph --date=short --all | head'

        parallel node7: {
                sh './build.sh 7'
            },
            node8: {
                sh './build.sh 8'
            }
    }
}

stage('test') {
    node('swarm') {
        parallel node7: {
                withDockerContainer("dmitrievav/node-web-app:${env.BUILD_NUMBER}-node-7") {
                    sh 'hostname; pwd; ls -laFh; ps axwwf'
                    sh 'curl -i 127.0.0.1:8080'
                }
            },
            node8: {
                withDockerContainer("dmitrievav/node-web-app:${env.BUILD_NUMBER}-node-8") {
                    sh 'hostname; pwd; ls -laFh; ps axwwf'
                    sh 'curl -i 127.0.0.1:8080'
                }
            }
    }
}

stage('staging deployment') {
    timeout(time: 60, unit: 'SECONDS') {
        input(message: 'Would you like to deploy to staging?')
    }
    node('swarm') {
        sh 'echo deploy to staging completed'
    }
}

stage('staging QA') {
    node('swarm') {
        sh 'echo QA staging completed'
    }
}

stage('LIVE deployment') {
    timeout(time: 60, unit: 'SECONDS') {
        input(message: 'Would you like to deploy to LIVE?')
    }
    node('swarm') {
        sh 'echo deploy to live completed'
    }
}

stage('LIVE QA') {
    node('swarm') {
        sh 'echo QA LIVE completed'
    }
}


