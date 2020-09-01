Debian-ISPConfig3-migration
===========================

This script is used to migrate ISPConfig 3 data.

I forked it from https://github.com/teris/Debian-ISPConfig3-migration , therefore credit to them. I'm only working to translate it to English and perhaps update some things.
I'm testing it on Debian 6.3.0-18+deb9u1


The script is shell based and can be used on any Ubuntu / Debian GNU server. Script was tested under Debian Wheezy (7).

I would be happy to receive feedback. Please note that the User / Groups and UNIX passwords have to be inserted manually.

The access data will be saved from the old server. This is located under the / root / old-server / directory. (passwd and group) The originals can be found under / etc / passwd and / etc / group. Simply edit it with an editor (vi or nano) Example: cat / root / old-server / passwd Output: replicatorx1002: 1002: ,,,: / home / replicator: / bin / bash Simply copy this and save it in the original: nano / etc / passwd rootx0: 0: root: / root: / bin / bash replicatorx1000: 1000: ,,,: / home / replicator: / bin / bash DONE!

Download ... Unzip ... start chmod 0777!
