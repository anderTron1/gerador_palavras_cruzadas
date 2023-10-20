[33mcommit 5c567de57a34eb511070d658866269498d63f3d3[m[33m ([m[1;36mHEAD -> [m[1;32mmaster[m[33m, [m[1;31morigin/master[m[33m)[m
Author: anderTron1 <andre-luizpiresguimaraes@outlook.com>
Date:   Thu Oct 19 21:44:27 2023 +0000

    commit eveturado no servidor

[1mdiff --git a/README.md b/README.md[m
[1mnew file mode 100644[m
[1mindex 0000000..b05ebd8[m
[1m--- /dev/null[m
[1m+++ b/README.md[m
[36m@@ -0,0 +1 @@[m
[32m+[m[32mgerador palavras cruzadas[m
[1mdiff --git a/__pycache__/coletor.cpython-37.pyc b/__pycache__/coletor.cpython-37.pyc[m
[1mnew file mode 100644[m
[1mindex 0000000..4931eaa[m
Binary files /dev/null and b/__pycache__/coletor.cpython-37.pyc differ
[1mdiff --git a/__pycache__/criarCrossly.cpython-37.pyc b/__pycache__/criarCrossly.cpython-37.pyc[m
[1mnew file mode 100644[m
[1mindex 0000000..cb223f6[m
Binary files /dev/null and b/__pycache__/criarCrossly.cpython-37.pyc differ
[1mdiff --git a/app.py b/app.py[m
[1mnew file mode 100644[m
[1mindex 0000000..ecffd29[m
[1m--- /dev/null[m
[1m+++ b/app.py[m
[36m@@ -0,0 +1,294 @@[m
[32m+[m[32m#!/usr/bin/env python3[m
[32m+[m[32m# -*- coding: utf-8 -*-[m
[32m+[m[32m"""[m
[32m+[m[32mCreated on Mon Oct 16 22:15:24 2023[m
[32m+[m
[32m+[m[32m@author: andre[m
[32m+[m[32m"""[m
[32m+[m
[32m+[m[32mimport dash[m
[32m+[m[32mfrom dash import Input, Output,ctx, State, html, dcc, dash_table[m
[32m+[m[32m#import dash_core_components as dcc[m
[32m+[m[32mimport dash_bootstrap_components as dbc[m
[32m+[m[32m#import dash_html_components as html[m
[32m+[m[32m#import dash_table[m
[32m+[m[32mimport plotly.graph_objs as go[m
[32m+[m[32mfrom dash.exceptions import PreventUpdate[m
[32m+[m[32mimport pandas as pd[m
[32m+[m[32mimport datetime[m
[32m+[m
[32m+[m[32mfrom criarCrossly import Gerar_grade[m
[32m+[m[32mfrom coletor import Coletor_palavras[m
[32m+[m[32m#grade = Gerar_grade(50)[m
[32m+[m[32m#grade.gerar()[m
[32m+[m
[32m+[m
[32m+[m[32mapp = dash.Dash(__name__, external_stylesheets=[dbc.themes.JOURNAL])[m
[32m+[m
[32m+[m
[32m+[m[32mdef coordenadas(coordenada):[m
[32m+[m[32m  coordenada = coordenada.split(',')[m
[32m+[m[32m  if coordenada[0].find(':') != -1:[m
[32m+[m[32m    step_x, stop_x = map(int, str(coordenada[0:1][0]).split(':'))[m
[32m+[m[32m    start_y = int(coordenada[1])[m
[32m+[m[32m    return step_x, stop_x, start_y, 1[m
[32m+[m[32m  else:[m
[32m+[m[32m    step_y, stop_y = map(int, str(coordenada[1:2][0]).split(':'))[m
[32m+[m[32m    start_x = int(coordenada[0])[m
[32m+[m[32m    return step_y, stop_y, start_x, 2[m
[32m+[m
[32m+[m[32mlink = 'http://crozzle.s3-website-us-east-1.amazonaws.com/palavras.txt'[m
[32m+[m[32mtamanho_maximo_palavras = 10[m
[32m+[m
[32m+[m[32mcoletor = Coletor_palavras(link, tamanho_maximo_palavras)[m
[32m+[m[32mbase_de_palavras = coletor.coletar()[m
[32m+[m
[32m+[m
[32m+[m[32mapp.layout = html.Div([[m
[32m+[m[41m    [m
[32m+[m[32m  dcc.Store(id='classe_grade', data=None),[m
[32m+[m[32m  dcc.Store(id='classe_coletor_palavras', data={'base_de_dados_palavras':base_de_palavras}),[m
[32m+[m[32m  dbc.Row([[m
[32m+[m[32m      html.Div()#html.P('GERADOR DE PALAVRAS GRUÇADAS')[m
[32m+[m[32m  ]),[m
[32m+[m[32m  dbc.Row([[m
[32m+[m[32m      dbc.Col([m
[32m+[m[32m          dbc.Card([[m
[32m+[m[32m            #html.H4('Grade'),[m
[32m+[m[32m            dcc.Loading(id='loading', children=[[m
[32m+[m[32m                html.Div(id='grade', children=[[m
[32m+[m[32m                    dash_table.DataTable([m
[32m+[m[32m                         id='table1',[m
[32m+[m[32m                         columns=[],[m
[32m+[m[32m                         data=[],[m
[32m+[m[32m                        style_cell={'widht': '5px','height': '5px', 'textAlign': 'center'},[m
[32m+[m[32m                        style_table={'minWidht': '100px','minHeight': '100px', 'overflowY': 'auto'}[m
[32m+[m[32m                    )[m
[32m+[m[32m                ])[m
[32m+[m[32m            ])[m
[32m+[m[32m          ], style={'padding': '10px', 'margin': '20px'}),sm=8),[m
[32m+[m[32m      dbc.Col([m
[32m+[m[32m          dbc.Card([[m
[32m+[m[32m            dbc.Row([[m
[32m+[m[32m                dbc.Card([[m
[32m+[m[32m                    html.H4("Quantidade de palavra a inserir"),[m
[32m+[m[32m                    dcc.Slider([m
[32m+[m[32m                        id='interval-slider',[m
[32m+[m[32m                        min=5,[m
[32m+[m[32m                        max=50,[m
[32m+[m[32m                        step=5,  # Pula de 5 em 5[m
[32m+[m[32m                        value=5,  # Valor inicial[m
[32m+[m[32m                        marks={i: str(i) for i in range(5, 51, 5)},  # Rótulos do slider[m
[32m+[m[32m                    ),[m
[32m+[m[32m                    html.Button('Gerar', id='gerar_caca_palavras', n_clicks=0)[m
[32m+[m[32m                ])[m
[32m+[m[32m            ], style={'padding': '10px'}),[m
[32m+[m[32m            dbc.Row([[m
[32m+[m[32m              dbc.Card([[m
[32m+[m[32m                html.Div([[m
[32m+[m[32m                    html.P('Palavras inseridas'),[m
[32m+[m[32m                    html.Div(id='tabela-palavras-inseridas', children=[[m
[32m+[m[32m                           dash_table.DataTable([m
[32m+[m[32m                                id='table',[m
[32m+[m[32m                                columns=[[m
[32m+[m[32m                                             {'name': 'Palavras', 'id': 'Palavras'},[m
[32m+[m[32m                                             {'name': 'Coordenadas', 'id':'Coordenadas'}[m
[32m+[m[32m                                         ],[m
[32m+[m[32m                                data=[],[m
[32m+[m[32m                                row_selectable='single',[m
[32m+[m[32m                                fixed_rows={'headers':True},[m
[32m+[m[32m                                style_table={'height': '200px', 'overflowY': 'auto'},[m
[32m+[m[32m                                style_data={'width': '50px', 'textOverflow': 'ellipsis'},[m
[32m+[m[32m                                style_cell_conditional=[[m
[32m+[m[32m                                    {[m
[32m+[m[32m                                        'if':{'column_id': 'ID'},[m
[32m+[m[32m                                        'maxWidth':'20px'[m
[32m+[m[32m                                    }[m
[32m+[m[32m                                ][m
[32m+[m[32m                            )[m
[32m+[m[32m                        ])[m
[32m+[m[32m                ]),[m
[32m+[m[32m              ])[m
[32m+[m[32m            ],  style={'padding': '10px'}),[m
[32m+[m[32m            dbc.Row([[m
[32m+[m[32m              dbc.Card([[m
[32m+[m[32m                html.Div([[m
[32m+[m[32m                    #html.P('Tempo de Execução: {} segundos'.format(round(grade.fim_tempo-grade.inicio_tempo,2)), style={'margin':0}),[m
[32m+[m[32m                    #html.P('Quantidade de palavras: {}'.format(grade.n_palavras_inseridas), style={'margin':0}),[m
[32m+[m[32m                    #html.P('Vezes que a grade foi resetado: {}'.format(grade.quant_grade_resetado), style={'margin':0}),[m
[32m+[m[32m                    html.P(id='resumo', children='Resumo dos resultados')[m
[32m+[m[32m                ])[m
[32m+[m[32m              ])[m
[32m+[m[32m            ], style={'padding': '10px'}),[m
[32m+[m[32m            dbc.Row([[m
[32m+[m[32m                dcc.Graph(id='grafico-interseccoes', config={'displayModeBar': False, 'showTips':False})[m
[32m+[m[32m                #html.Div(id='valores')[m
[32m+[m[32m            ]),[m
[32m+[m	[32m    dbc.Row([[m
[32m+[m[32m                html.Div('Hora reesecução do coletor: ', id='reesecutar-coletor'),[m
[32m+[m[32m                dcc.Interval([m
[32m+[m[32m                    id='intervalo',[m
[32m+[m[32m                    interval=1000 * 10,[m
[32m+[m[32m                    n_intervals=0[m
[32m+[m[32m                )[m
[32m+[m[32m            ])[m
[32m+[m[32m          ], style={'padding': '10px'}),style={'padding': '20px'},sm=4)[m
[32m+[m[32m  ]),[m
[32m+[m
[32m+[m[32m])[m
[32m+[m
[32m+[m[32m@app.callback([m
[32m+[m[32m    [Output('table1', 'data'),[m
[32m+[m[32m    Output('table1', 'columns'),[m
[32m+[m[41m    [m
[32m+[m[32m    Output('table', 'data'),[m
[32m+[m[32m    Output('table', 'columns'),[m
[32m+[m[41m    [m
[32m+[m[32m    Output('table', 'selected_rows'),[m
[32m+[m[32m    Output('classe_grade', 'data')],[m
[32m+[m[32m    Input('gerar_caca_palavras', 'n_clicks'),[m
[32m+[m[32m    State('interval-slider', 'value'),[m
[32m+[m[32m    State('classe_coletor_palavras', 'data'),[m
[32m+[m[32m    prevent_initial_call=True[m
[32m+[m[32m)[m
[32m+[m[32mdef gerar_grade(n_clicks, valor_slider, base_de_palavras):[m
[32m+[m[32m    if n_clicks != 0:[m
[32m+[m[32m        n_clicks = 0[m
[32m+[m[32m        grade = Gerar_grade(int(valor_slider), base_de_palavras['base_de_dados_palavras'])[m
[32m+[m[32m        grade.gerar()[m
[32m+[m[41m        [m
[32m+[m[32m        df = [{str(i): cell for i, cell in enumerate(row)} for row in grade.grade_caca_palavras][m
[32m+[m[32m        dicionario = [{'Palavras': itens, 'Coordenadas': chaves} for chaves,itens in grade.palavras_inseridas.items()][m
[32m+[m[41m        [m
[32m+[m[32m        #=========================================[m
[32m+[m[32m        grade_df = df[m
[32m+[m[32m        columns_grade=[{'name': str(i), 'id': str(i)} for i in range(grade.grade_caca_palavras.shape[1])][m
[32m+[m[41m            [m
[32m+[m[32m        #===========================================[m
[32m+[m[32m        tabela_palavras_inseridas = dicionario[m
[32m+[m[32m        tabela_palavras_columns=[{'name': colum, 'id': colum} for colum in dicionario[0].keys()][m
[32m+[m[41m        [m
[32m+[m[32m        grade = {'pontos_no_aumento_grade': grade.pontos_no_aumento_grade,[m
[32m+[m[32m                 'inseridas_no_aumento_grade': grade.inseridas_no_aumento_grade,[m
[32m+[m[32m                 'tempo_execucao': grade.tempo_execucao,[m
[32m+[m[32m                 'n_palavras_inseridas': grade.n_palavras_inseridas,[m
[32m+[m[32m                 'quant_grade_resetado': grade.quant_grade_resetado,[m
[32m+[m[32m                 'y_grade':grade.y_grade, 'x_grade': grade.x_grade[m
[32m+[m[32m                 }[m
[32m+[m[41m        [m
[32m+[m[32m        return grade_df, columns_grade, tabela_palavras_inseridas, tabela_palavras_columns, [], grade[m
[32m+[m
[32m+[m[32m@app.callback([m
[32m+[m[32m    Output('table1', 'style_data_conditional'),[m
[32m+[m[32m    Input('table', 'selected_rows'),[m
[32m+[m[32m    Input('table', 'data'),[m
[32m+[m[32m    prevent_initial_call=True[m
[32m+[m[32m)[m
[32m+[m[32mdef selecionar_palavras_na_grade(selected_rows, data):[m
[32m+[m[32m  if selected_rows:[m
[32m+[m[32m    selected_row_index = selected_rows[0][m
[32m+[m[32m    selected_row_data = list(data[selected_row_index].values())[1][m
[32m+[m
[32m+[m[32m    step, stop, start, iniciar_por = coordenadas(selected_row_data)[m
[32m+[m[32m    if iniciar_por == 2:[m
[32m+[m[32m      style = [{[m
[32m+[m[32m          'if': {[m
[32m+[m[32m             'row_index': start,[m
[32m+[m[32m              'column_id': str(percorrer)[m
[32m+[m[32m            },[m
[32m+[m[32m            'backgroundColor': '#00FFFF'  # Defina a cor desejada[m
[32m+[m[32m          } for percorrer in range(step, stop+1)[m
[32m+[m[32m      ][m
[32m+[m[32m    else:[m
[32m+[m[32m      style = [{[m
[32m+[m[32m          'if': {[m
[32m+[m[32m             'row_index': percorrer,[m
[32m+[m[32m              'column_id': str(start)[m
[32m+[m[32m            },[m
[32m+[m[32m            'backgroundColor': '#00FFFF'  # Defina a cor desejada[m
[32m+[m[32m          } for percorrer in range(step, stop+1)[m
[32m+[m[32m      ][m
[32m+[m[32m    style_data_conditional = style[m
[32m+[m
[32m+[m[32m    return style_data_conditional[m
[32m+[m[32m  return [][m
[32m+[m
[32m+[m[32m@app.callback([m
[32m+[m[32m    Output('grafico-interseccoes', 'figure'),[m
[32m+[m[32m    #Output('valores', 'children'),[m
[32m+[m[32m    #Input('grafico-interseccoes', 'relayoutData'),[m
[32m+[m[32m    Input('table', 'data'),[m
[32m+[m[32m    State('interval-slider', 'value'),[m
[32m+[m[32m    Input('classe_grade', 'data'),[m
[32m+[m[32m    prevent_initial_call=True[m
[32m+[m[32m)[m
[32m+[m[32mdef grafico(data, slider, grade):#relayoutData):[m
[32m+[m[32m  if len(data) ==  int(slider) and grade != None:[m
[32m+[m[41m      [m
[32m+[m[32m      figura = go.Figure()[m
[32m+[m[41m    [m
[32m+[m[32m      figura.add_trace(go.Scatter(x=[i for i in range(len(grade['pontos_no_aumento_grade']))], y=grade['pontos_no_aumento_grade'], showlegend=True, name='Intersecções'))[m
[32m+[m[32m      figura.add_trace(go.Scatter(x=[i for i in range(len(grade['inseridas_no_aumento_grade']))], y=grade['inseridas_no_aumento_grade'], showlegend=True, name='Palavras Inseridas'))[m
[32m+[m[41m    [m
[32m+[m[32m      figura.update_layout([m
[32m+[m[32m            {'hovermode': 'x unified',[m
[32m+[m[32m            'legend': {[m
[32m+[m[32m                        'yanchor': 'top',[m
[32m+[m[32m                        'y':1,[m
[32m+[m[32m                        'xanchor': 'left',[m
[32m+[m[32m                        'x':0,[m
[32m+[m[32m                        'title': {'text': None},[m
[32m+[m[32m                        'font': {'color': 'white'},[m
[32m+[m[32m                        'bgcolor': 'rgba(0,0,0,0.5)'[m
[32m+[m[32m                      },[m
[32m+[m[32m            'margin': {'l':10, 'r': 10, 't':10, 'b':10}},[m
[32m+[m[32m            #title='Gráfico de Linha com Valores de Eixo X',[m
[32m+[m	[32m    plot_bgcolor='white',[m
[32m+[m[32m            xaxis=dict(title='Epócas de execução'),[m
[32m+[m[32m            yaxis=dict(title='Intersecções / Palavras inseridas'),[m
[32m+[m[32m            xaxis_showgrid=True,[m
[32m+[m[32m            yaxis_showgrid=True,[m
[32m+[m	[32m    xaxis_gridcolor='gray',[m
[32m+[m	[32m    yaxis_gridcolor='gray',[m
[32m+[m[32m            xaxis_nticks= len(grade['pontos_no_aumento_grade']),[m
[32m+[m[32m            yaxis_nticks=max(grade['pontos_no_aumento_grade']) if max(grade['pontos_no_aumento_grade']) >= max(grade['inseridas_no_aumento_grade']) else max(grade['inseridas_no_aumento_grade'])[m
[32m+[m[41m    [m
[32m+[m[32m      )[m
[32m+[m[41m      [m
[32m+[m[32m      return figura[m[41m [m
[32m+[m[32m  else:[m
[32m+[m[32m      raise PreventUpdate[m
[32m+[m[41m      [m
[32m+[m[32m@app.callback([m
[32m+[m[32m    Output('resumo', 'children'),[m
[32m+[m[32m    Input('table', 'data'),[m
[32m+[m[32m    State('interval-slider', 'value'),[m
[32m+[m[32m    Input('classe_grade', 'data'),[m
[32m+[m[32m    prevent_initial_call=True[m
[32m+[m[32m)[m
[32m+[m[32mdef resumo(data, slider, grade):[m
[32m+[m[32m    if len(data) ==  int(slider):[m
[32m+[m[32m        dados_resumo = [html.Span('RESUMO DA EXECUÇÃO'), html.Br(),[m
[32m+[m[32m            html.Span(f"Tempo de execução: {grade['tempo_execucao']} segundos"), html.Br(),[m
[32m+[m[32m            html.Span(f"Quantidade de palavras: {grade['n_palavras_inseridas']}"), html.Br(),[m
[32m+[m[32m            html.Span(f"Vezes que a grade foi resetada: {grade['quant_grade_resetado']}"),html.Br(),[m
[32m+[m[32m            html.Span(f"Grade (X,Y): {grade['x_grade']}x{grade['y_grade']}")[m[41m [m
[32m+[m[32m        ][m
[32m+[m[32m        return dados_resumo[m
[32m+[m
[32m+[m[32m@app.callback([m
[32m+[m[32m    Output('reesecutar-coletor', 'children'),[m
[32m+[m[32m    Output('classe_coletor_palavras', 'data'),[m
[32m+[m[32m    Input('intervalo', 'n_intervals')[m
[32m+[m[32m)[m
[32m+[m[32mdef atualizar_coletor(n_intervalo):[m
[32m+[m[41m    [m
[32m+[m[32m    coletor = Coletor_palavras(link,tamanho_maximo_palavras)[m
[32m+[m[41m    [m
[32m+[m[32m    base = {'base_de_dados_palavras': coletor.coletar()}[m
[32m+[m[41m    [m
[32m+[m[32m    current_time = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")[m
[32m+[m[32m    return f"Data hora reesecução do coletor: {current_time}", base[m
[32m+[m[41m    [m
[32m+[m[32mif __name__ == '__main__':[m
[32m+[m[32m    app.run_server(debug=True, host='0.0.0.0', port=8050)[m
[1mdiff --git a/coletor.py b/coletor.py[m
[1mnew file mode 100644[m
[1mindex 0000000..820b9a9[m
[1m--- /dev/null[m
[1m+++ b/coletor.py[m
[36m@@ -0,0 +1,40 @@[m
[32m+[m[32m#!/usr/bin/env python3[m
[32m+[m[32m# -*- coding: utf-8 -*-[m
[32m+[m[32m"""[m
[32m+[m[32mCreated on Mon Oct 16 21:16:47 2023[m
[32m+[m
[32m+[m[32m@author: andre[m
[32m+[m[32m"""[m
[32m+[m
[32m+[m[32mimport requests[m
[32m+[m[32mimport random[m
[32m+[m[32mfrom unidecode import unidecode[m
[32m+[m
[32m+[m[32mclass Coletor_palavras:[m
[32m+[m[32m    def __init__(self, url, max_tamanho_palavra):[m
[32m+[m[32m        self.__url = url[m
[32m+[m[32m        self.__max_tamanho = max_tamanho_palavra[m
[32m+[m[41m    [m
[32m+[m[32m    def formata_palavras(self, p):[m
[32m+[m[32m        p = p.upper()[m
[32m+[m[32m        #p = unidecode(p)[m
[32m+[m[32m        return p[m
[32m+[m[32m    def coletar(self):[m
[32m+[m[32m        try:[m
[32m+[m[32m            resposta = requests.get(self.__url)[m
[32m+[m[32m            resposta.raise_for_status()[m
[32m+[m[41m            [m
[32m+[m[32m            conteudo = resposta.text[m
[32m+[m[32m            lista_palavras = conteudo.split()[m
[32m+[m[41m            [m
[32m+[m[32m            random.shuffle(lista_palavras)[m
[32m+[m[41m            [m
[32m+[m[32m            return 0, [unidecode(p) for p in lista_palavras if len(p) <= self.__max_tamanho][m
[32m+[m[41m        [m
[32m+[m[32m        except requests.exceptions.RequestException as e:[m
[32m+[m[32m            return -1, 'Erro na solicitação: '.format(e)[m
[32m+[m[32m        except Exception as e:[m
[32m+[m[32m            return -2, 'Erro inesperado: '.format(e)[m[41m    [m
[32m+[m[41m            [m
[32m+[m[32m#teste = Coletor_palavras('https://www.ime.usp.br/~pf/dicios/br-sem-acentos.txt',10)[m
[32m+[m[32m#print(teste.coletar())[m
[1mdiff --git a/criarCrossly.py b/criarCrossly.py[m
[1mnew file mode 100644[m
[1mindex 0000000..1c1b13c[m
[1m--- /dev/null[m
[1m+++ b/criarCrossly.py[m
[36m@@ -0,0 +1,247 @@[m
[32m+[m[32m#!/usr/bin/env python3[m
[32m+[m[32m# -*- coding: utf-8 -*-[m
[32m+[m[32m"""[m
[32m+[m[32mCreated on Mon Oct 16 21:30:47 2023[m
[32m+[m
[32m+[m[32m@author: andre[m
[32m+[m[32m"""[m
[32m+[m
[32m+[m[32mimport random[m[41m [m
[32m+[m[32mimport numpy as np[m
[32m+[m[32mimport time[m
[32m+[m[32mfrom datetime import datetime[m
[32m+[m
[32m+[m[32m#from coletor import Coletor_palavras[m
[32m+[m
[32m+[m[32mclass Criar_crossly:[m
[32m+[m[32m    def __init__(self, palavras, x_grade, y_grade):[m
[32m+[m[32m      #grade = [[' ' for _ in range(15)] for _ in range(10)][m
[32m+[m[32m      self._grade = np.array([[' ' for _ in range(y_grade)] for _ in range(x_grade)])[m
[32m+[m[32m      self._x_grade = x_grade[m
[32m+[m[32m      self._y_grade = y_grade[m
[32m+[m[32m      self._lista_de_palavras = palavras[m
[32m+[m[32m      self._palavras_inseridas = dict()[m
[32m+[m[32m      self._palavras_nao_inseridas = [][m
[32m+[m[41m      [m
[32m+[m[32m    #calcular vocais das palavras[m
[32m+[m[32m    def procurar_vogais(self, palavra):[m
[32m+[m[32m      vogais = ['a', 'e', 'i', 'o', 'u'][m
[32m+[m[32m      calculo = sum(1 if letra in palavra else 0 for letra in vogais)[m
[32m+[m[32m      return calculo[m
[32m+[m[41m  [m
[32m+[m[32m    #Reordenar palavras da lista com as palavras que tem mais vogais para o inicio da lista[m
[32m+[m[32m    def reordenar_por_vogais(self, lista):[m
[32m+[m[32m      dicionario = dict()[m
[32m+[m[32m      for palavra in lista:[m
[32m+[m[32m        dicionario[palavra] =  self.procurar_vogais(palavra)[m
[32m+[m[32m      dicionario=dict(sorted(dicionario.items(), key=lambda item: item[1], reverse=True))[m
[32m+[m[32m      return list(dicionario.keys())[m
[32m+[m[41m  [m
[32m+[m[32m    #verificar interseccao de cada palavra a ser inserida com as palavras já inserida na grade[m
[32m+[m[32m    def verificar_intersecao(self, palavra, x, y, direcao):[m
[32m+[m[32m        cont = 0[m
[32m+[m[32m        pontos_interseccao = 0[m
[32m+[m[32m        if direcao == 'horizontal':[m
[32m+[m[32m            #for i in range(len(palavra)):[m
[32m+[m[32m            #    #if grade[x][y+i] != ' ' and[m
[32m+[m[32m            #    #if grade[x][y+i] != ' ':[m
[32m+[m[32m            #      if grade[x][y+i] == palavra[i]:[m
[32m+[m[32m            #        cont += 1[m
[32m+[m[32m          conjunto = ''.join(map(str,set(self._grade[x, y:y+len(palavra)-1]) & set(palavra)))[m
[32m+[m[32m          pontos_interseccao = len(conjunto)#self.calculate_word_points(conjunto)[m
[32m+[m[32m          cont = len(conjunto)[m
[32m+[m[32m        elif direcao == 'vertical':[m
[32m+[m[32m          #for i in range(len(palavra)):[m
[32m+[m[32m          #    #if grade[x+i][y] != ' ' and grade[x+i][y] != palavra[i]:[m
[32m+[m[32m          #    #if grade[x+i][y] != ' ':[m
[32m+[m[32m          #      if grade[x+i][y] == palavra[i]:[m
[32m+[m[32m          #        cont += 1[m
[32m+[m[32m          conjunto = ''.join(map(str,set(self._grade[x:x+len(palavra)-1, y]) & set(palavra)))[m
[32m+[m[32m          pontos_interseccao = len(conjunto)#self.calculate_word_points(conjunto)[m
[32m+[m[32m          cont = len(conjunto)[m
[32m+[m[32m        if cont > 0:[m
[32m+[m[32m          #print('interc: ',cont)[m
[32m+[m[32m          return True, pontos_interseccao[m
[32m+[m[32m        return False, 0[m
[32m+[m[41m    [m
[32m+[m[32m    #verificar se a palavra a ser inserida cabe na grade na posicao x,y que foi indicada[m
[32m+[m[32m    def cabe_a_palavra(self, palavra, x, y, direcao):[m
[32m+[m[32m      if direcao == 'horizontal':[m
[32m+[m[32m        for i in range(len(palavra)):[m
[32m+[m[32m          if self._grade[x][y+i] != ' ' and self._grade[x][y+i] != palavra[i]:[m
[32m+[m[32m            return False[m
[32m+[m[32m        #if str(grade[x, y:y+len(palavra)]) != palavra and ''.join(str(grade[x, y:y+len(palavra)])) != ' ':[m
[32m+[m[32m        #   return False[m
[32m+[m[32m      elif direcao == 'vertical':[m
[32m+[m[32m        for i in range(len(palavra)):[m
[32m+[m[32m          if self._grade[x+i][y] != ' ' and self._grade[x+i][y] != palavra[i]:[m
[32m+[m[32m            return False[m
[32m+[m[32m        #if str(grade[x:x+len(palavra), y]) != palavra and ''.join(str(grade[x:x+len(palavra), y]) ) != ' ':[m
[32m+[m[32m        #   return False[m
[32m+[m[32m      return True[m
[32m+[m[41m  [m
[32m+[m[32m    #inserir a palavra na grade[m
[32m+[m[32m    def inserir_palavra(self, palavra, x, y, direcao):[m
[32m+[m[32m        if direcao == 'horizontal':[m
[32m+[m[32m            y_letra = 0[m
[32m+[m[32m            for i in range(len(palavra)):[m
[32m+[m[32m                self._grade[x,y+i] = palavra[i][m
[32m+[m[32m                y_letra = y+i[m
[32m+[m[32m            return f'{x},{y}:{y_letra}'[m
[32m+[m[32m        elif direcao == 'vertical':[m
[32m+[m[32m            x_letra = 0[m
[32m+[m[32m            for i in range(len(palavra)):[m
[32m+[m[32m                self._grade[x+i,y] = palavra[i][m
[32m+[m[32m                x_letra = x+i[m
[32m+[m[32m            return f'{x}:{x_letra},{y}'[m
[32m+[m[41m        [m
[32m+[m[32m    def iniciar(self):[m
[32m+[m[32m      x = (self._x_grade-1) // 2#random.randint(0, self._x_grade-1)[m
[32m+[m[32m      y = (self._y_grade-1)//2#random.randint(0, self._y_grade-1)[m
[32m+[m[32m      direcao = random.choice(['horizontal', 'vertical'])[m
[32m+[m[32m      #random.shuffle(palavras)[m
[32m+[m[32m      #palavras = self.reordenar(self._lista_de_palavras)[m
[32m+[m[32m      palavras = sorted(self._lista_de_palavras.copy(), key=len, reverse=True)[m
[32m+[m[32m      #palavras = sorted(self._lista_de_palavras.copy())[m
[32m+[m[32m      #palavras = self.reordenar_por_vogais(self._lista_de_palavras.copy())[m
[32m+[m[32m      palavra = palavras.pop(0)[m
[32m+[m
[32m+[m[32m      total_pontos = 0[m
[32m+[m[32m      if (direcao == 'horizontal' and (self._y_grade - y) >= len(palavra)) or (direcao == 'vertical' and (self._x_grade - x) >= len(palavra)):[m
[32m+[m[32m            coordenadas = self.inserir_palavra(palavra, x, y, direcao)[m
[32m+[m[32m            self._palavras_inseridas[coordenadas]  = palavra[m
[32m+[m[32m            #print(palavras_inseridas)[m
[32m+[m
[32m+[m[32m      while palavras:[m
[32m+[m[32m          #random.shuffle(palavras)[m
[32m+[m[32m          palavra = palavras.pop(0)[m
[32m+[m[32m          encontrada = False[m
[32m+[m[32m          for _ in range(500):[m
[32m+[m[32m              x = random.randint(0, self._x_grade-1)[m
[32m+[m[32m              y = random.randint(0, self._y_grade-1)[m
[32m+[m[32m              direcao = random.choice(['horizontal', 'vertical'])[m
[32m+[m
[32m+[m[32m              if (direcao == 'horizontal' and (self._y_grade - y) >= len(palavra)) or (direcao == 'vertical' and (self._x_grade - x) >= len(palavra)):[m
[32m+[m[32m                  tem_interseccao, pontos = self.verificar_intersecao(palavra, x, y, direcao)[m
[32m+[m[32m                  if tem_interseccao:[m
[32m+[m[32m                    if self.cabe_a_palavra(palavra, x, y, direcao):[m
[32m+[m[32m                      coordenadas = self.inserir_palavra(palavra, x, y, direcao)[m
[32m+[m[32m                      #self._palavras_inseridas.append(palavra)[m
[32m+[m[32m                      self._palavras_inseridas[coordenadas]  = palavra[m
[32m+[m[32m                      encontrada = True[m
[32m+[m[32m                      total_pontos += pontos[m
[32m+[m[32m                      #print('inserida: ', palavra)[m
[32m+[m[32m                      break[m
[32m+[m[32m                  else:[m
[32m+[m[32m                    pontos = 0[m
[32m+[m
[32m+[m
[32m+[m[32m          if not encontrada:[m
[32m+[m[32m            self._palavras_nao_inseridas.append(palavra)[m
[32m+[m[32m            #print('naõ encontrada: ', palavra)[m
[32m+[m[32m            #palavras.append(palavra)[m
[32m+[m
[32m+[m[32m      #total_points = calculate_total_points(palavras_inseridas)[m
[32m+[m
[32m+[m[32m      return self._grade, total_pontos, self._palavras_nao_inseridas, len(self._palavras_inseridas), self._palavras_inseridas[m
[32m+[m[41m  [m
[32m+[m
[32m+[m[32mclass Gerar_grade:[m
[32m+[m[32m    def __init__(self, quant_palavras, base_dados_palavras):[m
[32m+[m[32m        self.__quant_palavras = quant_palavras[m
[32m+[m[32m        self.__classe_coletor = base_dados_palavras #Coletor_palavras('https://www.ime.usp.br/~pf/dicios/br-sem-acentos.txt',10)[m
[32m+[m[32m        self.__palavras = [][m
[32m+[m[41m        [m
[32m+[m[32m        self.__y_grade = 10[m
[32m+[m[32m        self.__x_grade = 15[m
[32m+[m[41m        [m
[32m+[m[32m        self.__n_palavras_inseridas =0[m
[32m+[m[32m        self.__grade_caca_palavras = 0[m
[32m+[m[32m        self.__quant_grade_resetado = 0[m
[32m+[m[32m        self.__inicio_tempo = 0[m
[32m+[m[32m        self.__fim_tempo = 0[m
[32m+[m[32m        self.__palavras_inseridas = None[m
[32m+[m[32m        self.__pontos_no_aumento_grade = [][m
[32m+[m[32m        self.__inseridas_no_aumento_grade = [][m
[32m+[m[41m        [m
[32m+[m[32m    def gerar(self):[m
[32m+[m[32m        self.__inicio_tempo  = time.time()#datetime.now()[m
[32m+[m[32m        inicio_para_reset = time.time()#datetime.now()[m
[32m+[m[41m        [m
[32m+[m[32m        #tratar a variavel error[m
[32m+[m[32m        erro, palavras_filtradas = self.__classe_coletor#.coletar()[m
[32m+[m[41m        [m
[32m+[m[32m        random.shuffle(palavras_filtradas)[m
[32m+[m
[32m+[m[32m        for cont, palavra in enumerate(palavras_filtradas):[m
[32m+[m[32m            if cont+1 <= self.__quant_palavras:[m
[32m+[m[32m              self.__palavras.append(palavra)[m
[32m+[m[32m            else:[m
[32m+[m[32m              break[m
[32m+[m[41m          [m
[32m+[m[32m        pontos = 0[m
[32m+[m[32m        tentativas = 0[m
[32m+[m[41m        [m
[32m+[m[32m        cont_intersecoes = 0[m
[32m+[m[41m        [m
[32m+[m[41m        [m
[32m+[m[32m        while True:[m
[32m+[m[32m            palavra = self.__palavras.copy()[m
[32m+[m[32m            criando = Criar_crossly(palavra, self.__y_grade, self.__x_grade)[m
[32m+[m[32m            self.__grade_caca_palavras, pontos, palavras_nao_inseridas, self.__n_palavras_inseridas, self.__palavras_inseridas = criando.iniciar()[m
[32m+[m[32m            self.__pontos_no_aumento_grade.append(pontos)[m
[32m+[m[32m            self.__inseridas_no_aumento_grade.append(self.__n_palavras_inseridas)[m
[32m+[m[32m            #tentativas += 1[m
[32m+[m[32m            if pontos != 0 and self.__n_palavras_inseridas >= self.__quant_palavras:[m
[32m+[m[32m              break[m
[32m+[m[32m            elif (time.time() - inicio_para_reset) > 10:[m
[32m+[m[32m              inicio_para_reset = time.time()[m
[32m+[m[32m              self.__quant_grade_resetado += 1[m
[32m+[m[32m              self.__y_grade = 10[m
[32m+[m[32m              self.__x_grade = 15[m
[32m+[m[32m            else:[m[41m [m
[32m+[m[32m              self.__y_grade += 1[m
[32m+[m[32m              self.__x_grade += 1[m
[32m+[m[32m        self.__fim_tempo = time.time()[m
[32m+[m[41m        [m
[32m+[m[32m    @property[m
[32m+[m[32m    def y_grade(self):[m
[32m+[m[32m        return self.__y_grade[m
[32m+[m[32m    @property[m
[32m+[m[32m    def x_grade(self):[m
[32m+[m[32m        return self.__x_grade[m
[32m+[m[32m    @property[m
[32m+[m[32m    def n_palavras_inseridas(self):[m
[32m+[m[32m        return self.__n_palavras_inseridas[m
[32m+[m[32m    @property[m
[32m+[m[32m    def grade_caca_palavras(self):[m
[32m+[m[32m        return self.__grade_caca_palavras[m
[32m+[m[32m    @property[m
[32m+[m[32m    def quant_grade_resetado(self):[m
[32m+[m[32m        return self.__quant_grade_resetado[m
[32m+[m[32m    @property[m
[32m+[m[32m    def inicio_tempo(self):[m
[32m+[m[32m        return self.__inicio_tempo[m
[32m+[m[32m    @property[m
[32m+[m[32m    def fim_tempo(self):[m
[32m+[m[32m        return self.__fim_tempo[m
[32m+[m[32m    @property[m
[32m+[m[32m    def tempo_execucao(self):[m
[32m+[m[32m        return "{:.2f}".format(self.__fim_tempo - self.__inicio_tempo)[m
[32m+[m[32m    @property[m
[32m+[m[32m    def palavras_inseridas(self):[m
[32m+[m[32m        return self.__palavras_inseridas[m
[32m+[m[32m    @property[m
[32m+[m[32m    def pontos_no_aumento_grade(self):[m
[32m+[m[32m        return self.__pontos_no_aumento_grade[m
[32m+[m[32m    @property[m
[32m+[m[32m    def inseridas_no_aumento_grade(self):[m
[32m+[m[32m        return self.__inseridas_no_aumento_grade[m
[32m+[m[41m    [m
[32m+[m[32m#if __name__ == '__main__':[m
[32m+[m[32m#    coletor = Coletor_palavras('https://www.ime.usp.br/~pf/dicios/br-sem-acentos.txt',10)[m
[32m+[m[32m#    base_de_dados_palavras = coletor.coletar()[m
[32m+[m[32m#    grade = Gerar_grade(20,base_de_dados_palavras)[m
[32m+[m[32m#    grade.gerar()[m
[32m+[m[32m#    for linha in grade.grade_caca_palavras:[m
[32m+[m[32m#        print('|','{}|'.format(' '.join(linha)))[m
[1mdiff --git a/requirements.txt b/requirements.txt[m
[1mnew file mode 100644[m
[1mindex 0000000..283b70a[m
[1m--- /dev/null[m
[1m+++ b/requirements.txt[m
[36m@@ -0,0 +1,37 @@[m
[32m+[m[32mansi2html==1.8.0[m
[32m+[m[32maws-cfn-bootstrap==2.0[m
[32m+[m[32mcertifi==2023.7.22[m
[32m+[m[32mcharset-normalizer==3.3.0[m
[32m+[m[32mclick==8.1.7[m
[32m+[m[32mdash==2.14.0[m
[32m+[m[32mdash-bootstrap-components==1.5.0[m
[32m+[m[32mdash-core-components==2.0.0[m
[32m+[m[32mdash-html-components==2.0.0[m
[32m+[m[32mdash-table==5.0.0[m
[32m+[m[32mdocutils==0.14[m
[32m+[m[32mFlask==2.2.5[m
[32m+[m[32midna==3.4[m
[32m+[m[32mimportlib-metadata==6.7.0[m
[32m+[m[32mitsdangerous==2.1.2[m
[32m+[m[32mJinja2==3.1.2[m
[32m+[m[32mlockfile==0.11.0[m
[32m+[m[32mMarkupSafe==2.1.3[m
[32m+[m[32mnest-asyncio==1.5.8[m
[32m+[m[32mnumpy==1.21.6[m
[32m+[m[32mpackaging==23.2[m
[32m+[m[32mpandas==1.3.5[m
[32m+[m[32mplotly==5.17.0[m
[32m+[m[32mpystache==0.5.4[m
[32m+[m[32mpython-daemon==2.2.3[m
[32m+[m[32mpython-dateutil==2.8.2[m
[32m+[m[32mpytz==2023.3.post1[m
[32m+[m[32mrequests==2.31.0[m
[32m+[m[32mretrying==1.3.4[m
[32m+[m[32msimplejson==3.2.0[m
[32m+[m[32msix==1.16.0[m
[32m+[m[32mtenacity==8.2.3[m
[32m+[m[32mtyping-extensions==4.7.1[m
[32m+[m[32mUnidecode==1.3.7[m
[32m+[m[32murllib3==2.0.6[m
[32m+[m[32mWerkzeug==2.2.3[m
[32m+[m[32mzipp==3.15.0[m
