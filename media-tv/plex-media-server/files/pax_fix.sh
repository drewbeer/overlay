echo "Creating Headers"
paxctl -c /usr/lib64/plexmediaserver/Plex\ Media\ Server
paxctl -c /usr/lib64/plexmediaserver/Plex\ Media\ Scanner
paxctl -c /usr/lib64/plexmediaserver/Resources/Python/bin/python
paxctl -c /usr/lib64/plexmediaserver/Plex\ DLNA\ Server 
paxctl -c /usr/lib64/plexmediaserver/Resources/Plex\ Transcoder
paxctl -c /usr/lib64/plexmediaserver/Resources/Plex\ New\ Transcoder

echo "Disabling memory pax check"
paxctl -m /usr/lib64/plexmediaserver/Resources/Python/bin/python
paxctl -m /usr/lib64/plexmediaserver/Plex\ Media\ Server 
paxctl -m /usr/lib64/plexmediaserver/Plex\ Media\ Scanner 
paxctl -m /usr/lib64/plexmediaserver/Plex\ DLNA\ Server 
paxctl -m /usr/lib64/plexmediaserver/Resources/Plex\ Transcoder
paxctl -m /usr/lib64/plexmediaserver/Resources/Plex\ New\ Transcoder
