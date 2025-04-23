pipeline {
    agent any

    environment {
        GCS_BUCKET = ' pre-prod-store'
        VM_HOST = '35.223.65.37' 
        VM_USER = 'pre-prod-stage'
        WAR_NAME = 'move-war-java.war'
    }

    stages {

        stage('Clone Repository') {
            steps {
                git url: 'https://github.com/BR2225/move-war-java.git'
            }
        }

        stage('Build WAR File') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Upload WAR to GCS Bucket') {
            steps {
                withCredentials([file(credentialsId: 'gcp-sa-json', variable: 'gcp-sa-json')]) {
                    sh '''
                        gcloud auth activate-service-account --key-file=$GC_KEY
                        gsutil cp target/${WAR_NAME} gs://${GCS_BUCKET}/${WAR_NAME}
                    '''
                }
            }
        }

        stage('Deploy to VM') {
            steps {
                sshagent(['vm-ssh-key']) {
                    sh """
                        scp target/${WAR_NAME} ${VM_USER}@${VM_HOST}:/tmp/
                        ssh ${VM_USER}@${VM_HOST} 'sudo mv /tmp/${WAR_NAME} /opt/tomcat/webapps/ && sudo systemctl restart tomcat'
                    """
                }
            }
        }
    }
}
