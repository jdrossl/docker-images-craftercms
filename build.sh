#!/bin/bash

# Script for building craftercms docker images.

if [[ $# != 2 ]]; then
	echo "Usage: build.sh <image> <version>"
	exit 1
fi

IMAGE=$1
VERSION=$2
if [[ $VERSION =~ ^.*-SNAPSHOT$ ]]; then
	REPO="snapshots"
else
	REPO="releases"
fi
BUILD_ARG="--build-arg CRAFTER_VERSION=$VERSION"

CRAFTER_GROUP="org.craftercms"
SONATYPE_URL="https://oss.sonatype.org/service/local/artifact/maven/redirect"

function download {
	FILE="files/$VERSION/$4"
	echo "Looking for $FILE"
	if [[ ! -f $FILE || $REPO == "snapshots" ]]; then
		echo "Downloading $FILE"
		curl -L -o "$FILE" --create-dirs "$SONATYPE_URL?g=$1&a=$2&v=$VERSION&r=$REPO&p=$3"
		echo "Done"
	fi
}

echo "Running build for $IMAGE $VERSION"

if [[ $IMAGE == "base" ]]; then
	BUILD_ARG=""
fi

if [[ $IMAGE == "deployer" ]]; then
	FOLDER="files/$VERSION/cstudio-publishing-receiver"
	ZIP="$FOLDER.zip"
	download $CRAFTER_GROUP "crafter-studio-publishing-receiver-zip" "zip" "cstudio-publishing-receiver.zip"
	echo "Looking for $FOLDER"
	if [[ ! -d $FOLDER ]]; then
		echo "Unzipping $ZIP"
		unzip "$ZIP" -d "$FOLDER"
		rm "$FOLDER/conf/*"
		echo "Done"
	fi
fi

if [[ $IMAGE == "engine" || $IMAGE == "studio" ]]; then
	download $CRAFTER_GROUP "crafter-engine" "war" "ROOT.war"
fi

if [[ $IMAGE == "profile" ]]; then
	download $CRAFTER_GROUP "crafter-profile" "war" "crafter-profile.war"
	download $CRAFTER_GROUP "crafter-profile-admin-console" "war" "crafter-profile-admin-console.war"
fi

if [[ $IMAGE == "social" ]]; then
	download $CRAFTER_GROUP "crafter-social" "war" "crafter-social.war"
	download $CRAFTER_GROUP "crafter-social-admin" "war" "crafter-social-admin.war"
fi

if [[ $IMAGE == "search" ]]; then
	download $CRAFTER_GROUP "crafter-search-server" "war" "crafter-search.war"
	FILE="files/solr-crafter.war"
	echo "Looking for $FILE"
	if [[ ! -f $FILE ]]; then
		echo "Downloading $FILE"
		curl -o "$FILE" --create-dirs "http://repo1.maven.org/maven2/org/apache/solr/solr/4.10.4/solr-4.10.4.war"
		echo "Done"
	fi
fi

if [[ $IMAGE == "studio" ]]; then
	download $CRAFTER_GROUP "crafter-studio-2" "war" "studio.war"
fi

docker build $BUILD_ARG -f "$IMAGE/Dockerfile" -t "crafter-$IMAGE:$VERSION" .

echo "Done"
