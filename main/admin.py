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

            print("SQL commands executed successfully from the file.")

        except FileNotFoundError:
            print("File not found. Please enter a valid file path.")
        except Exception as e:
            print(f"Error: {e}")

        print("\n")

    elif choice == "3":
        keep_going = True
        while(keep_going):
            print("In order to proceed please select option:")
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
                GRANT role_name TO '{role}'@'localhost';
                """

                cursor.execute(add_usr)
                conn.commit()

                sql = "INSERT INTO USERS (Username, Usr_password, User_role, Usr_status) VALUES (%s, %s, %s, %s)"
                values = (username, password, role, status)

                # Execute the query
                cursor.execute(sql, values)

                # Commit changes to the database
                conn.commit()
                print("User added successfully!")

