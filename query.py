import re

import requests
from bs4 import BeautifulSoup


def extractor(query, result):
    pattern = re.sub(r'\?(\w+)', r'(?P<\1>.+)', query)
    match = re.search(pattern, result)

    if match:
        variables = {k: v.rstrip(")") for k, v in match.groupdict().items() if v is not None}
        return variables
    
    return {}

def query(q, context="EverythingPSC"):
    url = "http://localhost:9100/rbrowse/askquery-response.html?rpwrapper=interaction-manager&id=2&rauxkeys=agentmenu&agentmenu=query"

    payload = {
        "queryexp": q,
        "context": context,
        "facts": "all",
        "env": "env",
        "infer": "infer",
        "query": "Query using fire:query"
    }
    headers = {
    'Content-Type': 'application/x-www-form-urlencoded'
    }

    response = requests.request("POST", url, headers=headers, data=payload)
    soup = BeautifulSoup(response.text, "html.parser")

    span_tags = soup.find('div', {'id': 'basic-content'}).find_all('span')
    span_texts = [span_tag.text for span_tag in span_tags]

    span_texts = list(filter(lambda x:len(x)!=0, map(lambda x:extractor(q, x), span_texts)))

    span_texts = list(map(dict, set(frozenset(d.items()) for d in span_texts)))
    return span_texts

if __name__ == "__main__":
    print(query("(courseInstructor ?course VincentStAmour)"))