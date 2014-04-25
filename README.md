SCCMSoftwareUpdateGroupPS
====================
PowerShell Script for easier management of Windows Updates into Groups on System Center Configuration Manager 2012
prerequisites are:
PowerShell 3
Microsoft System Center Configuration Manager 2012 SP1 and up
**SCCM 2012 Module can only be loaded into a x86 instance of PowerShell**

A bit more..
-----------------
Hey folks,
In an organized environment, sometimes it not so easy to follow after updates and patch management.
patchs need's to be check before rollout, and after that, you need to go and search for those updates and add them into a group for deployment.

and in a flow diagram:
Microsoft releases a patch ->  Patch Testing and making sure it has no impact on production environment -> Rollout

How does it make things easier?
-------------------------------
Well, Using SCCMSoftwareUpdateGroup.ps1, its easier to import the updates from a txt file into an existing SoftwareUpdateGroup.

you can also use it to scan for updates in your SCCM

How to use it
---------------------------

- To scan for Updates and see if they are present on your SCCM, use the following,

  **.\SCCMSoftwareUpdateGroup.ps1 -Scan KB2909210**

- To add into an existing group, use the following string accordingly.

  **.\SCCMSoftwareUpdateGroup.ps1 -UpdatesFile "C:\Temp\updates.txt" -SUG "Updates for February 2014" -Logfile "C:\Temp\PSUpdates.log"**

