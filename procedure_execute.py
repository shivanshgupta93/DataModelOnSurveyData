import os
import pandas as pd
import datetime
import logging
import traceback
from db import DB
from consts import SCHEMA_NAME, PROCEDURE_NAME
from log import generate_log_head, generate_log_with_dt

cycl_time_id = datetime.datetime.now().strftime('%Y%m%d')

load_dt = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')

def procedure_execute(time):
    '''i_log_file = './logs/' + 'Procedure_Execution_Logging' + '_' + cycl_time_id + '.txt'
    FORMAT = '%(message)s'
    logging.basicConfig(filename=i_log_file, level=logging.INFO, format=FORMAT)'''

    process_id = os.getpid()
    log_con = generate_log_head('Procedure Execution Logging', process_id)
    logging.info(log_con)

    db_obj = DB()
    con = db_obj.get_db()
    cur = con.cursor()

    schema = SCHEMA_NAME[time]

    for key, value in PROCEDURE_NAME.items():
        try:
            procedure_name = schema + '.' + value

            if time == 'old' and value == 'SP_DIM_COMMUNITY_HOSPITAL':
                continue

            procedure_sql = "EXECUTE " + procedure_name
            cur.execute(procedure_sql)

            con.commit()

            log_con = generate_log_with_dt('Successfully executed stored procedure ' + procedure_name)
            logging.info(log_con)
            print('\nSuccessfully executed stored procedure ' + procedure_name)

        except:
            e = str(traceback.format_exc())
            print(e)
            log_con = generate_log_with_dt('\nError ' + e + ' in running stored procedure ' + procedure_name)
            logging.info(log_con)
            return False

    ###con.close()
    return True