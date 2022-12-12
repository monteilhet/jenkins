pipeline {
    agent any
    parameters {
      gitParameter( branchFilter: 'origin/(.*)', defaultValue: 'default', name: 'ref', type: 'PT_TAG')
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
              echo "trigger=${ci_trigger}"
              # echo "SHORT=${env.SHORT} ci trigger=${params.ci_trigger}" # cannot use groovy syntax in ''
            '''
            sh """
              echo "LOG_LEVEL=$LOG_LEVEL DEBUG=$DEBUG STEP=$STEP SHORT=$SHORT SHORT=${env.SHORT}"
              echo "SHORT=${env.SHORT} ci trigger=${params.ci_trigger}"
              # comment is ok and can use groovy syntax in double quote sh, jenkins expand variable before shell execution
            """
          }  // sh is not bash !
        }
        stage('next') {
          environment {
            STEP = "next"
            PATH = "${env.PATH}:/usr/local/bin/go"
          }
          steps {
            echo "LOG_LEVEL=$LOG_LEVEL DEBUG=$DEBUG"
            sh '''
              echo 'single quote'
              echo "LOG_LEVEL=$LOG_LEVEL DEBUG=$DEBUG STEP=${STEP:-not def} BREAK=${DEF:-default}"
              [ -z $TEST ] && echo TEST not def || echo TEST is defined $TEST
              # [[ $ci_trigger == true ]] && echo trigger CI  ### single quote shell does not support [[
              export TEST=1
              [ -z $TEST ] && echo no def || echo TEST exists $TEST
            '''
            sh """
              echo 'double quote'
              echo "LOG_LEVEL=$LOG_LEVEL DEBUG=$DEBUG BREAK=${env.DEF}"
              [[ $ci_trigger == true ]] && echo trigger CI || echo no trigger
            """
            sh 'printenv'
          } //  """ does not support BREAK=${DEF:-default}, NB jenkins expand var before shell execution
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
            }
        }
        stage('setenv') {
            steps {
                script { // set global variable
                  env.NEW = sh( returnStdout: true,
                  script: 'echo 1.x')
                }
                sh 'export NEW=1.0 ; echo ${NEW}'
                sh 'echo ${NEW:-nodef}'
                sh 'echo $SHELL ; bash --version'
                // sh 'if [[ $NEW == 1.x ]] ; then  echo ok $NEW ; else echo invalid ; fi'
            }
        }
        stage('test') {
          steps {
             script{  // test another way to set variable usabe in shell
                def variable = true
                sh """
                echo ${variable}
                echo NEW $NEW
                """
                // sh 'echo ${variable}'
            }
          }
        }
        // stage creds SERVICE_CREDS = credentials('my-predefined-username-password')
        stage('Test Git param')
        {
            steps {
                echo "ref ${params.ref}"
                sh 'printenv'
            }
        }

    }

}
