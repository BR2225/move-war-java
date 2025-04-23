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
                    bat '''
                        gcloud auth activate-service-account --key-file=%GC_KEY%
                        gsutil cp gs://%GCS_BUCKET%/%GCS_FILE% .\\%LOCAL_FILE%
                    '''
                }
            }
        }

        stage('Deploy to VM') {
            steps {
                sshagent(['vm-ssh-key']) {
                    bat """
                       gcloud auth activate-service-account --key-file=%GC_KEY%
                        gcloud config set project your-gcp-project-id
                        gcloud compute scp %LOCAL_FILE% ${env.VM_USER}@${env.VM_HOST}:/tmp/ --zone=your-vm-zone --quiet
                        gcloud compute ssh ${env.VM_USER}@${env.VM_HOST} --zone=your-vm-zone --command="sudo mv /tmp/%LOCAL_FILE% /opt/tomcat/webapps/ && sudo systemctl restart tomcat" --quiet
                    """
                }
            }
        }
    }
}
