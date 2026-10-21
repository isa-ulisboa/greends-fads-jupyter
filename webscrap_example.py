import pandas as pd 
import requests 
from bs4 import BeautifulSoup 

url = "https://en.wikipedia.org/wiki/List_of_countries_by_forest_area" 
headers = {"User-Agent": "Mozilla/5.0"} 
response = requests.get(url, headers=headers) 

if response.status_code == 200: 
    soup = BeautifulSoup(response.text, "html.parser") 
    table = soup.find("table", {"class": "wikitable"}) 

    print(table)
    
    data = [] 
    for row in table.find_all("tr")[1:]: # skip header 
        cols = [ele.text.strip() for ele in row.find_all(["td", "th"])] 
        if len(cols) >= 3: 
            data.append({"Country": cols, "Forest\_Area\_sq\_km": cols[5]}) 
            
    df = pd.DataFrame(data) 
    print(df.head())

