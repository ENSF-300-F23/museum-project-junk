def admin_update(conn):
    # Get a cursor
    cursor = conn.cursor()
        
    # Execute a query
    cursor.execute("USE MUSEUM")

    # Retrieve usernames and statuses from the USERS table
    select_users_query = "SELECT Username, Usr_password, Usr_role, Usr_status FROM USERS"
    cursor.execute(select_users_query)
    
    empty = cursor.fetchone()
    users = cursor.fetchall()

    for row in users:
        username = str(row[0])
        password = str(row[1])
        role =  str(row[2])
        status = str(row[3])
        querries = ''

        if status == "blocked":
            querries = f"""
            DROP USER IF EXISTS {username}@localhost;
            CREATE USER {username}@localhost IDENTIFIED WITH mysql_native_password BY {password};
            GRANT blocked@localhost TO {username}@localhost;
            SET DEFAULT ROLE ALL TO {username}@localhost; 
             """
        elif status == "suspended":
            querries = f"""
            DROP USER IF EXISTS {username}@localhost;
            CREATE USER {username}@localhost IDENTIFIED WITH mysql_native_password BY {password};
            GRANT guest@localhost TO {username}@localhost;
            SET DEFAULT ROLE ALL TO {username}@localhost; 
             """
        cursor.execute(querries)
        conn.commit()
        

def execute_admin_choice(choice, conn):
    # Get a cursor
    cursor = conn.cursor()
        
    # Execute a query
    cursor.execute("USE MUSEUM")

    print("")
    
    if choice == "1":
        while True:
            sql_command = input("Enter SQL command ('q' to quit): ")
            if sql_command.lower() == 'q':
                break

            cursor.execute(sql_command)
            if cursor.description is not None:
                rows = cursor.fetchall()
                for row in rows:
                    print(row)  # Display fetched rows for SELECT queries

            conn.commit()  # Commit changes

    
    elif choice == "2":
        # Get file path input from the user
        file_path = input("Enter the file path to the SQL file: ")

        try:
            with open(file_path, 'r') as sql_file:
                sql_commands = sql_file.read()

                # Split SQL commands by semicolon
                commands_list = sql_commands.split(';')

                for command in commands_list:
                    cursor.execute(command)
                    conn.commit()

            print("\nSQL commands executed successfully from the file.\n")

        except FileNotFoundError:
            print("\nFile not found. Please enter a valid file path.")
        except Exception as e:
            print(f"Error: {e}")

    elif choice == "3":
        keep_going = True
        while(keep_going):
            print("\nIn order to proceed please select option:")
            print("1 - Add user")
            print("2 - Remove user")
            print("3 - Manage users")
            print("q - Quit")

            choice = input("\nEnter your choice: ")

            while choice not in ["1", "2", "3", "q"]:
                choice = input("Enter your choice: ")

            if (choice.lower() == 'q'):
                keep_going = False

            
            if choice == "1":
                print("")

                username = input("Enter username to be added: ") or None

                while username == None or username[0] == " ":
                    username = input("Enter username to be added: ") or None

                password = input("Enter password: ")

                role = input("Enter role (employee, guest): ")
                while role not in ["employee", "guest"]:
                    role = input("Enter username to be added: ") or None

                status = input("Enter status (active, suspended, blocked): ")
                while status not in ["active", "suspended", "blocked"]:
                    status = input("Enter username to be added: ") or None
                
                add_usr = f"""
                DROP USER IF EXISTS '{username}'@'localhost';
                CREATE USER '{username}'@'localhost' IDENTIFIED BY '{password}';
                GRANT '{role}'@'localhost' TO '{username}'@'localhost';
                """

                cursor.execute(add_usr, multi=True)
                conn.commit()

                sql = "INSERT INTO USERS (Username, Usr_password, Usr_role, Usr_status) VALUES (%s, %s, %s, %s)"
                values = (username, password, role, status)

                # Execute the query
                cursor.execute(sql, values)

                # Commit changes to the database
                conn.commit()
                print("User added successfully!\n")

            elif choice == "2":
                # SQL query to remove user from USERS table
                username = input("Enter username: ")

                # Remove user from table
                delete_user_query = "DELETE FROM USERS WHERE Username = %s"
                user_values = (username,)

                # Execute the query to remove the user from USERS table
                cursor.execute(delete_user_query, user_values)

                # Revmove user from database
                delete_user_query = "DROP USER IF EXISTS '{username}'@'localhost';"

                # Execute the query to remove the user from USERS table
                cursor.execute(delete_user_query)

                # Commit changes to the database
                conn.commit()
                print(f"User '{username}' removed successfully!\n")
            
            elif choice == "3":
                print("")

                choice = input("Change user status or role (s or r): ")

                while choice not in ["s", "r"]:
                    choice = input("Change user status or role (s or r): ")

                if choice == "s":
                    # SQL query to update user's role based on the username and new status

                    username = input("Enter username: ")

                    new_status = input("Enter new status (active, blocked, suspended): ")

                    while new_status not in ["active", "blocked", "suspended"]:
                        new_status = input("Change user status or role (s or r): ")

                    if new_status != "active":
                        if new_status == 'blocked':
                            new_role = 'blocked@localhost'

                        elif new_status == 'suspended':
                            new_role = 'guest@localhost'

                        sql = "UPDATE USERS SET Usr_role = %s, Usr_status = %s WHERE Username = %s"
                        values = (new_role, new_status, username)

                    
                    else:
                        sql = "UPDATE USERS SET Usr_status = %s WHERE Username = %s"
                        values = (new_status, username)

                    # Execute the query
                    cursor.execute(sql, values)

                    # Commit changes to the database
                    conn.commit()
                    print("User status updated successfully!\n")
                
                if choice == "r":
                    # SQL query to update user's role based on the username and new status

                    username = input("Enter username: ")

                    new_role = input("Enter new status (db_manager, employee, guest, blocked): ")
 
                    while new_role not in ["db_manager", "employee", "guest", "blocked"]:
                        new_role = input("Enter new status (db_manager, employee, guest, blocked): ")

                    sql = "UPDATE USERS SET Usr_role = %s WHERE Username = %s"
                    values = (new_role + '@localhost', username)

                    # Commit changes to the database
                    conn.commit()
                    print("User role updated successfully!\n")




