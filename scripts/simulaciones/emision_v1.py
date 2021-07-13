#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Sat Apr 24 15:02:19 2021

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
#    print R
    T=0
    for item in L:
        T=T+item[1]
        if T>R:
           return item[0]
#            resultado=item[0]
#    return resultado

mu=1000
sigma=np.sqrt(10)
years=10
months=12
total_periodos=years*months
total=0
rate=0.0495
total_contratos=500


#datos=pd.read_csv("simulacion.txt",delimiter="\t",header=None)
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
rate=0.01
nuevo=np.zeros((total_contratos,months*years))
#total=0
#
#simulaciones=5

#for kk in xrange(1,simulaciones+1):
total=0
#energia_consumida=np.zeros(simulaciones)
#lista_morosos=np.zeros(simulaciones)
for indice in xrange(1,total_periodos+1):
    suma=0
#    sumaa2=0
    resto=indice%months
    cociente=(indice-1)/(months)
    anho=cociente+1
    lista_anhos=np.append(lista_anhos,anho)
#    print anho
    if resto==1:
        for k in xrange(1,total_contratos+1):
            x=probabilidad()
            usuario_default="user"+str(k)
            if x=="true":
                s=0.000
                nuevo[k-1,indice-1]=round(s,3)
                s=" "
                energy=np.append(energy,s)
#                nuevo[k-1,indice-1]=float('nan')
                default="true"
                lista_default=np.append(lista_default,usuario_default)
            else:
                s=np.random.normal(mu,sigma,1)
                energy=np.append(energy,round(s,3))
                nuevo[k-1,indice-1]=round(s,3)
                suma=suma+round(s,3)

#        for k in xrange(1,int(rate*total_contratos) +1):
            
            ########################################
            #######################################
            ############MANERA-NORMAL##############
#            x=np.random.randint(1,total_contratos+1)
#            usuario_default="user"+str(x)
#            default="true"
#            while usuario_default in lista_default:
#                print "se repite"
#                print x
#                x=np.random.randint(1,total_contratos+1)
#                usuario_default="user"+str(x)
#            default="true"
            
            ########################################
            ########################################
            #######MANERA-USANDO-SUCESOS############
            if usuario_default in lista_default:
                s=0.000
                nuevo[k-1,indice-1]=round(s,3)
#                s=" "
#                nuevo[k-1,indice-1]=float('nan')

    else:
        for j in xrange(1,total_contratos+1):
            default="false"
            s=np.random.normal(mu,sigma,1)
            usuario_default="user"+str(j)
            user=np.append(user,usuario_default)
            periodo=np.append(periodo,indice)
            if usuario_default in lista_default:
                default="true"
                s=" "
                nuevo[j-1,indice-1]=0.0
#                nuevo[j-1,indice-1]=float('nan')
                energy=np.append(energy,s)
            else:
                energy=np.append(energy,round(s,3))
                nuevo[j-1,indice-1]=round(s,3)
                suma=suma+round(s,3)
    total=total+suma
#lista_morosos[kk-1]=len(lista_default)
#energia_consumida[kk-1]=total
#print(len(lista_default))
            
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

#
#
#for x in xrange(total_periodos):
#    name="sim"+str(x+1)+".csv"
##    suma=0
#    with open(name, 'a') as the_file:
##        for i in xrange(total_contratos):
##            cont=0
#        for k in energy[x*total_contratos:total_contratos*(x+1)]:
##            cont=cont+1
##                suma=suma+k[i]
#            the_file.write(str(k))
#            the_file.write("\n")
##            the_file.write("\n")
##    ganancias[x]=suma
#    the_file.close()

#
#
#
##

