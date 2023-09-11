import mysql.connector
import os
import pandas as pd
from sqlalchemy import create_engine
from dotenv import load_dotenv

#Getting Keys
load_dotenv()

db_user = os.getenv('db_user')
db_password = os.getenv('db_password')
db_host = os.getenv('db_host')
db_port = os.getenv('db_port')
db_name = os.getenv('db_name')

mydb = mysql.connector.connect(
  host= db_host,
  user= db_user,
  password= db_password,
  port = db_port,
  database="MySQL1Database",
)

mycursor = mydb.cursor()
try:
    mycursor.execute("CREATE TABLE nasa (neo_reference_id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(255), nasa_jpl_url VARCHAR(255), absolute_magnitude_h VARCHAR(255),is_potentially_hazardous_asteroid VARCHAR(255), close_approach_data VARCHAR(255))")
except Exception:
  pass
  
df = pd.read_csv('/home/ubuntu/etc/scripts/result/results.csv')
df = df[["neo_reference_id","name", "nasa_jpl_url", "absolute_magnitude_h","is_potentially_hazardous_asteroid","close_approach_data"]]
engine = create_engine("mysql+pymysql://" + db_user + ":" + db_password + "@" + db_host + "/" + db_name)

try:
  df.to_sql('nasa', con = engine, if_exists = 'append',index = False, chunksize = 1000)
except Exception:
  pass

mycursor.execute("SELECT * FROM MySQL1Database.nasa LIMIT 1")
result = mycursor.fetchall()