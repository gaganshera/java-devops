pipeline {
  agent any

  environment {
    scannerHome = tool 'SonarQubeScanner';
  }
  tools {
    dockerTool 'docker'
    maven 'Maven3'
  }
  options {
    timestamps()

    timeout(time: 1, unit: 'HOURS')

    buildDiscarder(logRotator(daysToKeepStr: '10', numToKeepStr: '20'))

    parallelsAlwaysFailFast()
  }

  stages {
    stage('Build') {
      steps {
        sh 'mvn clean install'
      }
    }
    stage('Unit Testing') {
      steps {
        sh 'mvn test'
      }
    }
    stage('Upload to Artifactory') {
      steps {
        rtMavenDeployer(
            id: 'deployer', serverId: '123456789@artifactory',
            releaseRepo: 'CI-Automation-JAVA', snapshotRepo: 'CI-Automation-JAVA'
        )
        rtMavenRun(
            pom: 'pom.xml', goals: 'clean install', deployerId: 'deployer'
        )
        rtPublishBuildInfo(
            serverId: '123456789@artifactory'
        )
      }
    }
    stage('Docker Image') {
      steps {
        sh 'docker build -t dtr.nagarro.com:443/i-gaganjotsingh02-master:${BUILD_NUMBER} --no-cache .'
      }
    }
    stage('Containers') {
        parallel {
            stage('PrecontainerCheck') {
              steps {
                  sh '''
                    CONTAINER_ID=$(docker ps -a | grep 6200 | cut -d " " -f 1)
                    if [ $CONTAINER_ID ]
                    then
                        docker rm -f $CONTAINER_ID
                    fi
                  '''
              }
            }
            stage('PushtoDTR') {
              steps {
                sh 'docker push dtr.nagarro.com:443/i-gaganjotsingh02-master:${BUILD_NUMBER}'
              }
            }
        }
    }
    stage('Docker deployment') {
      steps {
        sh 'docker run -d --name c-gaganjotsingh02-master -p 6200:8080 dtr.nagarro.com:443/i-gaganjotsingh02-master:${BUILD_NUMBER}'
      }
    }
    stage('Helm Chart Deployment') {
      steps {
        sh 'kubectl create ns nagp-gaganjotsingh02-master-${BUILD_NUMBER}'
        sh 'helm install nagp-gaganjotsingh02-java-deployment-master java-chart --set service.port=30157 --set image.tag=${BUILD_NUMBER} -n nagp-gaganjotsingh02-master-${BUILD_NUMBER}'
      }
    }
  }
}