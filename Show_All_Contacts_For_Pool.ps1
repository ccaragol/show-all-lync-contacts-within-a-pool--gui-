<##########################################################################  
   
Script Name:	
Show All Lync User Contacts
   
Contact Info: 
Name	  		C. Anthony Caragol 
LinkedIn  		https://www.linkedin.com/profile/view?id=18013352
  
Description:	
I wrote this for myself, realized there were others, but not exactly 
the same, so here we are.  :)
 
 
##########################################################################>  

function ShowGridView {
	Param([string]$poolfqdn="")

	$servername = "$poolfqdn\rtclocal"
	$database = "rtc"
	$connectionString = "Server=$servername;Database=$database;Integrated Security=SSPI;"
 


	$query = @"
		select
		(SELECT UserAtHost FROM dbo.Resource WHERE ResourceId = cg.OwnerId) as Owner,
		convert(varchar(max), cg.DisplayName) as ContactGroup,
		cg.GroupNumber,
		convert(varchar(max), cg.ExternalUri) as ContactGroupUri,
		(SELECT UserAtHost FROM dbo.Resource WHERE ResourceId = BuddyId) as Buddy

		from dbo.ContactGroup cg
		LEFT JOIN dbo.ContactGroupAssoc cga
		ON cg.GroupNumber=cga.GroupNumber
		AND cg.OwnerId=cga.OwnerId 
"@



	$connection = New-Object System.Data.SqlClient.SqlConnection
	$connection.ConnectionString = $connectionString
	$connection.Open()
	$command = $connection.CreateCommand()
	$command.CommandText  = $query
 
	$result = $command.ExecuteReader()
 
	$table = new-object “System.Data.DataTable”
	$table.Load($result)

	$table | Out-Gridview -title "Lync User Contacts" -PassThru
}

<#####################################################################  

Force the script to run as Administrator to allow access to local RTC 
 instances.   

Ripped from Ben Armstrong's blog:
http://blogs.msdn.com/b/virtual_pc_guy/archive/2010/09/23/a-self-elevating-powershell-script.aspx

######################################################################>  

# Get the ID and security principal of the current user account
$myWindowsID=[System.Security.Principal.WindowsIdentity]::GetCurrent()
$myWindowsPrincipal=new-object System.Security.Principal.WindowsPrincipal($myWindowsID)
  
# Get the security principal for the Administrator role
$adminRole=[System.Security.Principal.WindowsBuiltInRole]::Administrator
  
# Check to see if we are currently running "as Administrator"
if ($myWindowsPrincipal.IsInRole($adminRole))
	{
	# We are running "as Administrator" - so change the title and background color to indicate this
	$Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + "(Elevated)"
	$Host.UI.RawUI.BackgroundColor = "DarkBlue"
	clear-host
	}
else
	{
	# We are not running "as Administrator" - so relaunch as administrator
    
	# Create a new process object that starts PowerShell
	$newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";

 	# Specify the current script path and name as a parameter
 	$newProcess.Arguments = "& '" + $script:MyInvocation.MyCommand.Path + "' -noexit"

	 # Indicate that the process should be elevated

	 $newProcess.Verb = "runas";

 	# Start the new process

 	[System.Diagnostics.Process]::Start($newProcess);
	
    
	# Exit from the current, unelevated, process
	exit
	}


[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null

$poolfqdnquery = [Microsoft.VisualBasic.Interaction]::InputBox("Enter the FQDN of a front end pool", "Front End Pool", "") 
ShowGridView -poolfqdn $poolfqdnquery