## Password Manager CLI

This is a simple password manager script written in Bash. It allows you to store and manage passwords for various websites or services. The script encrypts the password file using GPG, ensuring the security of your stored passwords. It is a work in progress.

## Features

- Generate random passwords or enter your own passwords.
- Add, view, and delete passwords for different websites or services.
- Encrypts the password file using AES256 encryption.
- Requires a master password to access and modify passwords.

## Prerequisites

To use this script, you need to have the following installed on your system:

- Bash shell
- OpenSSL
- GnuPG (GPG)

## Getting Started

Clone this repository to your local machine:
git clone https://github.com/your-username/password-manager.git

cd password-manager
Make the script executable: chmod +x password_manager.sh
Run the script: ./password_manager.sh

## Usage

Upon running the script, you will be presented with a menu of options:

- Add password: Allows you to add a new password for a website or service.
- View passwords: Displays a list of stored passwords.
- Delete password: Deletes a password for a specific website or service.
- Exit: Exits the script.
- For each option, you will be prompted for necessary inputs such as the website or service name, username, and master password.

## Security

The password file is encrypted using AES256 encryption and can only be decrypted with the master password provided by the user. The script utilizes GPG for encryption and decryption operations, ensuring the security of your passwords.

Note: It is important to remember your master password as it cannot be reset. Also, this is a learnign exercise and not for real world use for important passwords.

## License

This project is licensed under the ISC License - see the LICENSE file for details.

## Contributing

Contributions are always welcome! If you would like to contribute to this project, please create a pull request.
