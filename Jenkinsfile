pipeline {
    agent any

    environment {
        GCS_BUCKET = 'pre-prod-store'
        GCS_FILE = 'pre-prod-store/test/original-jb-hello-world-maven-0.2.0.jar'
        LOCAL_FILE = 'original-jb-hello-world-maven-0.2.0.jar'
        VM_HOST = '35.223.65.37'
        VM_USER = 'pre-prod-stage'
    }

    stages {
        stage('Download from GCS') {
            steps {
                withCredentials([file(credentialsId: 'gcp-sa-json', variable: 'gcp-sa-json')]) {
                    sh '''
                        gcloud auth activate-service-account --key-file=%GC_KEY%
                        gsutil cp gs://%GCS_BUCKET%/%GCS_FILE% .\\%LOCAL_FILE%
                    '''
                }
            }
        }

        stage('Deploy to VM') {
            steps {
                sshagent(['vm-ssh-key']) {
                    sh '''
                       gcloud auth activate-service-account --key-file=%GC_KEY%
                        gcloud config set project citric-lead-457511-m7
                        gcloud compute scp %LOCAL_FILE% ${env.VM_USER}@${env.VM_HOST}:/tmp/ --zone=us-central1-c --quiet
                        gcloud compute ssh ${env.VM_USER}@${env.VM_HOST} --zone=us-central1-c --command="sudo mv /tmp/%LOCAL_FILE% /opt/tomcat/webapps/ && sudo systemctl restart tomcat" --quiet
                    '''
                }
            }
        }
    }
}
