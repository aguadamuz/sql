#original

# Connect to an existing database
conn = psycopg2.connect("host=10.10.7.244 port=5439 dbname=db user=august password=Bubba1@@")

# Open a cursor to perform database operations
cur = conn.cursor()

# Query the database and obtain data as Python objects
cur.execute("SELECT letter_body, title, ask, description FROM events where created_locale = 'en-US' limit 99")
rows = cur.fetchall()

for row in rows:
  s = row[0] + row[1] + row[2] + row[3]
  print s

# Close communication with the database
cur.close()
conn.close()

exit()



#updated

import psycopg2
from langdetect import detect

# Connect to an existing database
conn = psycopg2.connect("host=10.10.7.244 port=5439 dbname=db user=andrew password=RedDwarf42")

# Open a cursor to perform database operations
cur = conn.cursor()

# Query the database and obtain data as Python objects
cur.execute("SELECT letter_body, title, ask, description, id FROM events where created_locale = 'en-US' limit 10")
rows = cur.fetchall()

for row in rows:
 s = ""
 for i in range(0, 4):
    a = row[i]
    if a is not None:
       s = s + " " + a

 petitionId = row[4]

 try:
    r = detect(s)
    if r <> 'en':
      print petitionId, r
 except Exception as e:
    continue

# Close communication with the database
cur.close()
conn.close()

exit()
