import os
import pandas as pd
import datetime
import logging
import traceback
from db import DB
from consts import SCHEMA_NAME, EXTRACT_FILE_NAME, TABLE_NAME
from log import generate_log_head, generate_log_with_dt

cycl_time_id = datetime.datetime.now().strftime('%Y%m%d')

load_dt = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')

def extract_data(time):
    '''i_log_file = './logs/' + 'Data_Extract_Logging' + '_' + cycl_time_id + '.txt'
    FORMAT = '%(message)s'
    logging.basicConfig(filename=i_log_file, level=logging.INFO, format=FORMAT)'''

    process_id = os.getpid()
    log_con = generate_log_head('Data Extract Logging', process_id)
    logging.info(log_con)

    db_obj = DB()
    con = db_obj.get_db()
    cur = con.cursor()

    filename = EXTRACT_FILE_NAME[time]
    schema = SCHEMA_NAME[time]

    excel_writer = pd.ExcelWriter('./extractfiles/' + time + '/' + filename, engine='xlsxwriter')

    for key, value in TABLE_NAME.items():

        tablename = schema + '.' + value
        sheetname = key
        
        if time == 'old' and value == 'Vw_DimCommunity':
            continue
        
        select_query = 'SELECT * FROM ' + tablename

        data = pd.read_sql(select_query, con)
        num_rows, num_columns = data.shape

        con.commit()
        log_con = generate_log_with_dt('Fetched ' + str(num_rows) + ' rows from ' + tablename)
        logging.info(log_con)
        print('\nFetched ' + str(num_rows) + ' rows from ' + tablename)

        data.to_excel(excel_writer, sheet_name = sheetname, encoding='utf-8', index=None)
        log_con = generate_log_with_dt('Created sheet ' + sheetname + ' in file ' + filename + ' from table ' + tablename)
        logging.info(log_con)
        print('Created sheet ' + sheetname + ' in file ' + filename + ' from table ' + tablename)

    ##con.close()
    excel_writer.save()

    return True

    

    

