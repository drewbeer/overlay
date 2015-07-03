echo "Creating Headers"
paxctl -c /opt/Sangoma_NetBorderCallAnalyzer/bin/netborder-call-analyzer-engine
paxctl -c /opt/Sangoma_NetBorderCallAnalyzer/bin/netborder-call-analyzer-service
paxctl -c /opt/Sangoma_NetBorderCallAnalyzer/bin/netborder-oam-cmd
paxctl -c /opt/Sangoma_NetBorderCallAnalyzer/bin/netborder-python
paxctl -c /opt/Sangoma_NetBorderCallAnalyzer/bin/netborder-rm

echo "Disabling memory pax check"
paxctl -m /opt/Sangoma_NetBorderCallAnalyzer/bin/netborder-call-analyzer-engine
paxctl -m /opt/Sangoma_NetBorderCallAnalyzer/bin/netborder-call-analyzer-service
paxctl -m /opt/Sangoma_NetBorderCallAnalyzer/bin/netborder-oam-cmd
paxctl -m /opt/Sangoma_NetBorderCallAnalyzer/bin/netborder-python
paxctl -m /opt/Sangoma_NetBorderCallAnalyzer/bin/netborder-rm
