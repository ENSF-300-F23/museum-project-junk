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