echo "Creating Headers"
paxctl -c /usr/lib64/plexmediaserver/Plex\ Media\ Server
paxctl -c /usr/lib64/plexmediaserver/Plex\ Media\ Server\ Tests
paxctl -c /usr/lib64/plexmediaserver/Plex\ Media\ Scanner
paxctl -c /usr/lib64/plexmediaserver/Plex\ Transcoder
paxctl -c /usr/lib64/plexmediaserver/Plex\ Script\ Host
paxctl -c /usr/lib64/plexmediaserver/Plex\ Relay

echo "Disabling memory pax check"
paxctl -m /usr/lib64/plexmediaserver/Plex\ Media\ Server 
paxctl -m /usr/lib64/plexmediaserver/Plex\ Media\ Server\ Tests
paxctl -m /usr/lib64/plexmediaserver/Plex\ Media\ Scanner 
paxctl -m /usr/lib64/plexmediaserver/Plex\ Transcoder
paxctl -m /usr/lib64/plexmediaserver/Plex\ Script\ Host
paxctl -m /usr/lib64/plexmediaserver/Plex\ Relay
