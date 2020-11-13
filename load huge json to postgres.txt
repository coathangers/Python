#load JSON file 10,000 rows at a time, where JSON records are converted to rows in postgres database
#REQUIRES: pip install psycopg2-binary

import sys
import json
import psycopg2
rows = 0
with open(sys.argv[1]) as my_file: #(SEE LINE 29)
    data = json.load(my_file)

print("file loaded")
with psycopg2.connect("dbname=XXXX user=YYYY password=ZZZZ") as conn: #REQUIRES POSTGRES DATABASE CREDENTIALS
    with conn.cursor() as cur:
        cur.execute(""" drop table TABLENAME; create table TABLENAME(
            COLUMN1 type, COLUMN2 type, COLUMN3 type) """) #REQUIRES SQL TABLE NAMES AND DATA TYPE TO MATCH JSON FILE (SEE POSTGRES DATABASE LOAD)
print("finished creating tables")
chunks = [data[x:x+10000] for x in range(0, len(data), 10000)]
for item in chunks:
    with psycopg2.connect("dbname=XXXX user=YYYY password=ZZZZ") as conn: #REQUIRES POSTGRES DATABASE CREDENTIALS
        with conn.cursor() as cur:
            query_sql = """ insert into TABLENAME #REQUIRES TABLE NAME
            select * from json_populate_recordset(NULL::TABLENAME, %s) """
            cur.execute(query_sql, (json.dumps(item),))
            rows += 1
            if (rows % 10) == 0:
                print("inserted another 100,000 rows")

#print(json_data[10:])
#execute with: python NAME.py "D:\.....json" #(ADD THE PATH TO YOUR JSON FILE)
