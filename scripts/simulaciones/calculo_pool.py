#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Tue Sep 28 16:15:32 2021

@author: oliver
"""

import pandas as pd
import numpy as np

start=1
end=6
rr=[]
r=["sim"+str(x)+".csv" for x in range(start,end+1)]
for j in r:
    datos=pd.read_csv(j, header=None)
    for i in xrange(len(datos)):
        if str(datos[0][i])=="False":
            rr=np.append(rr,datos[1][i])
total=sum(rr)
