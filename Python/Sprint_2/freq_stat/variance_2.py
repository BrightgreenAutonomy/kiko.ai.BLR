# importing modules
import os
import re
import glob2

import pandas as pd

import matplotlib.pyplot as plt
plt.style.use('ggplot')
%matplotlib inline

# functions
def get_data (path,k,lamb,s):
    aux = []
    filenames = glob2.glob(path + '\*.csv')
    for filename in filenames:
        basename = os.path.basename(filename)
        if basename.startswith('freq__lambda_'+str(lamb)+'k_'+ str(k)+ '_'+'simulation' + str(s)) == True:
              data = pd.read_csv(filename,header = None)
              data .columns =['A','B','C','D','E/E']  
              return data['E/E']

# main simulation 1 freq__lambda_1k_2_
path = '..............................'
for l in range(1,6):
   ee = [] 
   for k in range(1,11):
        aux = [] 
        for s in range(1,11):
             data = get_data(path,k,l,s)
             aux.append(data)

        ee.append(pd.concat(aux,axis=1))
   df = pd.concat(ee,axis=0)
   df.index = ['k1','k2','k3','k4','k5','k6','k7','k8','k9','k10']
   result =df.var(axis=1)
   plt.figure(figsize=(10,5))
   result.plot(kind='bar',color='yellow')
   plt.xlabel('Value of K')
   plt.ylabel('Variance')
   plt.title('Simulations = 1 to 10 with Lambda =' + str(l))
