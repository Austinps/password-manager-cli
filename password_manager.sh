#!/bin/bash

# This function generates a random password or prompts the user for a password
generate_password() {
    read -p "Enter password (or press enter to generate a random one): " password
    if [ -z "$password" ]; then
        password=$(openssl rand -base64 12)
    fi
    echo "$password"
}

# This function gets the master password from the user
get_master_password() {
    read -s -p "Enter master password: " MASTER_PASSWORD
    echo ""
    if [ -f passwords.enc ]; then
        PASSWORDS_ENC=$(cat passwords.enc)
        PASSWORDS=$(decrypt_password_file <<< "$PASSWORDS_ENC")
    fi
}


# This function encrypts the password file
encrypt_password_file() {
    echo "$PASSWORDS" | gpg --symmetric --cipher-algo AES256 --batch --yes --passphrase "$MASTER_PASSWORD" > passwords.enc
}

# This function decrypts the password file
decrypt_password_file() {
    echo "$PASSWORDS_ENC" | gpg --decrypt --batch --passphrase "$MASTER_PASSWORD"
}

# Check if passwords file exists, if not, create one
if [ -f passwords.enc ]; then
    get_master_password
    PASSWORDS_ENC=$(cat passwords.enc)
    PASSWORDS=$(decrypt_password_file)
else
    echo "No passwords found."
    get_master_password
fi

# Loop through options
while true; do
    echo "Select an option:"
    echo "1) Add password"
    echo "2) View passwords"
    echo "3) Delete password"
    echo "4) Exit"
    read -p "Enter option number: " option

    case $option in
        1)
            get_master_password
            read -p "Enter website or service name: " website
            read -p "Enter username: " username
            existing_password=$(grep -F "$website $username " <<< "$PASSWORDS" | cut -d' ' -f3)
            if [[ -n "$existing_password" ]]; then
                read -p "A password already exists for this website and username. Do you want to update it? [Y/n]: " update_choice
                if [[ $update_choice =~ ^[Yy]$ ]]; then
                    password=$(generate_password)
                    PASSWORDS=$(sed "s#$website $username $existing_password#$website $username $password#g" <<< "$PASSWORDS")
PASSWORDS_ENC=$(echo "$PASSWORDS" | gpg --symmetric --cipher-algo AES256 --batch --yes --passphrase "$MASTER_PASSWORD" | base64)
echo "Password updated."

                fi
            else
                password=$(generate_password)
                PASSWORDS="$PASSWORDS$website $username $password\n"
                echo "Password added."
            fi
            encrypt_password_file
            ;;
    2)
    if [ -z "${PASSWORDS:-}" ]; then
        echo "No passwords found."
    else
        get_master_password
        PASSWORDS=$(decrypt_password_file <<< "$PASSWORDS_ENC")
        echo "Website/Service   Username    Password"
        echo "----------------------------------------------------"
        printf '%s\n' "$PASSWORDS" | while read -r website username password; do
            printf "%s\t%s\t%s\n" "$website" "$username" "$password"
        echo ""
        done
    fi
    ;;
        3)
        get_master_password
        read -p "Enter website or service name: " website
        read -p "Enter username: " username
        existing_password=$(grep -F "$website $username " <<< "$PASSWORDS" | cut -d' ' -f3)
        if [[ -n "$existing_password" ]]; then
            PASSWORDS=$(sed "/^$website $username /d" <<< "$PASSWORDS")
            echo "Password deleted."
            encrypt_password_file
        else
            echo "No password found for website and username."
        fi
        ;;
    4)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo "Invalid option."
        ;;
esac
     done          


# Encrypt the password file before exiting
encrypt_password_file
