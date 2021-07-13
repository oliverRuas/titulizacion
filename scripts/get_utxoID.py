#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Thu May 27 17:12:04 2021

@author: oliver
"""

import json
import numpy as np
r=[]
#p=[]



nombre_archivo="utxo.json"
file=open(nombre_archivo,'r')
data=file.read()
if "changeUtxoId" in data:
    y=len("changeUtxoId")
    x=data.index("changeUtxoId")        
    data[x+y]
final=data[x+y+5:x+y+71]

with open("new_utxo.txt",'w') as the_file:
    the_file.write(final)
