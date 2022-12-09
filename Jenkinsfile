pipeline {
    agent any
    parameters {
              booleanParam( name: 'ci_trigger', defaultValue: false, description: 'trigger ci' )
              choice (name: 'platform', choices: [ 'test' , 'dev' , 'demo'] , description: 'platform to install')
    }
    environment {
      LOG_LEVEL = "TRACE"
      DEBUG = "true"
    }
    stages {
        stage('env') {
          environment {
            LOG_LEVEL = "DEBUG"
            STEP = "env"
          }
          steps {
            echo "LOG_LEVEL=$LOG_LEVEL DEBUG=$DEBUG STEP=$STEP"
            sh '''
              echo "LOG_LEVEL=$LOG_LEVEL DEBUG=$DEBUG"
              echo 'LOG_LEVEL=$LOG_LEVEL DEBUG=$DEBUG'
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