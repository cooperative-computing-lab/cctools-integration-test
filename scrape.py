import requests
from bs4 import BeautifulSoup

URL = "https://cctools.readthedocs.io/en/stable/taskvine/"
page = requests.get(URL)

soup = BeautifulSoup(page.content, "html.parser")

section = soup.find("div", class_ = "section")
highlights = section.find_all("pre", class_="highlight")

f = open('quickstart.py','a')

#scraping for 'quickstart.py'
i = 0
for highlight in highlights:
    if i == 2:
        f.write(highlight.text)
        break
    i = i+1

f.close()
f = open('conda-inst.sh', 'a')
 
#scrape for ndcctools install  
i = 0
for highlight in highlights:
    if i == 1:
        f.write(highlight.text + " -y")
        break
    i = i+1

#scrape for 'python quickstart.py'
f.close()
f = open('run-python.sh', 'a')
    
i = 0
for highlight in highlights:
    if i == 3:
        f.write(highlight.text)
        break
    i = i+1

