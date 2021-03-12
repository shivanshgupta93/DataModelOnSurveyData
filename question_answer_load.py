import sys
import pandas as pd
from db import DB

def question_answers():

    db_obj = DB()
    con = db_obj.get_db()
    cur = con.cursor()

    filename = 'questions_answers_list.xlsx'
    table_name = 'generic.question_answers_list'

    columns_query = ''
    values_query = ''

    data = pd.read_excel('./staticfiles/' + filename, header=None)
    data.head(5)
    data.fillna('N/A', inplace=True)
    data = data.astype(str)
    records = data.apply(tuple, axis=1).tolist()
    num_rows, num_columns = data.shape

    check_data_query = "SELECT COUNT(1) FROM " + table_name
    cur.execute(check_data_query)
    data_count = cur.fetchone()
    print('There are ' + str(data_count[0]) + ' rows in table ' + table_name)

    if data_count[0] != 0:
        delete_query = 'DELETE FROM ' + table_name 
        cur.execute(delete_query)
        con.commit()
        print('Deleted ' + str(data_count[0]) + ' rows in table ' + table_name)
    
    if data_count[0] == 0:
        print('Data deletion is not required for table ' + table_name)
    
    insert_query = 'INSERT INTO ' + table_name + '(TABLE_NAME, QUESTION_HEADING, QUESTION, ANSWER) VALUES (?,?,?,?)'
    print(insert_query)

    cur.executemany(insert_query, records)

    con.commit()

    print('\nInserted ' + str(num_rows) + ' rows into ' + table_name)
    db_obj.close()


def main():
  ###name = sys.argv[1]
  question_answers()
  
if __name__== "__main__":
  main()