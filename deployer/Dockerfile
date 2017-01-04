FROM openjdk:jre-alpine

ARG CRAFTER_VERSION

ENV DEPLOYER_HOME "/opt/crafter-deployer"

RUN mkdir -p $DEPLOYER_HOME

WORKDIR $DEPLOYER_HOME

ADD files/$CRAFTER_VERSION/cstudio-publishing-receiver/ .
ADD deployer/deployer-docker-entry.sh .

RUN chmod +x deployer-docker-entry.sh

VOLUME $DEPLOYER_HOME/target

EXPOSE 9191

CMD $DEPLOYER_HOME/deployer-docker-entry.sh