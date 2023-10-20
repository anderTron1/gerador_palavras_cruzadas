#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Oct 16 21:30:47 2023

@author: andre

Nessa parte do algoritmo executa separadamente do app,
pois aqui vou executar o algoritmo 30 vezes para pegar reslultados
"""

import random 
import numpy as np
import time
from datetime import datetime

from coletor import Coletor_palavras

class Criar_crossly:
    def __init__(self, palavras, x_grade, y_grade):
      self._grade = np.array([[' ' for _ in range(y_grade)] for _ in range(x_grade)])
      self._x_grade = x_grade
      self._y_grade = y_grade
      self._lista_de_palavras = palavras
      self._palavras_inseridas = dict()
      self._palavras_nao_inseridas = []
      
    #calcular vocais das palavras
    def procurar_vogais(self, palavra):
      vogais = ['a', 'e', 'i', 'o', 'u']
      calculo = sum(1 if letra in palavra else 0 for letra in vogais)
      return calculo
  
    #Reordenar palavras da lista com as palavras que tem mais vogais para o inicio da lista
    def reordenar_por_vogais(self, lista):
      dicionario = dict()
      for palavra in lista:
        dicionario[palavra] =  self.procurar_vogais(palavra)
      dicionario=dict(sorted(dicionario.items(), key=lambda item: item[1], reverse=True))
      return list(dicionario.keys())
  
    #verificar interseccao de cada palavra a ser inserida com as palavras já inserida na grade
    def verificar_intersecao(self, palavra, x, y, direcao):
        cont = 0
        pontos_interseccao = 0
        if direcao == 'horizontal':
            #for i in range(len(palavra)):
            #    #if grade[x][y+i] != ' ' and
            #    #if grade[x][y+i] != ' ':
            #      if grade[x][y+i] == palavra[i]:
            #        cont += 1
          conjunto = ''.join(map(str,set(self._grade[x, y:y+len(palavra)-1]) & set(palavra)))
          pontos_interseccao = len(conjunto)#self.calculate_word_points(conjunto)
          cont = len(conjunto)
        elif direcao == 'vertical':
          #for i in range(len(palavra)):
          #    #if grade[x+i][y] != ' ' and grade[x+i][y] != palavra[i]:
          #    #if grade[x+i][y] != ' ':
          #      if grade[x+i][y] == palavra[i]:
          #        cont += 1
          conjunto = ''.join(map(str,set(self._grade[x:x+len(palavra)-1, y]) & set(palavra)))
          pontos_interseccao = len(conjunto)#self.calculate_word_points(conjunto)
          cont = len(conjunto)
        if cont > 0:
          #print('interc: ',cont)
          return True, pontos_interseccao
        return False, 0
    
    #verificar se a palavra a ser inserida cabe na grade na posicao x,y que foi indicada
    def cabe_a_palavra(self, palavra, x, y, direcao):
      if direcao == 'horizontal':
        for i in range(len(palavra)):
          if self._grade[x][y+i] != ' ' and self._grade[x][y+i] != palavra[i]:
            return False
        #if str(grade[x, y:y+len(palavra)]) != palavra and ''.join(str(grade[x, y:y+len(palavra)])) != ' ':
        #   return False
      elif direcao == 'vertical':
        for i in range(len(palavra)):
          if self._grade[x+i][y] != ' ' and self._grade[x+i][y] != palavra[i]:
            return False
        #if str(grade[x:x+len(palavra), y]) != palavra and ''.join(str(grade[x:x+len(palavra), y]) ) != ' ':
        #   return False
      return True
  
    #inserir a palavra na grade
    def inserir_palavra(self, palavra, x, y, direcao):
        if direcao == 'horizontal':
            y_letra = 0
            for i in range(len(palavra)):
                self._grade[x,y+i] = palavra[i]
                y_letra = y+i
            return f'{x},{y}:{y_letra}'
        elif direcao == 'vertical':
            x_letra = 0
            for i in range(len(palavra)):
                self._grade[x+i,y] = palavra[i]
                x_letra = x+i
            return f'{x}:{x_letra},{y}'
        
    def iniciar(self):
      x = (self._x_grade-1) // 2#random.randint(0, self._x_grade-1)
      y = (self._y_grade-1)//2#random.randint(0, self._y_grade-1)
      direcao = random.choice(['horizontal', 'vertical'])
      
      #Executar por maiores palavras
      palavras = sorted(self._lista_de_palavras.copy(), key=len, reverse=True)
      
      #Executar por aleatoriedade
      #palavras = sorted(self._lista_de_palavras.copy())
      
      #Executar por palavras que tem mais vogais
      #palavras = self.reordenar_por_vogais(self._lista_de_palavras.copy())
      palavra = palavras.pop(0)

      total_pontos = 0
      if (direcao == 'horizontal' and (self._y_grade - y) >= len(palavra)) or (direcao == 'vertical' and (self._x_grade - x) >= len(palavra)):
           coordenadas = self.inserir_palavra(palavra, x, y, direcao)
           self._palavras_inseridas[coordenadas]  = palavra
           
           while palavras:
              #random.shuffle(palavras)
              palavra = palavras.pop(0)
              encontrada = False
              for _ in range(500):
                  x = random.randint(0, self._x_grade-1)
                  y = random.randint(0, self._y_grade-1)
                  direcao = random.choice(['horizontal', 'vertical'])
    
                  if (direcao == 'horizontal' and (self._y_grade - y) >= len(palavra)) or (direcao == 'vertical' and (self._x_grade - x) >= len(palavra)):
                      tem_interseccao, pontos = self.verificar_intersecao(palavra, x, y, direcao)
                      if tem_interseccao:
                        if self.cabe_a_palavra(palavra, x, y, direcao):
                          coordenadas = self.inserir_palavra(palavra, x, y, direcao)
                          self._palavras_inseridas[coordenadas] = palavra
                          encontrada = True
                          total_pontos += pontos
                          break
                      else:
                        pontos = 0
    
    
              if not encontrada:
                self._palavras_nao_inseridas.append(palavra)

      return self._grade, total_pontos, self._palavras_nao_inseridas, len(self._palavras_inseridas), self._palavras_inseridas
  

class Gerar_grade:
    def __init__(self, quant_palavras, base_dados_palavras):
        self.__quant_palavras = quant_palavras
        self.__classe_coletor = base_dados_palavras #Coletor_palavras('https://www.ime.usp.br/~pf/dicios/br-sem-acentos.txt',10)
        self.__palavras = []
        
        self.__y_grade = 10
        self.__x_grade = 15
        
        self.__n_palavras_inseridas =0
        self.__grade_caca_palavras = 0
        self.__quant_grade_resetado = 0
        self.__inicio_tempo = 0
        self.__fim_tempo = 0
        self.__palavras_inseridas = None
        self.__pontos_no_aumento_grade = []
        self.__inseridas_no_aumento_grade = []
        self.salvar_tempo = []
        self.salvar_reesecucao = []
        self.salvar_grade_x = []
        self.salvar_grade_y = []
	
        
    def gerar(self):
        contar = 0
        while True:
          self.__palavras = []
          self.__y_grade = 10
          self.__x_grade = 15
          self.__n_palavras_inseridas =0
          self.__grade_caca_palavras = 0
          self.__quant_grade_resetado = 0
          self.__inicio_tempo = 0
          self.__fim_tempo = 0
          self.__palavras_inseridas = None
          self.__pontos_no_aumento_grade = []
          self.__inseridas_no_aumento_grade = []
          self.__inicio_tempo  = time.time()#datetime.now()
          inicio_para_reset = time.time()#datetime.now()

          #tratar a variavel error
          erro, palavras_filtradas = self.__classe_coletor#.coletar()

          random.shuffle(palavras_filtradas)

          for cont, palavra in enumerate(palavras_filtradas):
            if cont+1 <= self.__quant_palavras:
              self.__palavras.append(palavra)
            else:
              break
          pontos = 0
          tentativas = 0        
          cont_intersecoes = 0
          while True:
            palavra = self.__palavras.copy()
            criando = Criar_crossly(palavra, self.__y_grade, self.__x_grade)
            self.__grade_caca_palavras, pontos, palavras_nao_inseridas, self.__n_palavras_inseridas, self.__palavras_inseridas = criando.iniciar()
            self.__pontos_no_aumento_grade.append(pontos)
            self.__inseridas_no_aumento_grade.append(self.__n_palavras_inseridas)
            #tentativas += 1
            if pontos != 0 and self.__n_palavras_inseridas >= self.__quant_palavras:
              break
            elif (time.time() - inicio_para_reset) > 10:
                inicio_para_reset = time.time()
                self.__quant_grade_resetado += 1
                self.__y_grade = 10
                self.__x_grade = 15
            else: 
                self.__y_grade += 1
                self.__x_grade += 1
          self.__fim_tempo = time.time()
          contar +=1
          print(contar)
          self.salvar_tempo.append(round(self.__fim_tempo-self.__inicio_tempo,2))
          self.salvar_reesecucao.append(self.__quant_grade_resetado)
          self.salvar_grade_x.append(self.__x_grade)
          self.salvar_grade_y.append(self.__y_grade)
          
          #Parar algoritmo quando executar 30 vezes
          if contar >= 30:
              print('Finalizado')
              break 
    @property
    def y_grade(self):
        return self.__y_grade
    @property
    def x_grade(self):
        return self.__x_grade
    @property
    def n_palavras_inseridas(self):
        return self.__n_palavras_inseridas
    @property
    def grade_caca_palavras(self):
        return self.__grade_caca_palavras
    @property
    def quant_grade_resetado(self):
        return self.__quant_grade_resetado
    @property
    def inicio_tempo(self):
        return self.__inicio_tempo
    @property
    def fim_tempo(self):
        return self.__fim_tempo
    @property
    def tempo_execucao(self):
        return "{:.2f}".format(self.__fim_tempo - self.__inicio_tempo)
    @property
    def palavras_inseridas(self):
        return self.__palavras_inseridas
    @property
    def pontos_no_aumento_grade(self):
        return self.__pontos_no_aumento_grade
    @property
    def inseridas_no_aumento_grade(self):
        return self.__inseridas_no_aumento_grade

import pandas as pd
if __name__ == '__main__':
    coletor = Coletor_palavras('https://www.ime.usp.br/~pf/dicios/br-sem-acentos.txt',10)
    base_de_dados_palavras = coletor.coletar()
    grade = Gerar_grade(20,base_de_dados_palavras)
    grade.gerar()
    
    #vai executar a grade da ultima execução
    for linha in grade.grade_caca_palavras:
        print('|','{}|'.format(' '.join(linha)))

    #Coletar os resultados das 30 execuções do codigo
    #fazer o texto para cada uma das opções, executar por
    #maiores palavras
    #aleatorieade
    #por palavras com maiores vogais
    #Essa definição é feita na linha 106 onde define quais metodos usar
    dicio = dict()
    dicio['tempo'] = grade.salvar_tempo
    dicio['reesecucao'] = grade.salvar_reesecucao
    dicio['grade_x'] = grade.salvar_grade_x
    dicio['grade_y'] = grade.salvar_grade_y
    df_analitico = pd.DataFrame(dicio)
    df_analitico.to_csv('por_palavra_maiores_20.csv', index=False)
    print('Execução 30 veses por palavras maiores 20 palavras')
    print('Tempo:', df_analitico['tempo'].mean())
    print('Soma de Reesecução:', df_analitico['reesecucao'].sum())
    print('media da Grade: {}x{}'.format(int(df_analitico['grade_x'].mean()), int(df_analitico['grade_y'].mean())))
