#!/bin/bash 
#Script name: phonebook.bash 

#File where the phonebook will be stored
filename="phonebook.txt"

#Function to insert a record
insertRecord() {
    printf "\nEnter new record as the following: FirstName LastName:Phone:Mobile:Address:BirthDate:Salary):"
    read -r input
    IFS=: read -r name phone mobile address birthdate salary <<<"$input"

    #Validation for phone numbers
    if [[ ! "$phone" =~ ^[0-9]{3}-[0-9]{3}-[0-9]{4}$ || ! "$mobile" =~ ^[0-9]{3}-[0-9]{3}-[0-9]{4}$ ]]; then
        echo "Invalid format. Please enter phone number as xxx-xxx-xxxx."
        return
    fi

    #Get zip code and validate zip code
    zip="${address##* }"
    if [[ ! "$zip" =~ ^[0-9]{5}$ ]]; then
        echo "Error. Please enter a 5 digit zip code." 
        return
    fi

    echo "$input" >>"$filename"
    sort -t: -k1 "$filename" -o "$filename"
    printf "\nRecord inserted in sorted list.\n"
}

#Function to delete a record (mobile phone number or last name)
deleteRecord() {
    printf "\nPlease enter a mobile phone number or last name to delete:"
    read -r input
    grep -v "$input" "$filename" >"$filename.temp" && mv "$filename.temp" "$filename"
    printf "\nRecord has been deleted."
}

#Function to search for a record by last name or birth year or month  
searchForRecord() {
    printf "\nPlease enter a last name or birth year or month: "
    read -r input
    grep -i "$input" "$filename" || echo "Record not found."
}

#Function to display menu to user
menu() {
    printf "\nMenu\n"
    echo "(1) Insert record"
    echo "(2) Delete record"
    echo "(3) List records by first name"
    echo "(4) List records by last name"
    echo "(5) List records in reverse alphabetical order by first name"
    echo "(6) List records in reverse alphabetical order by last name"
    echo "(7) Search for record by last name"
    echo "(8) Search for record by birth month or year"
    echo "(9) Exit"
    printf "\nPlease select an option (enter the number): "
}

#Program
while true; do
    menu
    read -r choice
    case $choice in
        1) insertRecord 
        ;;
        2) deleteRecord
        ;;
        3) sort -t: -k1 "$filename" | cat
        ;;
        4) sort -t: -k2 "$filename" | cat
        ;;
        5) sort -r -t: -k1 "$filename" | cat
        ;;
        6) sort -r -t: -k2 "$filename" | cat
        ;;
        7) searchForRecord
        ;;
        8) searchForRecord
        ;;
        9) echo "Exited program."; sort -t: -k1 "$filename" -o "$filename"; exit
        ;;
        *) echo "Invalid choice. Please select an option from the menu."
        ;;
    esac
done

