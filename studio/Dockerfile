FROM crafter-base

ARG CRAFTER_VERSION

COPY files/$CRAFTER_VERSION/ROOT.war webapps/
COPY files/$CRAFTER_VERSION/studio.war webapps/

VOLUME data/derby
VOLUME data/repo
