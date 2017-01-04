# CrafterCMS Docker Images

## Summary
These are lightweight images for **local development only**.

The build script will look for the required WARs in the 'files' folder and
then try to download them from maven servers. This allows
to reuse the downloaded files and use custom versions such as overlays.

## Examples
Quickly build all images: `./rebuild-all.sh 2.5.2`

To build a specific image: `./build.sh engine 2.5.2`

To build an image using a custom version:

- Create a folder under 'files' with the name of the version
- Place the required war files in the new folder
- Run any of the scripts using the folder name as the version parameter: `.build.sh studio custom-version`

## Images
|**Name**|**Description**|**Required Files**|
|:---:|---|:---:|
|base|Apache Tomcat 8 with shared class loader for CrafterCMS configurations.|None|
|engine|[CrafterCMS Engine](https://github.com/craftercms/engine) Delivery server.|ROOT.war|
|studio|[CrafterCMS Studio](https://github.com/craftercms/studio2) Authoring server.|ROOT.war, studio.war|
|search|[CrafterCMS Search](https://github.com/craftercms/search) Search & Solr server.|crafter-search.war, solr-crafter.war|
|profile|[CrafterCMS Profile](https://github.com/craftercms/profile) Profile server & admin console|crafter-profile.war, crafter-profile-admin-console.war|
|social|[CrafterCMS Social](https://github.com/craftercms/social) Social server & admin console|crafter-social.war, crafter-social-admin.war|
|deployer|[CrafterCMS Deployer](https://github.com/craftercms/legacy-deployer) Deployer agent.|cstudio-publishing-receiver.zip|

## References
- [Official CrafterCMS documentation](http://docs.craftercms.org)
- [Official CrafterCMS Docker images](https://github.com/craftercms/docker)

## Future Improvements
- Update the repository URL to support snapshots
- Update logging configuration to enable debug with a parameter
- Test deployer image with [newer versions](https://github.com/craftercms/deployer)
- Use the official Solr image: crafter-search.war seems to be compatible only with Solr 4.x and there are only images for 5.x & 6.x
