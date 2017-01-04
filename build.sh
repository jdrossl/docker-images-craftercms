#!/bin/bash

# Script for building craftercms docker images.

if [[ $# != 2 ]]; then
	echo "Usage: build.sh <image> <version>"
	exit 1
fi

IMAGE=$1
VERSION=$2
BUILD_ARG="--build-arg CRAFTER_VERSION=$VERSION"

MAVEN_URL="https://repo1.maven.org/maven2/org"

function download {
	FILE="files/$VERSION/$2"
	echo "Looking for $FILE"
	if [[ ! -f $FILE ]]; then
		echo "Downloading $FILE"
		curl -o "$FILE" --create-dirs "$MAVEN_URL/craftercms/$1/$VERSION/$1-$VERSION.$3"
		echo "Done"
	fi
}

if [[ -z $IMAGE || -z $VERSION ]]; then
	echo "Usage build.sh <IMAGE> <VERSION>"
	exit 1
fi

echo "Running build for $IMAGE $VERSION"

if [[ $IMAGE == "base" ]]; then
	BUILD_ARG=""
fi

if [[ $IMAGE == "deployer" ]]; then
	FOLDER="files/$VERSION/cstudio-publishing-receiver"
	ZIP="$FOLDER.zip"
	download "crafter-studio-publishing-receiver-zip" "cstudio-publishing-receiver.zip" "zip"
	echo "Looking for $FOLDER"
	if [[ ! -d $FOLDER ]]; then
		echo "Unzipping $ZIP"
		unzip "$ZIP" -d "$FOLDER"
		rm $FOLDER/conf/*
		echo "Done"
	fi
fi

if [[ $IMAGE == "engine" || $IMAGE == "studio" ]]; then
	download "crafter-engine" "ROOT.war" "war"
fi

if [[ $IMAGE == "profile" ]]; then
	download "crafter-profile" "crafter-profile.war" "war"
	download "crafter-profile-admin-console" "crafter-profile-admin-console.war" "war"
fi

if [[ $IMAGE == "social" ]]; then
	download "crafter-social" "crafter-social.war" "war"
	download "crafter-social-admin" "crafter-social-admin.war" "war"
fi

if [[ $IMAGE == "search" ]]; then
	download "crafter-search-server" "crafter-search.war" "war"
	FILE="files/solr-crafter.war"
	echo "Looking for $FILE"
	if [[ ! -f $FILE ]]; then
		echo "Downloading $FILE"
		curl -o "$FILE" --create-dirs "$MAVEN_URL/apache/solr/solr/4.10.4/solr-4.10.4.war"
		echo "Done"
	fi
fi

if [[ $IMAGE == "studio" ]]; then
	download "crafter-studio-2" "studio.war" "war"
fi

docker build $BUILD_ARG -f "$IMAGE/Dockerfile" -t "crafter-$IMAGE:$VERSION" .

echo "Done"
