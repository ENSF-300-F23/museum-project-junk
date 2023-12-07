def execute_admin_choice(choice, conn):
    # Get a cursor
    cursor = conn.cursor()
        
    # Execute a query
    cursor.execute("USE MUSEUM")

    if choice == "1":
        print("")

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
        pass