import json
import re

import requests
from bs4 import BeautifulSoup

IP = "127.0.0.1"
PORT = "9100"

def extractor(query, result):
    pattern = re.sub(r'\?(\w+)', r'(?P<\1>.+)', query)
    match = re.search(pattern, result)

    if match:
        variables = {k: v.rstrip(")") for k, v in match.groupdict().items() if v is not None}
        return variables
    
    return {}

def query(q, context="MedProj"):
    clearWorkingMemory()
    url = f"http://{IP}:{PORT}/rbrowse/askquery-response.html?rpwrapper=interaction-manager&id=2&rauxkeys=agentmenu&agentmenu=query"

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

def store(f, context="MedProj"):
    url = f"http://{IP}:{PORT}/rbrowse/kb-fact-edit-response.html?rpwrapper=interaction-manager&kb=1&kbbl=0&rauxkeys=agentmenu&agentmenu=kb-edit"

    payload={
        "exp" : f,
        "context" : context,
        "store" : "Store"
    }
    headers = {
    'Content-Type': 'application/x-www-form-urlencoded'
    }

    requests.request("POST", url, headers=headers, data=payload)

def forget(f, context="MedProj"):
    url = f"http://{IP}:{PORT}/rbrowse/kb-fact-edit-response.html?rpwrapper=interaction-manager&kb=1&kbbl=0&rauxkeys=agentmenu&agentmenu=kb-edit"

    payload={
        "exp" : f,
        "context" : context,
        "forget" : "Forget"
    }
    headers = {
    'Content-Type': 'application/x-www-form-urlencoded'
    }

    requests.request("POST", url, headers=headers, data=payload)

def clearWorkingMemory():
    url = f"http://{IP}:{PORT}/xhi/kqml"

    payload = json.dumps({
    "performative": "achieve",
    "sender": "s-mgr",
    "receiver": "interaction-manager",
    "reply_with": 1,
    "language": "fire",
    "content": "(doClearWorkingMemory)"
    })
    headers = {
    'Content-Type': 'application/json'
    }

    requests.request("POST", url, headers=headers, data=payload)

if __name__ == "__main__":
    store("(heartrate VincentStAmour 80)")
    print(query("(heartrate VincentStAmour ?hr)"))
    forget("(heartrate VincentStAmour 80)")
    print(query("(heartrate VincentStAmour ?hr)"))