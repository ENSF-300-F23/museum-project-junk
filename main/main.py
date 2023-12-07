import mysql.connector
from mysql.connector import errorcode


if __name__ == "__main__":

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

        except mysql.connector.Error as err:
            attempts -= 1
            if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
                print("Something is wrong with your user name or password")
            else:
                print(err)
            print('')

        else:
            cnx.close()

    # If number of attempts are exceeded
    print("Number of attempts exceeded")
    print("\nProgram terminated")