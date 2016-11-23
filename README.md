# fastexit
Making it easier to run your own Tor Exit Node.

##Options
Do you want to disable Nginx from logging HTTP requests? (Y/N)
- We highly recommend selecting Y (yes) for this option. This will disable Nginx from logging HTTP requests to the exit node landing page. These logs serve no purpose and could actually harm users who visit the IP via browser if law enforcement decides to seize the server and look through nginx access logs. The goal here is to keep zero logs on the Tor exit server that would be useful in any forensic or legal situation.


##Usage
`bash fastexit.sh`

##Notes
If you have any problems feel free to email us: `security[at]torworld.org`
