import streamlit as st
import mysql.connector
import pandas as pd

Connection = mysql.connector.connect(
    host=st.secrets["host"],
    database=st.secrets["database"],
    user=st.secrets["user"],
    password=st.secrets["password"],
    port=st.secrets["port"])

cursor = Connection.cursor()

st.title("Task6 Trzeciak Agnieszka")
st.set_page_config(layout="wide")


col1, col2 = st.columns(2)

N = col1.text_input(label = 'Number of fake IDs', value=50)
Seed = col1.text_input(label = 'Seed (int)', value=1)

Locale = col2.selectbox(label = 'Locale', options = ['English','Polish'])
Gender = col2.selectbox(label = 'Gender', options = ['Male','Female'])

try:
    N = int(N)
except:
    N = 1
if N>100000:
    N = 10000

try:
    Seed = int(Seed)
except:
    Seed = 1

if Locale == 'English':
    Locale = 'ENG'
else:
    Locale = 'PL'

if Gender == 'Male':
    Gender = 'M'
else:
    Gender = 'F'
    
st.divider()
TEMP, col, TEMP = st.columns([1,4,1])
if col.button(label='Generate fake IDs',width='stretch'):
    df = pd.read_sql(f"CALL Final({N},{Seed},'{Locale}','{Gender}')", con=Connection)
    st.write(df)

