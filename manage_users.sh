#!/bin/sh -u
PATH=/bin:/usr/bin ; export PATH
umask 022

#Lily S
#manage_users
#March 2025
#Functionality: Menu system that allows a user to select from a list of functions that perform a varied amount of tasks; adding or deleting user account, changing groups, shells, expiration dates, etc.

app_continue=1

#Menu function, list user options and ask for input
menu () {
	clear
	echo
	echo "Main Menu"
	echo
	echo "Enter 'A' to create a user."
	echo "Enter 'D' to delete a user."
	echo "Enter 'E' to change expiration date for a user."
	echo "Enter 'I' to change a user's primary group."
	echo "Enter 'L' to change a user's login shell."
	echo "Enter 'S' to change a user's supplementary group."
	echo "Enter 'Q' to quit the script."
	read -p "Awaiting user input: " user_selection
}

#Creates new user account by prompting active user for respective fields 
add_user () {
	echo
	echo "Create a user account: "
	echo
	read -p "Enter a username: " user_name
	read -p "Path to home directory: (Must use absolute path): " home_dir
	read -p "Enter default login shell: (Must use absolute path): " user_shell
	read -p "Enter the primary group this user will be in (Will be created if doesnt exist): " user_group
	sudo groupadd -f $user_group
	sudo useradd -d $home_dir -m -s $user_shell -g $user_group $user_name

	if [ $? -ne 0 ] ; then
		echo "$0: Could not add user." 1>&2
	else
	       echo "User $user_name created. Returning to menu."	       
	fi
	sleep 2
	echo "Returning to main menu..."
	sleep 5
	clear
}

#Deletes user account by prompting active user for respective fields (Additional warning is given before executing delete)
del_user () {
	echo
 	echo "Delete a user's account: "	
	echo
	read -p "Enter username: " user_name
	read -p "[WARNING] This will delete the user associated with this username. Are you sure? [Y/N]" yes_no
	case $yes_no in
		y | Y ) echo "Attempting to delete user..." ;;
		n | N ) echo "Exiting program"
			sleep 2 
			exit 1 ;; 
		* ) echo "$0: Invalid input." 1>&2 ;;
	esac
	sudo userdel -r $user_name
	if [ $? -ne 0 ] ; then
		echo "$0: Could not delete user." 1>&2
	else 
		echo "User deletion successful."
	fi
        sleep 2
	echo "Returning to main menu..." 
        sleep 5
	clear	
}

#Changes user's primary/initial group
chng_prim_group() {
	echo
	echo "Change user's primary group. "
	echo
	read -p "Enter username: " user_name
	read -p "Enter the desired group:  " prim_group
	sudo groupadd -f $prim_group 
	sudo usermod -g $prim_group $user_name
	if [ $? -ne 0 ] ; then
		echo "$0: Could not delete user." 1>&2
	else
		echo "User's ($user_name) primary group changed to $prim_group"	
	fi
	sleep 2
	echo "Returning to main menu"
	sleep 5
	clear
}

#Change user's supplemental group
chng_supp_group () {

	echo
	echo "Change user's supplemental group. "
	echo
	read -p "Enter username: " user_name
	read -p "Enter the supplemental group name that the user is in: " supp_group
	sudo groupadd -f $supp_group
	sudo usermod -G $supp_group $user_name
	if [ $? -ne 0 ] ; then
		echo "$0: Could not change supplemental group." 1>&2
	else
		echo "User's ($user_name) supplemental group changed to $supp_group"
	fi
	sleep 2
	echo "Returning to main menu..."
	sleep 5
	clear
}

#Changes user's default login shell
chng_shell () {
	
	echo
	echo "Change user's default shell"
	echo
	read -p "Enter username: " user_name
	read -p "Enter shell path: (Must be absolute) " shell_path
	sudo usermod -s $shell_path $user_name
	if [ $? -ne 0 ] ; then
		echo "$0: Could not change shell." 1>&2
	else 
		echo "User's ($user_name) default shell has been changed. Path: $shell_path"
	fi
	sleep 2
	echo "Returning to main menu"
	sleep 5
	clear
}

#Changes expiration date for a user
chng_expir () {
	
	echo
	echo "Change user's expiration date"
	echo
	read -p "Enter username: " user_name
	read -p "Enter expiration date: (Must be YYYY-MM-DD)" expiry_date
	sudo usermod -e $expiry_date $user_name
	if [ $? -ne 0 ] ; then
		echo "$0 Could not change expiration date." 1>&2
	else
		echo "User's ($user_name) default expiration date has been changed to $expiry_date"
	fi
	sleep 2
	echo "Returning to main menu..."
	sleep 5
	clear
}

#quits the script
quit_script () {
	
	echo "Quitting Script"
	sleep 1
	echo "Goodbye!"
	sleep 1
	app_continue=0
	clear
	exit
}


#******Main******

while [ $app_continue -eq 1 ] ; do

menu
case $user_selection in
	a | A ) add_user ;;
	d | D ) del_user ;;
	e | E ) chng_expir ;;
	i | I ) chng_prim_group ;;
	l | L ) chng_shell ;;
	q | Q ) quit_script ;;
	s | S ) chng_supp_group ;;
	* ) echo "$0: Invalid input." 1>&2
	    sleep 1	;;
esac

done
