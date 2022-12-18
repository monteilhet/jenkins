pipeline {
    agent any
    parameters {
      gitParameter( branchFilter: 'origin/(.*)', defaultValue: 'default', name: 'ref', type: 'PT_TAG')
    }
    environment {
        COMMIT = sh(script: 'git rev-parse HEAD', returnStdout: true)
        SHORT = sh(script: 'git rev-parse HEAD | head -c 8', returnStdout: true)
    }
    stages {
      stage('git tag')
      {
            steps {
                sh '''
                  if [[ $ref != default ]] ; then
                    git checkout $ref
                    git rev-parse HEAD
                  fi
                '''
            }
      }
      stage('build') {
        environment {
            PATH = "${env.PATH}:/usr/local/go/bin"
        }
        steps {
            sh '''
                printenv
                echo "PATH is $PATH GIT_BRANCH $GIT_BRANCH"
                REF=1 ./deliver_tag.sh
            '''
        }
      }
    }
}