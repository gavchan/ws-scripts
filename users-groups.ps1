function UserAdd($user, $pass) {
	net user $user $pass /add
}

function UserDel($user) {
	net user $user /delete
}
<#
function CreateGroupsFromInput {
    $Input = Read-Host -prompt "Enter a group name to add (or just <Enter> to quit)"
	while ($Input -ne "")
	{
		Write-Host "Creating group: $Input"
		net localgroup "$Input" /add
		$Input = Read-Host -prompt "Enter a group name to add (or just <Enter> to quit)"
	}
}
#>
function CreateGroupsFromFile ($filepath) {

    <#
    .SYNOPSIS
        Creates a series of groups from a .CSV file with 1st field named "Group"
    #>

	$Groups = Import-Csv -Delimiter "|" -Path $filepath
	foreach ($Group in $Groups)
	{
		net localgroup $Group.Group /add
	}
}


function DeleteGroupsFromFile ($filepath) {
    <#
    .SYNOPSIS
        Deletes a series of groups from a .CSV file with 1st field named "Group"
    #>

    $Groups = Import-Csv -Delimiter "|" -Path $filepath
	foreach ($Group in $Groups)
	{
		net localgroup $Group.Group /delete
	}
}

function AddUsersToGroup($group, $userlist) {

    <#
    .SYNOPSIS
        Adds a comma separated user list to an existing group
    .PARAMETER $group
        Existing group name
    .PARAMETER $userlist
        A comma separated list of usernames, e.g. User1,User2,User3
    #>

	$userlist.Split(",") | ForEach {
		Write-Host "Adding user $_ to the group $group"
		net localgroup $group $_ /add
	}
}

function AddUsersToGroupFromInput($Groupname) {

    <#
    .SYNOPSIS
        Takes input from host to add users to a given group.
    #>

    $Input = Read-Host -prompt "Enter a username to add to $Groupname (or just <Enter> to quit)"
	while ($Input -ne "")
	{
		Write-Host Adding $Input to group $Groupname
		net localgroup $Groupname $Input /add
		$Input = Read-Host -prompt "Enter a username to add to $Groupname (or just <Enter> to quit)"
	}
}

function CreateUsersFromFile ($filepath) {

    <#
    .SYNOPSIS
        Creates a series of users from a given $filepath
    #>

	$Users = Import-Csv -Delimiter "|" -Path $filepath
    Write-Host "Retrieving Users from $filepath"

	foreach ($User in $Users)
	{
		Write-Host Adding $User.Username $User.Pass
		net user $User.Username $User.Pass /add

	}
}

function DeleteUsersFromFile ($filepath) {

    <#
    .SYNOPSIS
        Deletes a series of users from a given $filepath
    #>

	$Users = Import-Csv -Delimiter "|" -Path $filepath
	foreach ($User in $Users)
	{
		Write-Host Deleting $User.Username
    	net user $User.Username /delete
	}
}

function AddGroupList ($filepath) {

    <#
    .SYNOPSIS
        Deletes a series of users from a given $filepath
    #>

	$Groups = Import-Csv -Delimiter "|" -Path $filepath
	foreach ($Group in $Groups)
	{
		AddUsersToGroup $Group.Group $Group.Users
	}
}

function PrintUserList ($filepath) {
	$Users = Import-Csv -Delimiter "|" -Path $filepath
	foreach ($User in $Users)
	{
		Write-Host $User.Username $User.Pass
	}
}

function ResetAndAdd() {
	Write-Host "Starting fresh by deleting existing groups and users from grouplist.csv and userlist.csv"

	# --- Delete previous entries
	DeleteGroupsFromFile("./grouplist.csv")
	DeleteUsersFromFile("./userlist.csv")

	# --- Create groups from file
	Write-Host "Creating Groups from grouplist.csv"
	CreateGroupsFromFile("./grouplist.csv")

	# --- Create users from file
	Write-Host "Adding Users from userlist.csv with the respective passwords"
	CreateUsersFromFile("./userlist.csv")

	# --- Add users to group
	Write-Host "Add list of users into specified group from grouplist.csv"
	AddGroupList("./grouplist.csv")
}

# --- Display Info

Write-Host "Functions installed from script:"
Write-Host "The default Users list is stored in ./userlist.csv - Fields: User|Pass"
Write-Host "The default Group list is stored in ./grouplist.csv - Fields: Group|Users (user1,user2,user3"

Write-Host "function UserAdd(user, pass)"
Write-Host "function UserDel(user)"
Write-Host "function CreateGroupsFromInput()"
Write-Host "function CreateGroupsFromFile (filepath)"
Write-Host "function DeleteGroupsFromFile (filepath)"
Write-Host "function AddUsersToGroup(group, userlist)"
Write-Host "function AddUsersToGroupFromInput(Groupname)"
Write-Host "function CreateUsersFromFile (filepath)"
Write-Host "function DeleteUsersFromFile (filepath)"
Write-Host "function AddGroupList (filepath)"
Write-Host "function PrintUserList (filepath)"
Write-Host "function ResetAndAdd()"

Write-Host "`nExecute ResetAndAdd to start reset existing groups/users and add them again"

