#!/usr/bin/python
# -*- coding: utf-8 -*-

# (c) 2015, Warren Strange

# Not complete  - experimental, just a stub for now
#
#

import urllib
import requests
import threading
import os
import json
import amlib

class AMConnection:
    def __init__(self, url, admin, password):
        self.url = url
        authheaders =  {"Content-type": "application/json",
            "X-OpenAM-Username": admin ,
            "X-OpenAM-Password": password}
        authurl = url + "/json/authenticate"
        r = requests.post(authurl, data="{}", headers=authheaders)
        t = json.loads(r.text)
        id =   t['tokenId']
        r.close()
        self.id = id

def create_realm(ctx,realmpath):
    body = '{ "realm": "' + realmpath + '"}'
    url = ctx.url + "/json/realms?_action=create"
    headers = {"Content-type": "application/json",
        "iplanetDirectoryPro": ctx.id }
    response = requests.post(url, data=body, headers=headers)
    print response.text
    response.close()


def main():
    base_url = "http://openam.example.com:28080/openam"
   
    ctx = AMConnection(base_url,"amadmin","password")
    create_realm(ctx,"myrealm/foo2")

main()

