#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Oct 16 22:15:24 2023

@author: andre
"""

import dash
from dash import Input, Output,ctx, State, html, dcc, dash_table
#import dash_core_components as dcc
import dash_bootstrap_components as dbc
#import dash_html_components as html
#import dash_table
import plotly.graph_objs as go
from dash.exceptions import PreventUpdate
import pandas as pd
import datetime

from criarCrossly import Gerar_grade
from coletor import Coletor_palavras
#grade = Gerar_grade(50)
#grade.gerar()


app = dash.Dash(__name__, external_stylesheets=[dbc.themes.JOURNAL])


def coordenadas(coordenada):
  coordenada = coordenada.split(',')
  if coordenada[0].find(':') != -1:
    step_x, stop_x = map(int, str(coordenada[0:1][0]).split(':'))
    start_y = int(coordenada[1])
    return step_x, stop_x, start_y, 1
  else:
    step_y, stop_y = map(int, str(coordenada[1:2][0]).split(':'))
    start_x = int(coordenada[0])
    return step_y, stop_y, start_x, 2

link = 'http://crozzle.s3-website-us-east-1.amazonaws.com/palavras.txt'
tamanho_maximo_palavras = 10

coletor = Coletor_palavras(link, tamanho_maximo_palavras)
base_de_palavras = coletor.coletar()


app.layout = html.Div([
    
  dcc.Store(id='classe_grade', data=None),
  dcc.Store(id='classe_coletor_palavras', data={'base_de_dados_palavras':base_de_palavras}),
  dbc.Row([
      html.Div()#html.P('GERADOR DE PALAVRAS GRUÇADAS')
  ]),
  dbc.Row([
      dbc.Col(
          dbc.Card([
            #html.H4('Grade'),
            dcc.Loading(id='loading', children=[
                html.Div(id='grade', children=[
                    dash_table.DataTable(
                         id='table1',
                         columns=[],
                         data=[],
                        style_cell={'widht': '5px','height': '5px', 'textAlign': 'center'},
                        style_table={'minWidht': '100px','minHeight': '100px', 'overflowY': 'auto'}
                    )
                ])
            ])
          ], style={'padding': '10px', 'margin': '20px'}),sm=8),
      dbc.Col(
          dbc.Card([
            dbc.Row([
                dbc.Card([
                    html.H4("Quantidade de palavra a inserir"),
                    dcc.Slider(
                        id='interval-slider',
                        min=5,
                        max=50,
                        step=5,  # Pula de 5 em 5
                        value=5,  # Valor inicial
                        marks={i: str(i) for i in range(5, 51, 5)},  # Rótulos do slider
                    ),
                    html.Button('Gerar', id='gerar_caca_palavras', n_clicks=0)
                ])
            ], style={'padding': '10px'}),
            dbc.Row([
              dbc.Card([
                html.Div([
                    html.P('Palavras inseridas'),
                    html.Div(id='tabela-palavras-inseridas', children=[
                           dash_table.DataTable(
                                id='table',
                                columns=[
                                             {'name': 'Palavras', 'id': 'Palavras'},
                                             {'name': 'Coordenadas', 'id':'Coordenadas'}
                                         ],
                                data=[],
                                row_selectable='single',
                                fixed_rows={'headers':True},
                                style_table={'height': '200px', 'overflowY': 'auto'},
                                style_data={'width': '50px', 'textOverflow': 'ellipsis'},
                                style_cell_conditional=[
                                    {
                                        'if':{'column_id': 'ID'},
                                        'maxWidth':'20px'
                                    }
                                ]
                            )
                        ])
                ]),
              ])
            ],  style={'padding': '10px'}),
            dbc.Row([
              dbc.Card([
                html.Div([
                    #html.P('Tempo de Execução: {} segundos'.format(round(grade.fim_tempo-grade.inicio_tempo,2)), style={'margin':0}),
                    #html.P('Quantidade de palavras: {}'.format(grade.n_palavras_inseridas), style={'margin':0}),
                    #html.P('Vezes que a grade foi resetado: {}'.format(grade.quant_grade_resetado), style={'margin':0}),
                    html.P(id='resumo', children='Resumo dos resultados')
                ])
              ])
            ], style={'padding': '10px'}),
            dbc.Row([
                dcc.Graph(id='grafico-interseccoes', config={'displayModeBar': False, 'showTips':False})
                #html.Div(id='valores')
            ]),
	    dbc.Row([
                html.Div('Hora reesecução do coletor: ', id='reesecutar-coletor'),
                dcc.Interval(
                    id='intervalo',
                    interval=1000 * 10,
                    n_intervals=0
                )
            ])
          ], style={'padding': '10px'}),style={'padding': '20px'},sm=4)
  ]),

])

@app.callback(
    [Output('table1', 'data'),
    Output('table1', 'columns'),
    
    Output('table', 'data'),
    Output('table', 'columns'),
    
    Output('table', 'selected_rows'),
    Output('classe_grade', 'data')],
    Input('gerar_caca_palavras', 'n_clicks'),
    State('interval-slider', 'value'),
    State('classe_coletor_palavras', 'data'),
    prevent_initial_call=True
)
def gerar_grade(n_clicks, valor_slider, base_de_palavras):
    if n_clicks != 0:
        n_clicks = 0
        grade = Gerar_grade(int(valor_slider), base_de_palavras['base_de_dados_palavras'])
        grade.gerar()
        
        df = [{str(i): cell for i, cell in enumerate(row)} for row in grade.grade_caca_palavras]
        dicionario = [{'Palavras': itens, 'Coordenadas': chaves} for chaves,itens in grade.palavras_inseridas.items()]
        
        #=========================================
        grade_df = df
        columns_grade=[{'name': str(i), 'id': str(i)} for i in range(grade.grade_caca_palavras.shape[1])]
            
        #===========================================
        tabela_palavras_inseridas = dicionario
        tabela_palavras_columns=[{'name': colum, 'id': colum} for colum in dicionario[0].keys()]
        
        grade = {'pontos_no_aumento_grade': grade.pontos_no_aumento_grade,
                 'inseridas_no_aumento_grade': grade.inseridas_no_aumento_grade,
                 'tempo_execucao': grade.tempo_execucao,
                 'n_palavras_inseridas': grade.n_palavras_inseridas,
                 'quant_grade_resetado': grade.quant_grade_resetado,
                 'y_grade':grade.y_grade, 'x_grade': grade.x_grade
                 }
        
        return grade_df, columns_grade, tabela_palavras_inseridas, tabela_palavras_columns, [], grade

@app.callback(
    Output('table1', 'style_data_conditional'),
    Input('table', 'selected_rows'),
    Input('table', 'data'),
    prevent_initial_call=True
)
def selecionar_palavras_na_grade(selected_rows, data):
  if selected_rows:
    selected_row_index = selected_rows[0]
    selected_row_data = list(data[selected_row_index].values())[1]

    step, stop, start, iniciar_por = coordenadas(selected_row_data)
    if iniciar_por == 2:
      style = [{
          'if': {
             'row_index': start,
              'column_id': str(percorrer)
            },
            'backgroundColor': '#00FFFF'  # Defina a cor desejada
          } for percorrer in range(step, stop+1)
      ]
    else:
      style = [{
          'if': {
             'row_index': percorrer,
              'column_id': str(start)
            },
            'backgroundColor': '#00FFFF'  # Defina a cor desejada
          } for percorrer in range(step, stop+1)
      ]
    style_data_conditional = style

    return style_data_conditional
  return []

@app.callback(
    Output('grafico-interseccoes', 'figure'),
    #Output('valores', 'children'),
    #Input('grafico-interseccoes', 'relayoutData'),
    Input('table', 'data'),
    State('interval-slider', 'value'),
    Input('classe_grade', 'data'),
    prevent_initial_call=True
)
def grafico(data, slider, grade):#relayoutData):
  if len(data) ==  int(slider) and grade != None:
      
      figura = go.Figure()
    
      figura.add_trace(go.Scatter(x=[i for i in range(len(grade['pontos_no_aumento_grade']))], y=grade['pontos_no_aumento_grade'], showlegend=True, name='Intersecções'))
      figura.add_trace(go.Scatter(x=[i for i in range(len(grade['inseridas_no_aumento_grade']))], y=grade['inseridas_no_aumento_grade'], showlegend=True, name='Palavras Inseridas'))
    
      figura.update_layout(
            {'hovermode': 'x unified',
            'legend': {
                        'yanchor': 'top',
                        'y':1,
                        'xanchor': 'left',
                        'x':0,
                        'title': {'text': None},
                        'font': {'color': 'white'},
                        'bgcolor': 'rgba(0,0,0,0.5)'
                      },
            'margin': {'l':10, 'r': 10, 't':10, 'b':10}},
            #title='Gráfico de Linha com Valores de Eixo X',
	    plot_bgcolor='white',
            xaxis=dict(title='Epócas de execução'),
            yaxis=dict(title='Intersecções / Palavras inseridas'),
            xaxis_showgrid=True,
            yaxis_showgrid=True,
	    xaxis_gridcolor='gray',
	    yaxis_gridcolor='gray',
            xaxis_nticks= len(grade['pontos_no_aumento_grade']),
            yaxis_nticks=max(grade['pontos_no_aumento_grade']) if max(grade['pontos_no_aumento_grade']) >= max(grade['inseridas_no_aumento_grade']) else max(grade['inseridas_no_aumento_grade'])
    
      )
      
      return figura 
  else:
      raise PreventUpdate
      
@app.callback(
    Output('resumo', 'children'),
    Input('table', 'data'),
    State('interval-slider', 'value'),
    Input('classe_grade', 'data'),
    prevent_initial_call=True
)
def resumo(data, slider, grade):
    if len(data) ==  int(slider):
        dados_resumo = [html.Span('RESUMO DA EXECUÇÃO'), html.Br(),
            html.Span(f"Tempo de execução: {grade['tempo_execucao']} segundos"), html.Br(),
            html.Span(f"Quantidade de palavras: {grade['n_palavras_inseridas']}"), html.Br(),
            html.Span(f"Vezes que a grade foi resetada: {grade['quant_grade_resetado']}"),html.Br(),
            html.Span(f"Grade (X,Y): {grade['x_grade']}x{grade['y_grade']}") 
        ]
        return dados_resumo

@app.callback(
    Output('reesecutar-coletor', 'children'),
    Output('classe_coletor_palavras', 'data'),
    Input('intervalo', 'n_intervals')
)
def atualizar_coletor(n_intervalo):
    
    coletor = Coletor_palavras(link,tamanho_maximo_palavras)
    
    base = {'base_de_dados_palavras': coletor.coletar()}
    
    current_time = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    return f"Data hora reesecução do coletor: {current_time}", base
    
if __name__ == '__main__':
    app.run_server(debug=True, host='0.0.0.0', port=8050)
