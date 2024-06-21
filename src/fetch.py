#!/usr/bin/python3
#
# Fetch X509 certificates from NetAngels.ru
#
import io
import sys
import hashlib
import requests
from os import path, scandir
from subprocess import run
from zipfile import ZipFile
from itertools import groupby
from operator import itemgetter

API = "https://api-ms.netangels.ru/api/v1/certificates/"

self = path.dirname(path.realpath(__file__))

api_key = open(path.join(self, ".token")).readline().strip()

s = requests.Session()

token = s.post(
    "https://panel.netangels.ru/api/gateway/token/", data={"api_key": api_key}
)
s.headers["authorization"] = "Bearer " + token.json()["token"]

# x509s = s.get(
#     API + "find/", json={"is_issued_only": True, "domains": ["*.ekb.ru"]}
# ).json()

folder = path.join(self, "crt")

x509s = s.get(API)


def wildcard(x509):
    d = x509["domains"]
    d.sort(key=len)
    if len(d) != 2 or d[1] != "*." + d[0]:
        return
    x509["DNS"] = d[0]
    return True


changedAny = 0


def hash(fname):
    if not path.isfile(fname):
        return
    with open(fname, "rb") as f:
        return hashlib.sha512(f.read()).hexdigest()


x509s = filter(wildcard, x509s.json()["entities"])
for dns, group in groupby(x509s, itemgetter("DNS")):
    changed = 0
    fname = dns.replace(".", "-")
    x509 = sorted(group, key=itemgetter("not_after"))[-1]
    r = s.get(
        API + f"{x509['id']}/download/",
        json={"name": fname, "type": "zip"},
    )
    z = ZipFile(io.BytesIO(r.content))
    for f in z.infolist():
        fn = path.join(folder, f.filename)
        h1 = hash(fn)
        z.extract(f, path=folder)
        h2 = hash(fn)
        if h1 != h2:
            changed += 1
            changedAny += 1

    if changed == 0:
        continue

    # Generate .pfx
    run(
        [
            "openssl",
            "pkcs12",
            "-export",
            "-in",
            fname + ".full.crt",
            "-inkey",
            fname + ".key",
            "-name",
            fname + "@netangels",
            "-passout",
            "pass:" + fname + "@netangels",
            "-legacy",
            "-out",
            fname + ".pfx",
        ],
        cwd=folder,
        check=True,
    )

if changedAny != 0 and sys.platform.startswith("linux"):
    hosts = path.realpath(path.join(self, "../hosts.d"))
    for x in scandir(hosts):
        if not x.is_file():
            continue
        run(["bash", x.name], cwd=hosts, check=True)
