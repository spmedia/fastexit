# fastexit
Making it easier to run your own Tor Exit Node.

##Options
Do you want to disable Nginx from logging HTTP requests? (Y/N)
- We highly recommend selecting Y (yes) for this option. This will disable Nginx from logging HTTP requests to the exit node landing page. These logs serve no purpose and could actually harm users who visit the IP via browser if law enforcement decides to seize the server and look through nginx access logs. The goal here is to keep zero logs on the Tor exit server that would be useful in any forensic or legal situation.

Would you like to install TorARM to help monitor your Exit? (Y/N)
The anonymizing relay monitor (arm) is a CLI status monitor for Tor. This functions much like top does for system usage, providing real time statistics for:
- resource usage (bandwidth, cpu, and memory usage)
- general relaying information (nickname, fingerprint, flags, or/dir/controlports)
- event log with optional regex filtering and deduplication
- connections correlated against tor's consensus data (ip, connection types, relay details, etc)
- torrc configuration file with syntax highlighting and validation

<img src="http://i.imgur.com/2dMeoim.png">

##Usage
`bash fastexit.sh`

##Notes
If you have any problems feel free to email us: `security[at]torworld.org`
