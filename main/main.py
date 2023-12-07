from admin import execute_admin_choice
from employee import execute_employee_choice
from guest import execute_guest_choice

import mysql.connector
from mysql.connector import errorcode

def check_role(usr_name, conn, role_to_check):

    cursor = conn.cursor()
    cursor.execute(f"SHOW GRANTS FOR '{usr_name}'@'localhost';")
    grants = cursor.fetchall()
    roles = set()

    for grant in grants:
        if grant[0].startswith('GRANT'):
            role = grant[0].split()[1]
            roles.add(role)

    #print(f"User '{usr_name}' has the following roles: {', '.join(roles)}")

    if role_to_check in roles:
        #print(f"User '{usr_name}' has the role '{role_to_check}'")
        return True
    else:
        #print(f"\nUser '{usr_name}' does not have the role '{role_to_check}'\n")
        return False

if __name__ == "__main__":
    # Get username
    username = ""
    
    # Checks if it is the correct role for that user
    back_to_main = True

    while back_to_main:
        # Login menu
        print("Welcome to the Museum Database:")
        print("In order to proceed please select your role from the list below:")
        print("1 - DB Admin")
        print("2 - Employee")
        print("3 - Browse as guest")

        # User's choice
        selection = input("\nPlease type 1, 2, or 3 to select your role: ")

        while selection not in ["1", "2", "3"]:
            selection = input("Please type 1, 2, or 3 to select your role: ")

        # Connect with database
        attempts = 5
        while attempts:
            try:
                # Get login details
                if selection in ["1", "2"]:
                    username = input("Username: ")
                    passcode = input("Password: ")
                else:
                    username = 'guest'
                    passcode = None

                cnx = mysql.connector.connect(user=username, password=passcode,
                                            host='127.0.0.1',
                                            database='MUSEUM')
                
                is_role = check_role(username, cnx, "`db_admin`@`localhost`")

            except mysql.connector.Error as err:
                attempts -= 1
                if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
                    print("Something is wrong with your user name or password")
                else:
                    print(err)
                print('')

            else:

                # Main menu

                # Admin option
                if selection == "1" and check_role(username, cnx, "`db_admin`@`localhost`"):
                    back_to_main = False

                    keep_going = True
                    while(keep_going):
                        print(f"\nWelcome {username}\n")
                        print("In order to proceed please select option:")
                        print("1 - Enter SQL commands")
                        print("2 - Load sql file")
                        print("3 - Manage users")
                        print("q - Quit")

                        choice = input("\nEnter your choice: ")

                        while choice not in ["1", "2", "3", "q"]:
                            choice = input("Enter your choice: ")

                        if (choice.lower() == 'q'):
                            keep_going = False
                        
                        keep_going = execute_admin_choice(choice, cnx)
                
                # Employee option
                elif selection == "2" and check_role(username, cnx, "`employee`@`localhost`"):
                    back_to_main = False

                    keep_going = True
                    while(keep_going):
                        print(f"\nWelcome {username}\n")
                        print("In order to proceed please select option:")
                        print("1 - Add art piece")
                        print("2 - Update art piece")
                        print("3 - Remove art piece")
                        print("q - Quit")

                        choice = input("\nEnter your choice: ")

                        while choice not in ["1", "2", "3", "q"]:
                            choice = input("Enter your choice: ")

                        if (choice.lower() == 'q'):
                            keep_going = False
                        
                        keep_going = execute_employee_choice(choice, cnx)

                # Guest option
                elif selection == "3" and check_role(username, cnx, "`guest_usr`@`localhost`"):
                    back_to_main = False

                    keep_going = True
                    while(keep_going):
                        print(f"\nWelcome {username}\n")
                        print("In order to proceed please select option:")
                        print("1 - View art piece(s) details")
                        print("2 - View exhibition(s)")
                        print("q - Quit")

                        choice = input("\nEnter your choice: ")

                        while choice not in ["1", "2", "q"]:
                            choice = input("Enter your choice: ")
                        
                        if (choice.lower() == 'q'):
                            keep_going = False
                        
                        execute_guest_choice(choice, cnx)
                
                # None of the roles
                else:
                    print("Wrong role, please try again \n")
                    back_to_main = True
                    break
                
                cnx.close()

                # End program second loop done (interfaces selection)
                break

        # If number of attempts are exceeded
        if attempts == 0:
            print("Number of attempts exceeded")
            print("\nProgram terminated")