import os
import pandas as pd
import datetime
import logging
import traceback
from db import DB
from consts import NEW_FILE_NAME, OLD_FILE_NAME, SCHEMA_NAME
from log import generate_log_head, generate_log_with_dt

cycl_time_id = datetime.datetime.now().strftime('%Y%m%d')

load_dt = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')

def load_data(survey, time):
    i_log_file = './logs/' + time.title() + '_Survey_Data_Logging' + '_' + cycl_time_id + '.txt'
    FORMAT = '%(message)s'
    logging.basicConfig(filename=i_log_file, level=logging.INFO, format=FORMAT)

    process_id = os.getpid()
    log_con = generate_log_head('Data Load Logging', process_id)
    logging.info(log_con)

    db_obj = DB()
    con = db_obj.get_db()
    cur = con.cursor()

    filename = ''
    generic_tablename = ''
    columns_query = ''
    values_query = ''

    if time.lower() == 'old':
        filename = OLD_FILE_NAME[survey]
        log_con = generate_log_with_dt('Filename: ' + filename)

    elif time.lower() == 'new':
        filename = NEW_FILE_NAME[survey]
        log_con = generate_log_with_dt('Filename: ' + filename)

    else:
        log_con = generate_log_with_dt('Wrong Input')
    
    logging.info(log_con)

    generic_tablename = '[' + SCHEMA_NAME['generic'] + '].[' + time + '_' + survey + '_survey]'
    extension = filename.split(".")[1]

    if extension == 'xlsx':
        data = pd.read_excel('./sourcefiles/' + survey + '/' + filename)
    if extension == 'csv':
        data = pd.read_csv('./sourcefiles/' + survey + '/' + filename, error_bad_lines=False, index_col=False, dtype='unicode')

    data['insert_date'] = datetime.datetime.now().date()
    data.fillna('', inplace=True)
    data = data.astype(str)
    records = data[1:].apply(tuple, axis=1).tolist()
    num_rows, num_columns = data[1:].shape


    for column_num in range( 1, num_columns ):
        columns_query = columns_query + 'COLUMN' + str(column_num) + ','
        values_query = values_query + '?,'

    columns_query = columns_query + 'INSERT_DATE'
    values_query = values_query + '?'

    check_data_query = 'SELECT COUNT(1) FROM ' + generic_tablename
    cur.execute(check_data_query)
    data_count = cur.fetchone()
    log_con = generate_log_with_dt('There are ' + str(data_count[0]) + ' rows in table ' + generic_tablename)
    logging.info(log_con)

    if data_count[0] != 0:
        delete_query = 'DELETE FROM ' + generic_tablename
        cur.execute(delete_query)
        con.commit()
        log_con = generate_log_with_dt('Deleted ' + str(data_count[0]) + ' rows in table ' + generic_tablename)
        logging.info(log_con)
    
    if data_count[0] == 0:
        log_con = generate_log_with_dt('Data deletion is not required for table ' + generic_tablename)
        logging.info(log_con)
    
    insert_query = 'INSERT INTO ' + generic_tablename + '(' + columns_query + ') VALUES (' + values_query + ')'

    cur.executemany(insert_query, records)

    con.commit()
    log_con = generate_log_with_dt('Inserted ' + str(num_rows) + ' rows into ' + generic_tablename)
    logging.info(log_con)
    print('\nInserted ' + str(num_rows) + ' rows into ' + generic_tablename)
    ##con.close()

    return True

    

    

