#!/bin/bash

#global variables
PROJECT_NAME=
COMPONENT_NAME=
VERSION=
REPO=

while getopts p:c:v: option
    do
        case "${option}"
            in
                p) PROJECT_NAME=${OPTARG};;
                c) COMPONENT_NAME=${OPTARG};;
                v) VERSION=${OPTARG};;
        esac
done

if [ -z $PROJECT_NAME ]
    then
        printf "\nERROR: Must pass a -p project name argument\n\n"
        exit
fi

if [ -z $COMPONENT_NAME ]
    then
        printf "\nERROR: Must pass a -c component name argument\n\n"
        exit
fi

if [ -z $VERSION ]
    then
        printf "\nERROR: Must pass a -v version argument\n\n"
        exit
fi

cd $HOME
mkdir new_spark_projects
cd new_spark_projects
#REPO=git@github.optum.com:EnterpriseProviderPlatform/$PROJECT_NAME.git
git clone git@github.optum.com:EnterpriseProviderPlatform/$PROJECT_NAME.git
#
# #Create the Optumfile
# cat > ./Optumfile.yml << EOF
# apiVersion: v1
# metadata:
#   askId: poc
#   caAgileId: poc
#   projectKey: com.optum.pdp.${PROJECT_NAME}:${COMPONENT_NAME}
#   projectFriendlyName: ${PROJECT_NAME}-${COMPONENT_NAME}
#   componentType: code
#   targetQG: GATE_00
# EOF

#Generate the Archetype
#mvn archetype:generate -B \
#-DarchetypeArtifactId=pdp-spark-reference-project-archetype \
#-DarchetypeGroupId=com.optum.pdp \
#-DarchetypeVersion=18.40.3 \
#-DgroupId=com.optum.pdp \
#-DartifactId=${PROJECT_NAME} \
#-Dpackage=com.optum.pdp \
#-Dversion=${VERSION}

#Replace Optumfile with new, parameterized optumfile
# mv ./Optumfile.yml ${PROJECT_NAME}/Optumfile.yml
cd $PROJECT_NAME
git add .
git stash
git checkout -b dev
cat > ./README.md << EOF
#This application was created from the pdp-spark-reference-project-archetype. Please update the README as you develop
EOF
git add .
git commit -m "Creating dev branch"
git push -u origin dev
git checkout -b feature/create_from_archetype
git stash pop
git commit -m "Created from archetype"
git push -u origin feature/create_from_archetype
