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
            // NB using agent any minimal shell does not support [ operator
            // script {
            //     env.EGIT_BRANCH = sh( returnStdout: true, script: 'if [ "$ref" != default ] ; then echo "tags/$ref" ; else echo ${GIT_BRANCH#refs/} ; fi' ) 
            //     env.EREF = sh( returnStdout: true, script: 'if [ "$ref" == default ] ; then echo $EGIT_BRANCH ; else echo "tags/$ref" ; fi' ) 
            //     env.BUILD_MSG = sh( returnStdout: true, script: 'if [ "$ref" == default ] ; then echo -n " automatically triggered by " ; else echo -n " manually" ; fi')
            //     currentBuild.description = "BUILD_REF: build $BUILD_MSG using $GIT_BRANCH $SHORT"
            // }
            //  alternative use test condition in groovy
              script {
              if ( params.ref == "default") {
                env.EGIT_BRANCH = sh( returnStdout: true, script: 'echo ${GIT_BRANCH#refs/}' ) 
                env.EREF = env.EGIT_BRANCH
                currentBuild.description = "BUILD_REF: build automatically triggered using $GIT_BRANCH $SHORT"
              }
              else
              {
                env.EGIT_BRANCH = sh( returnStdout: true, script: 'echo "tags/$ref"' )
                env.EREF = env.EGIT_BRANCH
                currentBuild.description = "BUILD_REF: build manually triggered using $GIT_BRANCH $SHORT"
              }
              }
            sh '''
                printenv
                echo "PATH is $PATH GIT_BRANCH $EGIT_BRANCH REF=$EREF"
                REF=$EREF ./deliver.sh
            '''
        }
      }
    }
}