# importing modules
import os
import re
import glob2

import pandas as pd

import matplotlib.pyplot as plt
plt.style.use('ggplot')
%matplotlib inline

# functions
def get_data (path,i):
    aux = []
    filenames = glob2.glob(path + '\*.csv')
    for filename in filenames:
        basename = os.path.basename(filename)
        if basename.startswith('freq__lambda_'+str(i)+'k_2_') == True:
              data = pd.read_csv(filename,header = None)
              data .columns =['A','B','C','D','E/E']  
              aux.append(data)  
    data = pd.concat(aux,axis = 0)
    return data

# main simulation 1 freq__lambda_1k_2_
path = '..............................'
variance = []
for i in range(1,6):
    data = get_data(path,i)
    variance.append(data.var())
    
plot_variance = pd.concat(variance,axis=1)
plot_variance = plot_variance.T
plot_variance.index = [1,2,3,4,5]
#plt.figure(figsize=(10,10))
plot_variance.plot(kind = 'line', marker = 'o',color = ['red','green','blue','cyan','yellow'],figsize=(10,10))
plt.xlabel('Number of Simulations ')
plt.ylabel('Variance')
plt.title('Simulations with Lambda = 1 to 5 and k = 2 ')
#plt.title('freq__lambda_1k_1')