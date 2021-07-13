#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Wed May  5 18:48:00 2021

@author: oliver
"""

import pandas as pd

#datos=pd.read_json("securitization_newest.block.JSON")

import pem
with open('cert.pem', 'rb') as f:
   certs = pem.parse(f.read())