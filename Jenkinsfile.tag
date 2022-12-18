pipeline {
    agent any
    triggers {
        pollSCM('*/2 * * * *')
    }
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
                  echo ref=$ref
                  if [ $ref != default ] ; then
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
           // 'if [ "$ref" != default ] ; then echo "tags/$ref" ; else echo ${GIT_BRANCH#refs/} ; fi' 
            script {
                env.NREF = sh( returnStdout: true, script: 'echo "tags/$ref"' ) 
                env.BUILD_MSG = sh( returnStdout: true, script: 'test $ref == default && echo -n " automatically triggered by " || echo -n ""')
                currentBuild.description = "BUILD_REF: build $BUILD_MSG using $GIT_BRANCH $SHORT"
            }
            sh '''
                printenv
                echo "PATH is $PATH GIT_BRANCH $GIT_BRANCH REF=$NREF"
                REF=$NREF ./deliver.sh
            '''
        }
      }
    }
}