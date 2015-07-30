echo "Creating Headers"
paxctl -c /opt/sangoma/nbca/bin/netborder-call-analyzer-engine
paxctl -c /opt/sangoma/nbca/bin/netborder-call-analyzer-service
paxctl -c /opt/sangoma/nbca/bin/netborder-oam-cmd
paxctl -c /opt/sangoma/nbca/bin/netborder-python
paxctl -c /opt/sangoma/nbca/bin/netborder-rm

echo "Disabling memory pax check"
paxctl -m /opt/sangoma/nbca/bin/netborder-call-analyzer-engine
paxctl -m /opt/sangoma/nbca/bin/netborder-call-analyzer-service
paxctl -m /opt/sangoma/nbca/bin/netborder-oam-cmd
paxctl -m /opt/sangoma/nbca/bin/netborder-python
paxctl -m /opt/sangoma/nbca/bin/netborder-rm
