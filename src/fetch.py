#
# Fetch X509 certificates from NetAngels.ru
#
import io
import requests
from os import path
from zipfile import ZipFile
from itertools import groupby
from operator import itemgetter

API = "https://api-ms.netangels.ru/api/v1/certificates/"

api_key = open(path.join(path.dirname(__file__), ".token")).readline().strip()

s = requests.Session()

token = s.post(
    "https://panel.netangels.ru/api/gateway/token/", data={"api_key": api_key}
)
s.headers["authorization"] = "Bearer " + token.json()["token"]

# x509s = s.get(API + 'find/', json={'is_issued_only': True, 'domains': ['*.ekb.ru']}).json()

folder = path.join(path.dirname(__file__), "crt")

x509s = s.get(API)


def wildcard(x509):
    d = x509["domains"]
    d.sort(key=len)
    if len(d) != 2 or d[1] != "*." + d[0]:
        return
    x509["DNS"] = d[0]
    return True


x509s = filter(wildcard, x509s.json()["entities"])
for dns, group in groupby(x509s, itemgetter("DNS")):
    x509 = sorted(group, key=itemgetter("not_after"))[-1]
    r = s.get(
        API + f"{x509['id']}/download/",
        json={"name": dns.replace(".", "-"), "type": "zip"},
    )
    z = ZipFile(io.BytesIO(r.content))
    for f in z.infolist():
        z.extract(f, path=folder)
