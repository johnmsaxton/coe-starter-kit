# Pre Work
# Download and install PAC CLI if needed: https://learn.microsoft.com/en-us/power-platform/developer/cli/introduction
#
# Download latest Creator KIt. COE Has dependencies on the Creator Kit: https://aka.ms/creatorkitdownload
# Download latest COE https://aka.ms/coestarterkitdownload
# Unzip into a single directory (A temp work directory would be best)      
# 
# Install latest PAC CLI run:
#
# 	pac install latest 
#
# It will be installed to something similar to below:
# 	C:\Users\<YOUR USER NAME>\AppData\Local\Microsoft\PowerAppsCli\Microsoft.PowerApps.CLI.<CLI VERSION NUMBER>\tools 
#
# update pac.exe.config. Add the following underneath the startup element:
#
#	<appSettings>
#   	<add key="MaxDataverseConnectionTimeOutMinutes" value="20"/> 
#   </appSettings>
#
# This will increase the dataverse connection timeout used by PAC to 20 minutes. Max timeout is 60 minutes. If the timeout
# is too short, the pac call will fail. 
#
# After updating config, run the command below to make sure the most recent version of PAC is used at runtime. 
# 	run pac use latest
#
#
# If you don't know the display name for your target environment, run the following. To log in:  
#  	pac auth create 
#
# To get a list of environments, run:
#	pac org list
#
# This will return a list of environments for the tenant 
#==================================================================================================================================

# provide name of environment where COE is installed
param($environment)

# this list reflects order of dependence. Creator Kit has to go first because Core depends on it. Most of the the other solutions depend on Core, so that goes 2nd. Beyond that, Its up to you. This order works. 
#

$coe = "CreatorKitCore",
	"CenterofExcellenceCoreComponents",
	"CenterofExcellenceAuditComponents",
	"CenterofExcellenceAuditLogs",
	"CenterofExcellenceNurtureComponents",
	"CenterofExcellenceInnovationBacklog",
	"CenterofExcellenceALMAccelerator",
	"admintaskanalysis_core"



pac auth create
pac org select --environment $environment

#loop thru dpendency list looking for COE updates. Apply as found
foreach ($solution in $coe)
{
	$files = Get-ChildItem .\*$solution*.zip
	foreach($file in $files)
	{
		Write-Host ""
		Write-Host Updating $file.Name 
		pac solution import --path $file.Name --publish-changes
	}             
}

