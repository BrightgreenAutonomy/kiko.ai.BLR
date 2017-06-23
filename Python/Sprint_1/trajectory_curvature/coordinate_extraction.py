#importing modules
import re
import pandas as pd

import matplotlib.pyplot as plt
plt.style.use('ggplot')
%matplotlib inline

#function
def preprocess(data):
    aux = []
    for i in range(0,len(data)):
        result = re.findall(r"\d+\.\d+",str(data.iloc[i,0]))
        aux.append(result)
    return aux

# reading data
with open('trajectory1.csv') as f:
         for line in f:
             data = line.split(',') 
                       
# dataframe
df = pd.DataFrame({'coordinate':data})
result = preprocess(df)
# new dataframe
columns= ['Source_X','Source_Y','Source_Z','Destination_X','Destination_Y','Destination_Z']
df_new=pd.DataFrame(result,columns=columns) 
result = pd.concat([df,df_new],axis=1)
df_new=df_new.astype(float)