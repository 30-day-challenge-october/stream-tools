#!/usr/bin/env groovy

def maven = '/tools/maven/apache-maven-3.3.9/bin/mvn'
def MAVEN_BUILD = '/tools/maven/apache-maven-3.3.9'
def branchName
def deploymentEnvironment
def archetypeDir
def artifactVersion
def artifactId
def mavenPom
def buildNumber

pipeline {
    agent {
        label 'docker-maven-slave'
    }

    stages {
        stage ('Determine Environment') {
            steps {
                script {
                    branchName = env.BRANCH_NAME

                    echo "================================================================"
                    echo "Determining deployment environment for branch ${branchName} ..."
                    echo "================================================================"

                    if (branchName.equals("dev")) {
                        deploymentEnvironment = "test"
                    }

                    if (branchName.contains("innovation/")) {
                        deploymentEnvironment = "innovation"
                    }

                    if (branchName.contains("release/")) {
                        deploymentEnvironment = "stage"
                    }

                    echo "================================================================"
                    echo "deployment environment set to: ${deploymentEnvironment}"
                    echo "================================================================"
                }
            }
        }

        stage ('Set Version') {
            steps {
                dir(archetypeDir) {
                    sh 'pwd'
                    script {
                        sh 'pwd'
                        if (deploymentEnvironment.equals("dev")) {
                            echo "================================================================"
                            echo "In dev environment, using version in POM"
                            echo "================================================================"
                            artifactVersion = readMavenPom().getVersion()
                            echo "artifactVersion set to: ${artifactVersion}"
                        }

                        if (deploymentEnvironment.equals("innovation")) {
                            echo "================================================================"
                            echo "In innovation environment, Setting version to yy.ww.inv-SNAPSHOT"
                            echo "================================================================"
                            artifactVersion = readMavenPom().getVersion().substring(0, 5) + ".inv-SNAPSHOT"
                            echo "artifactVersion set to: ${artifactVersion}"
                        }

                        if (deploymentEnvironment.equals("stage")) {
                            echo "================================================================"
                            echo "In pdptest and higher environments, Setting version to yy.ww.bld#"
                            echo "================================================================"
                            artifactVersion = readMavenPom().getVersion().substring(0, 5) + "." + env.BUILD_ID
                            echo "artifactVersion set to: ${artifactVersion}"
                        }
                    }
                    withEnv(["PATH+MAVEN=$MAVEN_BUILD/bin"]) {
                        script {
                            sh "mvn versions:set -DnewVersion=${artifactVersion}"
                        }
                    }
                }
            }
        }

        stage ('Artifactory deploy') {
            steps {
                sh 'pwd'
                sh 'ls target/ | grep ${artifactVersion}.jar'
                script {
                    result = sh (script: "ls target/ | grep '${artifactVersion}.jar'", returnStdout: true)
                    echo "result: ${result}"
                    echo "================================================================"
                    echo 'Artifactory deploy stage'
                    echo "================================================================"
                }
                withEnv(["PATH+MAVEN=$MAVEN_BUILD/bin"]) {
                    configFileProvider(
                        [configFile(fileId: '<will provide jenkins settings.xml id here>', variable: 'SETTINGS')]) {
                            sh 'mvn -s $SETTINGS deploy'
                        }
                }
            }
        }
    }
}
