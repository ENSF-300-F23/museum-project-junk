def execute_guest_choice(choice, conn):
    # Get a cursor
    cursor = conn.cursor()
        
    # Execute a query
    cursor.execute("USE MUSEUM")

    if choice == "1":
        art_id = input("Enter the art piece id (Press enter to display all): ") or None

        if art_id == None:
            query = f"""
            SELECT * FROM ART_OBJECT;
            """
            cursor.execute(query)
            rows = cursor.fetchall()

            col_names=cursor.column_names

            print("")
            print('{:>100s}'.format("------ Details about each art piece ------\n"))
            for col in col_names:
                if str(col) == "Art_descr":
                    continue
                else:
                    print("{0:<22s}".format(str(col)), end='')

            print("\n")

            desc = []
            for row in rows:
                col_i = 0
                for col in row:
                    if col_i == 4:
                        desc.append(str(row[4]))
                    else:
                        print("{0:<22s}".format(str(col)[0:20]), end='')
                    
                    col_i += 1
                print("")
            
            print("\n------ Description for each art piece ------ \n")
            print("{0:<20s}".format("Art_Object_ID"), "{0:<30s}".format("Description"))
            row_i = 0
            for row in rows:
                print("{0:<20s}".format(row[0]), "{0:<30s}".format(desc[row_i][0:30]))
                row_i += 1
        
        else:
            query = f"""
            SELECT * FROM ART_OBJECT WHERE Id_no = '{art_id}';
            """
            cursor.execute(query)
            rows = cursor.fetchall()

            col_names=cursor.column_names

            print("")
            print('{:>100s}'.format("------ Details about art piece ------\n"))
            for col in col_names:
                if str(col) == "Art_descr":
                    continue
                else:
                    print("{0:<22s}".format(str(col)), end='')

            print("\n")

            desc = []
            for row in rows:
                col_i = 0
                for col in row:
                    if col_i == 4:
                        desc.append(str(row[4]))
                    else:
                        print("{0:<22s}".format(str(col)[0:20]), end='')
                    
                    col_i += 1
                print("")
            
            print("\n------ Description of art piece ------ \n")
            print("{0:<20s}".format("Art_Object_ID"), "{0:<30s}".format("Description"))
            row_i = 0
            for row in rows:
                print("{0:<20s}".format(row[0]), "{0:<30s}".format(desc[row_i][0:30]))
                row_i += 1


    elif choice == "2":
        ex_name = input("Enter the exhibition name (Press enter to display all): ") or None

        
        if ex_name == None:
            query = f"""
            SELECT * FROM EXHIBITIONS;
            """
            cursor.execute(query)
            rows = cursor.fetchall()

            col_names=cursor.column_names

            print("")
            print('{:<60s}'.format("------ Details about each Exhibition ------\n"))
            for col in col_names:
                print("{0:<22s}".format(str(col)), end='')

            print("\n")

            desc = []
            for row in rows:
                col_i = 0
                for col in row:
                    print("{0:<22s}".format(str(col)[0:20]), end='')
                    
                    col_i += 1
                print("")

            print("\n")

            query = f"""
            SELECT DI.art_Id_no, E.E_name
            FROM EXHIBITIONS E
            INNER JOIN DISPLAYED_IN DI ON E.E_name = DI.Exhibition_name;;
            """
            cursor.execute(query)
            rows = cursor.fetchall()

            col_names=cursor.column_names

            print("")
            print('{:<60s}'.format("------ Exhibition name for art piece ------\n"))
            for col in col_names:
                print("{0:<22s}".format(str(col)), end='')

            print("\n")

            desc = []
            for row in rows:
                col_i = 0
                for col in row:
                    print("{0:<22s}".format(str(col)[0:20]), end='')
                    
                    col_i += 1
                print("")

            print("\n")


        
        else:
            query = f"""
            SELECT * 
            FROM EXHIBITIONS 
            WHERE E_name = '{ex_name}';
            """
            cursor.execute(query)
            rows = cursor.fetchall()

            col_names=cursor.column_names

            print("")
            print('{:<60s}'.format("------ Details about each Exhibition ------\n"))
            for col in col_names:
                print("{0:<22s}".format(str(col)), end='')

            print("\n")

            desc = []
            for row in rows:
                col_i = 0
                for col in row:
                    print("{0:<22s}".format(str(col)[0:20]), end='')
                    
                    col_i += 1
                print("")

            print("\n")

            query = f"""
            SELECT DI.art_Id_no, E.E_name
            FROM EXHIBITIONS E
            INNER JOIN DISPLAYED_IN DI ON E.E_name = '{ex_name}';
            """
            cursor.execute(query)
            rows = cursor.fetchall()

            col_names=cursor.column_names

            print("")
            print('{:<60s}'.format("------ Exhibition name for art piece ------\n"))
            for col in col_names:
                print("{0:<22s}".format(str(col)), end='')

            print("\n")

            desc = []
            for row in rows:
                col_i = 0
                for col in row:
                    print("{0:<22s}".format(str(col)[0:20]), end='')
                    
                    col_i += 1
                print("")

            print("\n")

        
        