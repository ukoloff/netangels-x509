#
# Fetch X509 certificates from NetAngels.ru
#
import io
from os import path
import requests
from zipfile import ZipFile
from itertools import groupby
from operator import itemgetter

API = 'https://api-ms.netangels.ru/api/v1/'

api_key = open(path.join(path.dirname(__file__), '.token')).readline().strip()

s = requests.Session()

token = s.post('https://panel.netangels.ru/api/gateway/token/', data={'api_key': api_key}).json()['token']
s.headers['authorization'] = 'Bearer ' + token

x509s = s.get(API + 'certificates/').json()

def wildcard(x509):
    d = x509['domains']
    d.sort(key=len)
    if len(d)!=2 or d[1]!='*.'+d[0]:
        return
    x509['DNS'] = d[0]
    return True

x509s = filter(wildcard, x509s['entities'])
x509s = groupby(x509s, itemgetter('DNS'))
x509s = dict((dns, sorted(group, key=itemgetter('not_after'))[-1]) for dns, group in x509s)

x509s = s.get(API + 'certificates/find/', json={'is_issued_only': True, 'domains': ['*.ekb.ru']}).json()

for x in x509s['entities']:
    r = s.get(API + f"certificates/{x['id']}/download/", json={'name': 'A', 'type': 'zip'})
    z = ZipFile(io.BytesIO(r.content))
    print(*z.NameToInfo.keys())
