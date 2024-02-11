pipeline {
    agent any

    stages {
        stage('Build Artifact') {
            steps {
                sh "mvn clean package -DskipTests=true"
                archive 'target/*.jar'
            }
        }

        stage('Unit Test') {
            steps {
                sh "mvn test"
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                    jacoco execPattern: 'target/jacoco.exec'
                }
            }
        }
        stage('Mutation Tests - PIT') {
          steps {
            sh "mvn org.pitest:pitest-maven:mutationCoverage"
          }
          post {
            always {
              pitmutation mutationStatsFile: '**/target/pit-reports/**/mutations.xml'
            }
          }
        }
        stage('SonarQube - SAST') {
          steps {
            mvn sonar:sonar -Dsonar.projectKey=numeric-application -Dsonar.host.url=http://devsecops-abbad.eastus.cloudapp.azure.com:9000 -Dsonar.login=a037c82688bda5d927a4911206692ffe9cd93bd9
          }
        }        
        stage('Docker Build and Push') {
            steps {
                script {
                    withDockerRegistry([credentialsId: "docker-hub", url: '']) {
                        sh 'printenv'
                        sh 'docker build -t abbadakn/numeric-app:""$GIT_COMMIT"" .'
                        sh 'docker push abbadakn/numeric-app:""$GIT_COMMIT""'
                    }
                }
            }
        }
        stage('Kubernetes Deployment - DEV') {
            steps {
                withKubeConfig([credentialsId: 'kubeconfig']) {
                    sh "sed -i 's#replace#abbadakn/numeric-app:${GIT_COMMIT}#g' k8s_deployment_service.yaml"
                    sh "kubectl apply -f k8s_deployment_service.yaml"
                }
            }
        }
	}
}
