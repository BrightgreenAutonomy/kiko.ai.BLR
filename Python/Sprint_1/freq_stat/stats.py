# import module
import pandas as pd

import seaborn as sns
import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle
plt.style.use('ggplot')
%matplotlib inline

# reading data
data = pd.read_csv('freq.csv',header=None,sep=',',index_col=None)
data.columns =["A","B","C","D"]

# barplot
plt.figure(figsize=(10, 10))
data.sum().plot(kind='bar',color=['red','green','blue','cyan'])
plt.xlabel('Targets')
plt.ylabel('Frequency of Hitting a Target')

# histogram
colors=['red','green','blue','cyan']
for (i,j) in zip(data.columns,colors):
      plt.figure(figsize=(6, 6))
      data[i].plot.hist(bins=4,color=j)
      #plt.title('Histogram of' + ' ' + str(i))

# Boxplot
plt.figure(figsize=(12, 12))
data.plot(kind='box')
plt.xlabel('Targets')
plt.ylabel('Statistics')

#variance
variance = data.var()
plt.figure(figsize=(8, 8))
variance.plot(x=variance.index,y=variance.tolist(), linestyle='--', marker='o', color='violet')
plt.xlabel('Targets')
plt.ylabel('Variance')

#all variance
plt.figure(figsize=(8, 8))
data.plot(figsize=(8, 8))
plt.xlabel('Index')
plt.ylabel('Value')

