import os
import sys
import subprocess

def mailpasswd(acct):
    acct = os.path.basename(acct)
    path = os.path.expanduser("~/.mu4e.d/passwd/{0}.gpg".format(acct))
    args = ["gpg", "--use-agent", "--quiet", "--batch", "-d", path]
    try:
        return subprocess.check_output(args).strip()
    except subprocess.CalledProcessError:
        return ""

def prime_gpg_agent():
    ret = False
    count = 1
    while not ret:
        ret = (mailpasswd("prime")=="prime")
        if count>2:
            from offlineimap.ui import getglobalui
            sys.stderr.write("Error reading in passwords. Terminating.\n")
            getglobalui().terminate()
        count += 1
    return ret

prime_gpg_agent()
