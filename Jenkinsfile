#!/usr/bin/env groovy

pipeline {
    agent any
    environment {
        NEW_VERSION = '1.3'
    }

    tools{
        maven 'maven-3.9.0'
    }

    stages {
        // stage('Checkout') {
        //     steps {
        //         git branch: 'master', credentialsId: 'git-credentials', url: 'https://github.com/learnwithparth/springboot-jenkins.git'
        //     }
        // }
        stage('init'){
            steps{
                script{
                    gv = load "script.groovy"
                    //sh "git clone https://github.com/learnwithparth/springboot-jenkins.git"
                }
            }
        }
        stage('config'){
            steps{
                script{
                    gv.config()
                }
            }
        }
        stage('build') {
            
            steps {
                script{
                    echo 'building the application'
                    echo "Software version is ${NEW_VERSION}"
                    sh 'mvn build-helper:parse-version versions:set -DnewVersion=\\\${parsedVersion.majorVersion}.\\\${parsedVersion.nextMinorVersion}.\\\${parsedVersion.incrementalVersion}\\\${parsedVersion.qualifier?}' 
                    sh 'mvn clean package'
                    def version = (readFile('pom.xml') =~ '<version>(.+)</version>')[0][2]
                    env.IMAGE_NAME = "$version-$BUILD_NUMBER"
                    sh "docker build -t 20it116/exam:${IMAGE_NAME} ."
                    }
            }
        }
      stage('test') {
          when{  
             expression{
                 params.executeTest
             }
          }
            steps {
                script{echo 'testing the application...'
                sh 'mvn test'}
            }
        }
      stage('deploy') {
            steps {
                script{echo 'deploying the application...'
                withCredentials([usernamePassword(credentialsId: 'docker', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]){
                    sh "echo ${PASSWORD} | docker login -u ${USERNAME} --password-stdin"
                    sh "docker push 20it116/exam:${IMAGE_NAME}"
                }}

             }
        }
    }
    post{
        always{
            echo 'Executing always....'
        }
        success{
            echo 'Executing success'
        }
        failure{
            echo 'Executing failure'
        }
    }
}
