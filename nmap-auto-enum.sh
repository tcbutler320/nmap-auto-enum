#!/bin/bash 
# Author: Tyler Butler 
 
# {!} output is redirected to > /dev/null to suppress printing to console

# Initialize project folder 
mkdir report
cd report

## Before starting, add target to targets.txt
# echo [my targer] >> targets.txt



export TARGET_RANGE=targets.txt
echo {!} Initialization  Done
echo "   |"
echo "   |"
echo "   |"
echo "   |"



# sweep for up targets
nmap -sn -iL $TARGET_RANGE -oG nmap-sweep.txt > /dev/null
cat nmap-sweep.txt | grep "Status: Up" | cut -d" " -f 2  > all-ips.txt
export IPS=all-ips.txt
echo {!} Nmap Sweep Scan Done
echo "   |"
echo "   |"
echo "   |"
echo "   |"



# Fast enumeration 
nmap --top-ports 100 -iL $IPS -oX fast-enum.xml > /dev/null
echo {!} Nmap Fast Scan Done
echo "   |"
echo "   |"
echo "   |"
echo "   |---- {!} Nmap Fast Scan Done"
echo "   |---- {!} Creating HTML Output"
xsltproc fast-enum.xml -o fast-enum.html
export FAST_HTML=fast-enum.html
echo "   |---- {!} Output Created"
echo "   |"
echo "   |---- {!} Opening in firefox"
firefox $FAST_HTML
echo "   |"



# Complex enumeration 
echo {!} Starting Complex Scan  
nmap -sV -A -O -p- -iL $IPS -oX complex-enum.xml > /dev/null
echo "   |"
echo "   |"
echo "   |---- {!} Nmap Complex Scan Done"
echo "   |---- {!} Creating HTML Output"
xsltproc complex-enum.xml - o complex-enum.html
export COMPLEX_HTML=complex-enum.html
echo "   |---- {!} Output Created"
echo "   |"
echo "   |---- {!} Opening in firefox"
firefox $COMPLEX_HTML
echo "   |"



# Run all targets through all NSE vulns...pray services dont crash
# Make file of all vuln scripts 
ls /usr/share/nmap/scripts | grep vuln > all-nse-vulns.txt
echo {!} Starting Nmap NSE Vulnerability Scan 
for vuln in $(cat all-nse-vulns.txt); for ip in $(cat $IPS); do nmap --script=$vuln $ip -oX all-vuln-scan.xml > /dev/null  ; done; done
echo "   |"
echo "   |"
echo "   |---- {!} Nmap NSE Vulnerability Scan Done"
echo "   |---- {!} Creating HTML Output"
xsltproc all-vuln-scan.xml -o 
export ALL_HTML=all-vuln-scan.html 
echo "   |---- {!} Output Created"
echo "   |"
echo "   |---- {!} Opening in firefox"
firefox $ALL_HTML
echo "   |"

