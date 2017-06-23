# importing modules
import os
import re
import glob2

import pandas as pd

import matplotlib.pyplot as plt
plt.style.use('ggplot')
%matplotlib inline

# functions
def get_data (path,k,lamb):
    aux = []
    filenames = glob2.glob(path + '\*.csv')
    for filename in filenames:
        basename = os.path.basename(filename)
        if basename.startswith('freq__lambda_'+str(lamb)+'k_'+ str(k)+ '_') == True:
              data = pd.read_csv(filename,header = None)
              data .columns =['A','B','C','D','E/E']  
              return data['E/E']

# main simulation 1 freq__lambda_1k_2_
path = '....................................'
ee = []

for l in range(1,6):
   aux = [] 
   for k in range(1,11):
       data = get_data(path,k,l)
       aux.append(data) 
   ee.append(pd.concat(aux,axis=1))
df = pd.concat(ee,axis = 0)
result = df.var(axis=1)
result.index = [1,2,3,4,5]

#plot
result.plot(kind='bar',color='yellow',figsize=(10,10) )
plt.xlabel('Lambda ')
plt.ylabel('Variance')
plt.title('Simulations with Lambda = 1 to 5 and k = 1 to 10 ')