import pandas as pd

import seaborn as sns
import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle
plt.style.use('ggplot')
%matplotlib inline

data = pd.read_csv('grid__lambda_1k_1_simulation1.asc', sep=' ', skiprows=5,header=None)

plt.figure(figsize=(10,10))
g = sns.heatmap(data.ix[:,0:49])
g.add_patch(Rectangle((20,49), 1, 1, fill=True, edgecolor='green', lw=10))
g.add_patch(Rectangle((7, 49- 40), 1, 1, fill=True, edgecolor='blue', lw=3))
g.add_patch(Rectangle((35, 49-45), 1, 1, fill=True, edgecolor='blue', lw=3))
g.add_patch(Rectangle((5,49- 6 ), 1, 1, fill=True, edgecolor='blue', lw=3))
g.add_patch(Rectangle((45,49- 8), 1, 1, fill=True, edgecolor='blue', lw=3))