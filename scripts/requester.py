#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Thu May 27 13:25:06 2021

@author: oliver
"""

import re
import json
import numpy as np
r=[]
#p=[]
with open('requester.json') as json_file:
    data = json.load(json_file)

items = json.loads(data)
#items=data
# Input the item name that you want to search
#item = input("Enter an item name:\n")


for key in items:
    print key['identidad']

with open("new_owners.txt",'w') as the_file:    
    for key in items:
        the_file.write(key['identidad']+"\n")

#nombre_archivo="docs.json"
#file=open(nombre_archivo,'r')
#data=file.read()
#
#data=json.loads("docs.json")
#for key, value in data.items():
#    print key, value
#datos1=re.split('identidad',data)
#r=[]
#p=[]
#rr=[]
#x=""
#for i in datos1:
#    if "eDU" in i:
#        start=i.index("eDU")
#        end=i.index("\\\"}")
#        r=np.append(i[start:end],r)
#    
#r[:-1]
#
#with open("new_owners.txt",'w') as the_file:
#    for k in range(len(rr)):    
#        the_file.write(rr[k]+"\n")