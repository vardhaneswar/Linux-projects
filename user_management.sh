#!/bin/bash

LOG_FILE="/var/log/user_management.log"

# Function to create a new user
create_user() {
    read -p "Enter username: " username
    read -p "Enter group name: " groupname
    sudo groupadd "$groupname" 2>/dev/null
    sudo useradd -m -s /bin/bash -g "$groupname" "$username"
    echo "User $username created and added to group $groupname"
    
    # Set password
    sudo passwd "$username"
    
    # Logging
    echo "$(date) - User $username created in group $groupname" | sudo tee -a $LOG_FILE
}

# Function to delete a user
delete_user() {
    read -p "Enter username to delete: " username
    sudo userdel -r "$username"
    echo "User $username deleted"
    
    # Logging
    echo "$(date) - User $username deleted" | sudo tee -a $LOG_FILE
}

# Function to list all users
list_users() {
    echo "List of users:"
    awk -F':' '{ print $1 }' /etc/passwd
}

# Menu for user selection
while true; do
    echo "Choose an option:"
    echo "1. Create User"
    echo "2. Delete User"
    echo "3. List Users"
    echo "4. Exit"
    read -p "Enter your choice: " choice

    case $choice in
        1) create_user ;;
        2) delete_user ;;
        3) list_users ;;
        4) exit 0 ;;
        *) echo "Invalid option! Please try again." ;;
    esac
done
