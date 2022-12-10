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
      JOB_NAME = "demo"
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
            echo "Params ${params.ci_trigger} ${params.platform} $ci_trigger $platform"
            echo "Env LOG_LEVEL=$LOG_LEVEL DEBUG=$DEBUG STEP=$STEP SHORT=${env.SHORT}"
            sh '''
              echo "LOG_LEVEL=$LOG_LEVEL DEBUG=$DEBUG STEP=$STEP SHORT=$SHORT"
            '''
            sh """
              echo "LOG_LEVEL=$LOG_LEVEL DEBUG=$DEBUG STEP=$STEP SHORT=$SHORT SHORT=${env.SHORT}"
            """
          }  // sh not bash
        }
        stage('next') {
          environment {
            STEP = "next"
          }
          steps {
            echo "LOG_LEVEL=$LOG_LEVEL DEBUG=$DEBUG"
            sh '''
              echo 'single quote'
              [ -z TEST ] && echo TEST not def || echo TEST is defined $TEST

              echo "LOG_LEVEL=$LOG_LEVEL DEBUG=$DEBUG STEP=${STEP:-not def} BREAK=${DEF:-default}"
            '''
            sh """
              echo 'double quote'
              [ -z TEST ] && echo TEST not def || echo TEST is defined
              [ -z DEF ] && echo no def || echo def exists
              export DEF=1
              echo "LOG_LEVEL=$LOG_LEVEL DEBUG=$DEBUG BREAK=${env.DEF}"
            """
          } //  """ does not support BREAK=${DEF:-default}, expand var before shell execution
        }
        stage('git env') {
            when {
                expression { return params.ci_trigger }
            }
            steps {
                sh '''
                   echo BUILD_ID $BUILD_ID
                   echo GIT_BRANCH ID $GIT_BRANCH
                   echo branch $(git rev-parse HEAD)
                '''
            }
        }
        stage('Example Username/Password') {
            environment {
                SERVICE_CREDS = credentials('artifactory')
            }
            steps {
                sh 'echo "Service user is $SERVICE_CREDS_USR"'
                sh 'echo "Service password is $SERVICE_CREDS_PSW"'
                sh 'echo curl -u $SERVICE_CREDS https://myservice.example.com'
                sh 'pwd'
                sh 'echo $SERVICE_CREDS > creds'
                sh 'cat creds'
            }
        }
        // stage creds SERVICE_CREDS = credentials('my-predefined-username-password')
    }

}