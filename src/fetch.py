#
# Fetch X509 certificates from NetAngels.ru
#
from os import path
import requests

API = 'https://api-ms.netangels.ru/api/v1/'

api_key = open(path.join(path.dirname(__file__), '.token')).readline().strip()

s = requests.Session()

token = s.post('https://panel.netangels.ru/api/gateway/token/', data={'api_key': api_key}).json()['token']
s.headers['authorization'] = 'Bearer ' + token

x509s = s.get(API + 'certificates/').json()
print(x509s)
