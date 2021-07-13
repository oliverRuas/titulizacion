#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Mon Apr 26 14:13:23 2021

@author: oliver
"""

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

def probabilidad():
    defaulter_rate=0.01
    not_defaulter_rate=0.99
    defaulter_item="true"
    not_defaulter_item="false"
    defaulter_weight=100*defaulter_rate
    not_defaulter_weight=100*not_defaulter_rate
    L=[[defaulter_item,defaulter_weight],[not_defaulter_item,not_defaulter_weight]]
    
    S=defaulter_weight+not_defaulter_weight
    R=np.random.randint(0,S)
    T=0
    for item in L:
        T=T+item[1]
        if T>R:
            resultado=item[0]
    return resultado

#desviacion normal N(1000,10)
#el kW/h es a 0.10€
mu=1000
sigma=np.sqrt(10)
years=10
months=12
total_periodos=years*months
total=0
rate=0.0495
total_contratos=500


#datos=pd.read_csv("simulacion.txt",delimiter="\t",header=None)
rate=0.01
user=[]
energy=[]
payments=[]
if_default=[]
periodo=[]
lista_default=[]
lista_anhos=[]
total_periodos=months*years
suma=0
suma2=0
nuevo=np.zeros((total_contratos,months*years))
for indice in xrange(1,total_periodos+1):
    sumaa=0
    sumaa2=0
    resto=indice%months
    cociente=(indice-1)/(months)
    anho=cociente+1
    lista_anhos=np.append(lista_anhos,anho)
    print anho
    if resto==1:
        for k in xrange(1,int(rate*total_contratos) +1):
            x=np.random.randint(1,total_contratos+1)
            usuario_default="user"+str(x)
            default="true"
            while usuario_default in lista_default:
                print "se repite"
                print x
                x=np.random.randint(1,total_contratos+1)
                usuario_default="user"+str(x)
            default="true"
            lista_default=np.append(lista_default,usuario_default)
    for j in xrange(1,total_contratos+1):
        default="false"
        s=np.random.normal(mu,sigma,1)
        usuario_default="user"+str(j)
        user=np.append(user,usuario_default)
        periodo=np.append(periodo,indice)
        if usuario_default in lista_default:
            default="true"
            s=0.000
            nuevo[j-1,indice-1]=round(s,3)
            energy=np.append(energy,round(s,3))
        else:
            energy=np.append(energy,round(s,3))
            nuevo[j-1,indice-1]=round(s,3)
            
#        sumaa2+=dinero
#        if not usuario_default in lista_default:
#            sumaa=sumaa+dinero
#    suma=suma+(sumaa/(1+rate)**(anho))
#    suma2+=(sumaa2/(1+rate)**(anho))
nueva=np.transpose(nuevo)
ganancias=np.zeros(years)
nueva=np.transpose(nuevo)

for x in xrange(years):
    name="sim"+str(x+1)+".csv"
    suma=0

    with open(name, 'a') as the_file:
        for i in xrange(len(nueva[0])):
            cont=0
            for k in nueva[x*12:12*(x+1)]:
                cont=cont+1
                suma=suma+k[i]
                the_file.write("\""+str(k[i])+"\"")
                if cont!=months:
                    the_file.write(",")
            the_file.write("\n")
    ganancias[x]=suma
    the_file.close()
#    df.to_csv(name, sep=",", index=False,header=None)


#count, bins, ignored = plt.hist(energy, 30, density=True)
#plt.plot(bins, 1/(sigma * np.sqrt(2 * np.pi)) *np.exp( - (bins - mu)**2 / (2 * sigma**2) ),linewidth=2, color='r')
#
#plt.show()
