import pandas as pd
import json
from datetime import datetime
import requests
import os
from dotenv import load_dotenv

#Getting Keys
load_dotenv()

API_key = os.getenv('API_key')
from datetime import datetime, timedelta

def create_url(start_date,end_date,API_key):

        return ("https://api.nasa.gov/neo/rest/v1/feed?start_date={}&end_date={}&api_key={}".format(start_date,end_date,API_key),start_date)


def connect_to_endpoint(url):
    response = requests.request("GET", url)
    print(response.status_code)
    if response.status_code != 200:
        raise Exception(
            "Request returned an error: {} {}".format(
                response.status_code, response.text
            )
        )
    return response.json()


def main():
    num_periods = 100
    freq = '5D'
    dates_list = pd.date_range(end=datetime.now(), periods=num_periods, freq=freq)

# Iterate over pairs of dates
    for i in range(1, num_periods):
        start_date = dates_list[i].date().isoformat()
        end_date = dates_list[i - 1].date().isoformat()
        print("Downloading From: ", start_date, " - To:", end_date)
        url = create_url(start_date,end_date,API_key)
        json_response = connect_to_endpoint(url[0])
        with open('./result/' + url[1] + '-response.json', 'w') as f:
            json.dump(json_response, f)



if __name__ == "__main__":
    main()
