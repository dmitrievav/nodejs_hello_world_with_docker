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
                    sh 'cd /usr/src/app; npm test'
                }
            },
            node8: {
                withDockerContainer("dmitrievav/node-web-app:${env.BUILD_NUMBER}-node-8") {
                    sh 'cd /usr/src/app; npm test'
                }
            }
    }
}

stage('staging deployment') {
    timeout(time: 60, unit: 'SECONDS') {
        input(message: 'Would you like to deploy to staging?')
    }
    node('swarm') {
        sh 'for i in $(docker ps -a | grep node-web-app | awk "{print $1}"); do docker rm -f $i; done'
        sh "docker run -d -p 8881:8080 --name node-web-app-${env.BUILD_NUMBER}-node-7 dmitrievav/node-web-app:${env.BUILD_NUMBER}-node-7"
        sh "docker run -d -p 8882:8080 --name node-web-app-${env.BUILD_NUMBER}-node-8 dmitrievav/node-web-app:${env.BUILD_NUMBER}-node-8"
        sh 'sleep 5'
        sh 'echo deploy to staging completed'

    }
}

stage('staging QA') {
    node('swarm') {
        parallel node7: {
                sh 'curl -i  192.168.44.108:8881'
            },
            node8: {
                sh 'curl -i  192.168.44.108:8882'
            }
        input(message: 'debug')
        sh 'for i in $(docker ps -a | grep node-web-app | awk "{print $1}"); do docker rm -f $i; done'
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


