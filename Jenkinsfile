pipeline {
    agent any
    parameters {
      booleanParam( name: 'ci_trigger', defaultValue: false, description: 'trigger ci' )
      choice (name: 'platform', choices: [ 'test' , 'dev' , 'demo'] , description: 'platform to install')
      string(name: 'token', defaultValue: 'c34355DDF3dc', description: 'api token')
      text(name: 'Code', defaultValue: '', description: '''version: 1.0
type: rs
retry: 3''')
    }
    environment {
      LOG_LEVEL = "TRACE"
      DEBUG = "true"
      COMMIT = """${sh(
                returnStdout: true,
                script: 'git rev-parse HEAD'
      )}"""
      SHORT = sh( returnStdout: true,
                script: 'git rev-parse HEAD | head -c 8')
    }
    stages {
        stage('env') {
          environment {
            LOG_LEVEL = "DEBUG"
            STEP = "env"
          }
          steps {
           script {
                currentBuild.description = "Build $GIT_BRANCH $SHORT"
            }
            echo "Running ${env.BUILD_ID} on ${env.JENKINS_URL}"
            echo "Running ${BUILD_ID} on ${JENKINS_URL}"
            echo "LOG_LEVEL=$LOG_LEVEL DEBUG=$DEBUG STEP=$STEP SHORT=$SHORT"
            sh '''
              echo "LOG_LEVEL=$LOG_LEVEL DEBUG=$DEBUG STEP=$STEP"
            '''
            sh '''
              echo "LOG_LEVEL=$LOG_LEVEL DEBUG=$DEBUG STEP=$STEP SHORT=$SHORT"
            '''
          }
        }
        stage('next') {
          environment {
            STEP = "next"
          }
          steps {
            echo "LOG_LEVEL=$LOG_LEVEL DEBUG=$DEBUG"
            sh '''
              echo "LOG_LEVEL=$LOG_LEVEL DEBUG=$DEBUG STEP=${STEP:-not def}"
            '''
            sh '''
              echo "LOG_LEVEL=$LOG_LEVEL DEBUG=$DEBUG STEP=${STEP:-not def}"
            '''
          }
        }
        stage('git env') {
            steps {
                sh '''
                   echo BUILD_ID $BUILD_ID
                   echo GIT_BRANCH ID $GIT_BRANCH
                   echo branch $(git rev-parse HEAD)
                '''
            }
        }
    }

}