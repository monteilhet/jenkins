pipeline {
    agent any
    parameters {
              booleanParam( name: 'ci_trigger', defaultValue: false, description: 'trigger ci' )
              choice (name: 'platform', choices: [ 'test' , 'dev' , 'demo'] , description: 'platform to install')
    }
    stages {
        stage('git env') {
            steps {
                sh '''
                   echo BUILD_ID $BUILD_ID
                   echo GIT_BRANCH ID $GIT_BRANCH
                   echo branch $(git rev-parse --abbrev-ref HEAD)
                '''
            }
        }
    }

}