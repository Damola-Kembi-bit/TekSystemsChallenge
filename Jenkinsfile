pipeline{
    agent any
    tools{
        jdk 'jdk17'
        nodejs 'node16'
    }
    environment {
        SCANNER_HOME=tool 'sonar-scanner'
    }
    stages {
        stage('clean workspace'){
            steps{
                cleanWs()
            }
        }
        stage('Checkout from Git'){
            steps{
                git branch: 'main', url: 'https://github.com/Damola-Kembi-bit/Netflix-clone.git'
            }
        }
        stage("Sonarqube Analysis "){
            steps{
                // Runs the sonarqube analysis using sonar plugin for SAST and code quality
                withSonarQubeEnv('sonar-server') {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=DevSec-Netflix-Clone \
                    -Dsonar.projectKey=DevSec-Netflix-Clone '''
                }
            }
        }
        stage("quality gate"){
            steps {
                timeout(time: 3, unit: 'MINUTES'){
                    script {
                       waitForQualityGate abortPipeline: false, credentialsId: 'Sonar-token'
                    }
                }
            } 
        }
        stage('Install Dependencies') {
            steps {
                sh "npm install"
            }
        }
        
        stage('OWASP FS SCAN') {
            steps {
                // Runs OWASP Dependency Check using dependencyCcheck plugin
                dependencyCheck additionalArguments: '--scan ./ --disableYarnAudit --disableNodeAudit', odcInstallation: 'DP-Check'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }
        stage('TRIVY FS SCAN') {
            steps {
                // Runs trivy scan on the directory to find vulnerabilities
                sh "trivy fs . > trivyfs.txt"
            }
        }
        
        stage("Docker Build & Push"){
            steps{
                // Builds and pushes the docker image to prvate docker hub
                script{
                   withDockerRegistry(credentialsId: 'docker', toolName: 'docker', url: "https://index.docker.io/v1/"){   
                       sh "docker build --build-arg TMDB_V3_API_KEY=3aa8b3d85a965f2afcd051aba6981fd6 -t netflix ."
                       sh "docker tag netflix damolak/netflix:latest "
                       sh "docker push damolak/netflix:latest "
                    }
                }
            }
        }
        stage("TRIVY"){
            steps{
                // Runs trivy to scan docker image for vulnerabilities
                sh "trivy image damolak/netflix:latest > trivyimage.txt" 
            }
        }

      stage('Install Ansible') {
            steps {
                 sh "sudo apt-get update"
                 sh "sudo apt-get install -y ansible"
            }
        }

      stage('Ansible Hardening') {
            steps {
                // Uses ansiblePlaybook plugin to harden target ec2 instance.
                ansiblePlaybook(
                    playbook: './ansible-hardening.yml',
                    inventory: './inventory.ini'
                )
            }
        }
        
        stage('Deploy to container'){
            steps{
                sh 'docker run -d --name netflix -p 8081:80 damolak/netflix:latest'
            }
        }
        
    }
    post {
     always {
        emailext attachLog: true,
            subject: "'${currentBuild.result}'",
            body: "Project: ${env.JOB_NAME}<br/>" +
                "Build Number: ${env.BUILD_NUMBER}<br/>" +
                "URL: ${env.BUILD_URL}<br/>",
            to: 'damola.kembi@outlook.com',
            attachmentsPattern: 'trivyfs.txt,trivyimage.txt'
        }
    }
}
