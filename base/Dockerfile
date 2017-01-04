FROM tomcat:alpine

# Clear default apps
RUN rm -r webapps/*

# Create folder for shared class loader
RUN mkdir shared

# Add shared class loader path to conf
RUN sed -Ei.back 's/^(shared\.loader\=)$/\1\$\{catalina\.home\}\/shared\/classes/' conf/catalina.properties

EXPOSE 8080
EXPOSE 8009
