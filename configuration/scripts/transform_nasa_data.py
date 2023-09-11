# %%
import json
import pandas as pd
from datetime import datetime
import os
import glob
import plotly.express as px
import matplotlib.pyplot as plt
temp = pd.DataFrame()

path_to_json = '/home/ubuntu/etc/scripts/result/' 

json_pattern = os.path.join(path_to_json,'*.json')
file_list = glob.glob(json_pattern)
dfs = [] # an empty list to store the data frames
for file in file_list:
    data = pd.read_json(file, lines=True)
    dfs.append(data) # append the data frame to the list

temp = pd.concat(dfs, ignore_index=True) # concatenate all the
temp['near_earth_objects']
df = pd.DataFrame(temp['near_earth_objects'])
df.head()
new_df = pd.DataFrame(df['near_earth_objects'].tolist())

# Concatenate the new DataFrame with the original DataFrame
result_df = pd.concat([df, new_df], axis=1)

# Drop the original column containing dictionaries
result_df.drop(columns=['near_earth_objects'], inplace=True)

result_df = result_df.T[0]
df_1 = pd.DataFrame(result_df)
dates = df_1.index
transformed = pd.json_normalize(pd.json_normalize(result_df)[0])
transformed = transformed[['neo_reference_id', 'name', 'nasa_jpl_url',
       'absolute_magnitude_h', 'is_potentially_hazardous_asteroid',
       'close_approach_data', 'is_sentry_object','estimated_diameter.kilometers.estimated_diameter_min',
       'estimated_diameter.kilometers.estimated_diameter_max']]
transformed["delta"] = (transformed["estimated_diameter.kilometers.estimated_diameter_max"] + transformed["estimated_diameter.kilometers.estimated_diameter_min"])/2
transformed["delta"] = transformed["delta"].fillna(0)
transformed.to_csv('/home/ubuntu/etc/scripts/result/results.csv')
fig = px.scatter(x=transformed["name"], y=transformed["absolute_magnitude_h"], size=transformed["delta"])
fig.write_image("./newplot.png")

# %%
from IPython.display import Image
Image(filename='./newplot.png')


