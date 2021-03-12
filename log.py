import logging
import datetime

file_path = './logs/log_template.txt'

def generate_log_head(src_nm, process_id):
    log_list = []

    with open(file_path) as f:
        content = f.read()

    templt_list = content.split('####')
    for i in templt_list:
        log_list.append(i.strip())
    date_time = datetime.datetime.strftime(datetime.datetime.now(), '%Y-%m-%d %H:%M:%S')

    log_cont = '\n' + log_list[0]
    log_cont = log_cont.replace('$Script_nm$', src_nm)
    log_cont = log_cont + '\n\n' + log_list[1]
    log_cont = log_cont.replace('$process_nm$', 'DB')
    log_cont = log_cont.replace('$start_time$', date_time)
    log_cont = log_cont.replace('$process_id$', str(process_id))


    return log_cont

def generate_log_with_dt(input_str):
    date_time = datetime.datetime.strftime(datetime.datetime.now(), '%Y-%m-%d %H:%M:%S')
    log_cont = '\n' + date_time.ljust(5) + ': '+  input_str
    return log_cont