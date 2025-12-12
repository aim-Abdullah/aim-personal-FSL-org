#!groovy
import groovy.json.JsonSlurperClassic
node {

    def BUILD_NUMBER=env.BUILD_NUMBER
    def RUN_ARTIFACT_DIR="tests/${BUILD_NUMBER}"
    def SFDC_USERNAME

    def HUB_ORG=env.HUB_ORG_DH
    def SFDC_HOST = env.SFDC_HOST_DH
    def JWT_KEY_CRED_ID = env.JWT_CRED_ID_DH
    def CONNECTED_APP_CONSUMER_KEY=env.CONNECTED_APP_CONSUMER_KEY_DH

    println 'KEY IS' 
    println JWT_KEY_CRED_ID
    println HUB_ORG
    println SFDC_HOST
    println CONNECTED_APP_CONSUMER_KEY
    def toolbelt = tool 'toolbelt'

    stage('checkout source') {
        // when running in multi-branch job, one must issue this command
        checkout scm
    }

    withCredentials([file(credentialsId: JWT_KEY_CRED_ID, variable: 'jwt_key_file')]) {
        stage('Deploy Code') {
            def rc
            if (isUnix()) {
                // SFDX: auth:jwt:grant --> SF: org:login:jwt
                rc = sh returnStatus: true, script: "${toolbelt} org login jwt --client-id ${CONNECTED_APP_CONSUMER_KEY} --username ${HUB_ORG} --jwt-key-file ${jwt_key_file} --set-default-dev-hub --instance-url ${SFDC_HOST}"
            }else{
                //bat "${toolbelt} plugins:install salesforcedx@49.5.0"
                //bat "${toolbelt} update"
                //bat "${toolbelt} auth:logout -u ${HUB_ORG} -p" 
                // SFDX: auth:jwt:grant --> SF: org:login:jwt
                rc = bat returnStatus: true, script: "${toolbelt} org login jwt --client-id ${CONNECTED_APP_CONSUMER_KEY} --username ${HUB_ORG} --jwt-key-file ${jwt_key_file} --set-default-dev-hub --instance-url ${SFDC_HOST}"
            }
        
            if (rc != 0) { 
                println 'inside rc 0'
                error 'hub org authorization failed' 
            }
            else{
                println 'rc not 0'
            }

            println rc
            
            // need to pull out assigned username
            def rmsg
            if (isUnix()) {
                // SFDX: force:source:deploy --> SF: project:deploy:start
                rmsg = sh returnStdout: true, script: "${toolbelt} project deploy start --manifest manifest/package.xml --target-org ${HUB_ORG}"
            }else{
                // SFDX: force:source:deploy --> SF: project:deploy:start
                rmsg = bat returnStdout: true, script: "${toolbelt} project deploy start --manifest manifest/package.xml --target-org ${HUB_ORG}"
            }
              
            // error - old sfdx printf rmsg
            println('Hello from a Job DSL script!')
            println(rmsg)
        }
    }
}
