import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

df3 = pd.read_csv('por_palavra_com_vogais_20.csv')
df2 = pd.read_csv('por_palavra_maiores_20.csv')
df1 = pd.read_csv('por_palavras_aleatoriedade_20.csv')

tempo_max = max(df1['tempo'].max(), df2['tempo'].max(), df3['tempo'].max())



sns.set(style='whitegrid')
plt.figure(figsize=(19, 15))
sns.lineplot(x=df1.index, y=df1['tempo'], data=df1, label='Aleatoriedade')
sns.lineplot(x=df2.index, y=df2['tempo'], data=df2, label='Maiores palavras')
sns.lineplot(x=df3.index, y=df3['tempo'], data=df3, label='Palavras com mais vogais')
plt.xticks(range(0, 30))
plt.xlabel('Quantidade de execução')
plt.ylabel('Tempo de cada execução')
plt.legend()
plt.yticks(range(0, int(tempo_max+1)))
plt.savefig('tempo_ex_com_20_palavras.png', dpi=300, bbox_inches="tight")
plt.show()
