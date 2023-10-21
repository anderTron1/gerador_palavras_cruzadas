Gerador de Palavras Cruzadas

Descrição:
O projeto Gerador de Palavras Cruzadas é um sistema que gera palavras cruzadas com base em um conjunto de palavras que tenta resolver o crozzely. O sistema é composto por vários componentes, incluindo:

    app.py:
        Este arquivo é responsável por iniciar o servidor em Flask usando o pacote Dash. Ele também lida com a geração de gráficos interativos para interação com o usuário.

    coletor.py:
        Este arquivo é responsável por coletar as palavras que serão usadas para criar as palavras cruzadas. As palavras podem ser coletadas de um "bucket" ou de outra fonte de dados.

    criarCrossly.py:
        Este arquivo é responsável por criar o grid das palavras cruzadas com base na lista de palavras fornecida. Ele é responsável pela lógica de geração das palavras cruzadas.

Resultados Gerados (Localizados em "resultados 30 execusao palavra 20 letra"):

    Os resultados da execução do algoritmo de criação de palavras cruzadas são armazenados nesta pasta.
    Os resultados incluem métricas como a média de tempo de execução, a soma de reexecuções e as dimensões médias das grades geradas.
    Há três cenários diferentes: reordenar a lista de palavras com mais vogais, reordenar a lista por palavras aleatórias e os resultados gerais.

Exemplo de Resultados:

    30 EXECUÇÕES DO ALGORITMO COM 20 PALAVRAS PARA TESTE
        Média do Tempo: 0.2817 segundos
        Soma de Reexecuções: 0
        Média da Grade: 23x18

    Reordenar lista de palavras com mais vogais
        Média do Tempo: 0.3483 segundos
        Soma de Reexecuções: 0
        Média da Grade: 24x19

    Reordenar lista por palavras aleatórias
        Média do Tempo: 0.7140 segundos
        Soma de Reexecuções: 1
        Média da Grade: 24x19
