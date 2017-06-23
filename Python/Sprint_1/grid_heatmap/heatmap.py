# import module
import pandas as pd

import seaborn as sns
import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle
plt.style.use('ggplot')
%matplotlib inline

# reading data
data = pd.read_csv('grid1.txt',header=None,sep=' ',index_col=None)

# heatmap
plt.figure(figsize=(12, 16))
g=sns.heatmap(data.ix[:,0:49],annot=False, linewidths=2)
g.add_patch(Rectangle((7, 49- 40), 1, 1, fill=True, edgecolor='blue', lw=3))
g.add_patch(Rectangle((35, 49-45), 1, 1, fill=True, edgecolor='blue', lw=3))
g.add_patch(Rectangle((5,49- 6 ), 1, 1, fill=True, edgecolor='blue', lw=3))
g.add_patch(Rectangle((45,49- 8), 1, 1, fill=True, edgecolor='blue', lw=3))