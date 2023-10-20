import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

'''
Aqui estão as plotagens com 30 execuções do algoritmo analise_desempenho_crozzy utilizando 20 palavras

'''

df3 = pd.read_csv('por_palavra_com_vogais_20.csv')
df2 = pd.read_csv('por_palavra_maiores_20.csv')
df1 = pd.read_csv('por_palavras_aleatoriedade_20.csv')


tempo_max = max(df1['tempo'].max(), df2['tempo'].max(), df3['tempo'].max())

sns.set(style='whitegrid')

plt.figure(figsize=(20, 8))
plt.subplot(1,2,1 )
sns.lineplot(x=df1.index, y=df1['tempo'], data=df1, label='Aleatoriedade')
sns.lineplot(x=df2.index, y=df2['tempo'], data=df2, label='Maiores palavras')
sns.lineplot(x=df3.index, y=df3['tempo'], data=df3, label='Palavras com mais vogais')
plt.xticks(range(0, 30))
plt.xlabel('Quantidade de execução')
plt.ylabel('Tempo de cada execução')
plt.legend()
plt.yticks(range(0, int(tempo_max+1)))

#aqui pega as 3 execuções dos resultados gerado pelo algoritmo analise_desempenho_crozzy
dados= {'metodo': ['Palavras Aleatorias 0.71','Palavras Maiores 0.28', 'Palavras com mais Vogais 0.34'],
        'tempo': [0.7140000000000001, 0.2816666666666667, 0.34833333333333333]}

dados = pd.DataFrame(dados)
plt.subplot(1,2,2)
plt.pie(dados['tempo'], labels=dados['metodo'], startangle=140)
plt.title('Tempo de Execuções do algoritmo com 20 palavras')

plt.savefig('resultados_30_execucoes_20_palavras.png', dpi=300, bbox_inches="tight")
plt.show()
