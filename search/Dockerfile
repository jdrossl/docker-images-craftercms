FROM crafter-base

ARG CRAFTER_VERSION

COPY files/$CRAFTER_VERSION/crafter-search.war webapps/
COPY files/solr-crafter.war webapps/

COPY search/solr solr-crafter

COPY search/solr-crafter.xml conf/Catalina/localhost/

RUN sed -Ei.back 's/^(common\.loader\=)$/\1\$\{catalina\.home\}\/solr-crafter\/lib\/ext\/\*\.jar/' conf/catalina.properties
