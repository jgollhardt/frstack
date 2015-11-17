

TODO: Create ssoadm sidecar container


Issues:


We are hitting this:

https://wikis.forgerock.org/confluence/display/openam/Using+the+ssoadm+command+with+a+Site+configuration

Need to fix up the site mapping:

Add this to ssoadm startup:

-D"com.iplanet.am.naming.map.site.to.server=http://openam.example.com:80/openam=http://openam-svc-a:80/openam" \

Test it with:

bin/ssoadm list-agents -e / -u amadmin -f pw


Todo: install script needs to:

- Install ssoadm
- Fix up ssoadm command
- Copy secret am password file,chmod 0400

Those all need to happen *after* AM is installed and running


Config watcher:
Poll git repo, watch for changes? Apply those changes.....
How to know if you have already processed a change?
How could we make this container listen for changes and apply them? Small go program??



