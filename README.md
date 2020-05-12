Show All Lync Contacts Within A Pool (GUI)
==========================================

            

There are a few scripts out there like this one, I wrote one for myself before I realized I was reinventing the wheel a bit.  This script can be run from anywhere with PowerShell as long as you're running it from an account that has access to the rtclocal
 database on your Lync front ends. 


Usage:


Run the script with PowerShell, enter a front end pool name, click Ok.  From there all of the contacts and groups for the pool will be sent into a gridview window which can be sorted or filtered.


Notes:


The script forces itself to run in Admin mode.  This is simply to get over a hurdle where running it on the front end itself does not allow direct access to the rtclocal database.


One caveat, this may return zero results for Unified Contact Store users as the contacts are no longer stored in Microsoft Lync.


If you have any ideas, or suggestions, please let me know.


Thank you!


        
    
