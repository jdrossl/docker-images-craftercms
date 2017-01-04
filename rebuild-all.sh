#!/bin/bash

VERSION=$1

docker rmi \
	crafter-base \
	crafter-deployer:$VERSION \
	crafter-engine:$VERSION \
	crafter-search:$VERSION \
	crafter-profile:$VERSION \
	crafter-social:$VERSION \
	crafter-studio:$VERSION

./build.sh base "latest"
./build.sh deployer $VERSION
./build.sh engine $VERSION
./build.sh search $VERSION
./build.sh profile $VERSION
./build.sh social $VERSION
./build.sh studio $VERSION
