#!/bin/csh
#Script name: phonebook.csh 

#File where the phonebook will be stored
set filename = "phonebook.txt"

#Program
while (1)
    #display menu to user
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
    set choice = "$<"

    switch ($choice)
        case 1:
            #Insert a new record
            printf "\nEnter new record as the following: FirstName LastName:Phone:Mobile:Address:BirthDate:Salary):"
            set input = "$<"

            #Parse fields
            set name = `echo "$input" | awk -F: '{print $1}'`
            set phone = `echo "$input" | awk -F: '{print $2}'`
            set mobile = `echo "$input" | awk -F: '{print $3}'`
            set address = `echo "$input" | awk -F: '{print $4}'`
            set birthdate = `echo "$input" | awk -F: '{print $5}'`
            set salary = `echo "$input" | awk -F: '{print $6}'`

            #Validate that fields are given
            if ("$name" == "" || "$phone" == "" || "$mobile" == "" || "$address" == "" || "$birthdate" == "" || "$salary" == "" ) then
                echo "Error. Please input correct format."
                continue
            endif

            #Append record to phonebook text file
            echo "$input" >> $filename
            sort -t: -k1,1 $filename -o $filename
            echo "Record has been added to phonebook."
            breaksw 
        case 2:
            #Delete a Record 
            printf "\nPlease enter a mobile phone number or last name to delete:"
            set search = "$<"
            grep -v "$search" $filename >! $filename.tmp  
            mv $filename.tmp $filename
            
            printf "\nRecord has been deleted." 
            breaksw
        case 3: 
            #List Records by first name
            echo "\nRecords listed by first name:"
            sort -t: -k1,1 $filename | cat  
            breaksw
        case 4: 
            #List Records by last name
            echo "\nRecords listed by first name:"
            sort -t: -k1,1 $filename | awk -F: '{split($1, name, " "); print name[2] ":" $0}' | sort -t: -k1,1 | cut -d: -f2-  
            breaksw
        case 5:
            #List records in reverse alphabetical order by first name" 
            echo "\nRecords listed in reverse alphabetical order by first name:"
            sort -r -t: -k1,1 $filename | cat  
            breaksw
        case 6:
            #List records in reverse alphabetical order by last name
            echo "\nRecords listed in reverse alphabetical order by last name:"
            sort -t: -k1,1 $filename | awk -F: '{split($1, name, " "); print name[2] ":" $0}' | sort -r -t: -k1,1 | cut -d: -f2-  
            breaksw
        case 7: 
            #Search for record by last name
            echo "\nPlease enter the last name to search for:"
            set lastName = "$<"
            grep -i "$lastName" $filename || echo "No records found with that last name." 
            breaksw
        case 8: 
            #Search for record by birth month or year
            echo "\nPlease enter the birth month(M or MM) or year to search (YY):"
            set searchMY = "$<"

            set found = 0
            foreach record (`cat $filename | sed 's/ /@/g'`)
                set record = `echo $record | sed 's/ /@/g'`

                set birthdate = `echo "$record" | awk -F: '{print $5}'` #Get the birth date field 

                if ("$birthdate" == "") then #If the birth date is not given then it will skip
                    continue
                endif

                #Get the birth month and year
                set month = `echo "$birthdate" | awk -F/ '{print $1}'`
                set year = `echo "$birthdate" | awk -F/ '{print $3}'`

                #See if the user input matches 
                if ("$month" == "$searchMY" || "$year" == "$searchMY") then
                    echo "\nRecord(s) based on month or year: $record"
                    set found = 1
                endif
            end

            #If user input doesnt match
            if ($found == 0) then
                echo "\nNo records with that birth month or year."
            endif 
            breaksw
        case 9:
            #Exit program
            echo "Exited program." 
            exit
            breaksw
        default:
            #Invalid choice 
            echo "Invalid choice. Please select an option from the menu."
            breaksw
    endsw
end

