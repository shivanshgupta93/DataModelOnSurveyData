import sys
from load import load_data
from extract import extract_data
from procedure_execute import procedure_execute
from consts import LOAD_SURVEY_TYPES

def main():
  result = False
  time = sys.argv[1]

  for key, value in LOAD_SURVEY_TYPES.items():
    result = load_data(value, time)
    if not result:
      print("\nExecution of Data Load of " + value + " Failed")
      break
  
  if result:
    ("\nExecution of Data Load Successful")
    result = procedure_execute(time)
    if result:
      print("\nExecution of Stored Procedures Successful")
      result = extract_data(time)
      if result:
        print("\nExecution of Data Extract Successful")
        print("\nExecution for " + time + " is Completed")
      elif not result:
        print("\nExecution of Data Extract Failed")
    elif not result:
      print("\nExecution of Stored Procedures Failed")
  
if __name__== "__main__":
  main()