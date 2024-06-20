from os import path
import requests

token = open(path.join(path.dirname(__file__), '.token')).readline().strip()
print(token)
