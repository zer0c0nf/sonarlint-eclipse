#!/bin/bash

set -euo pipefail

CURRENT_VERSION=`mvn help:evaluate -Dtycho.mode=maven -Dexpression="project.version" | grep -v '^\[\|Download\w\+\:'`
RELEASE_VERSION=`echo $CURRENT_VERSION | sed "s/-.*//g"`

QA_VERSION="$RELEASE_VERSION.$CI_BUILD_NUMBER"

# Download QA update site and put it at the location it would have been after a build
mvn dependency:get -Dartifact=org.sonarsource.sonarlint.eclipse:org.sonarlint.eclipse.site:$QA_VERSION:zip
mvn dependency:unpack -Dartifact=org.sonarsource.sonarlint.eclipse:org.sonarlint.eclipse.site:$QA_VERSION:zip -DoutputDirectory=org.sonarlint.eclipse.site/target/repository/

cd its
mvn clean verify -Dtarget.platform=$TARGET_PLATFORM -Dtycho.localArtifacts=ignore -Dsonarlint-eclipse.p2.url=`pwd`/org.sonarlint.eclipse.site/target/repository/
