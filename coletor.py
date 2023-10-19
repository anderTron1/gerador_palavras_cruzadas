#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Oct 16 21:16:47 2023

@author: andre
"""

import requests
import random
from unidecode import unidecode

class Coletor_palavras:
    def __init__(self, url, max_tamanho_palavra):
        self.__url = url
        self.__max_tamanho = max_tamanho_palavra
    
    def formata_palavras(self, p):
        p = p.upper()
        #p = unidecode(p)
        return p
    def coletar(self):
        try:
            resposta = requests.get(self.__url)
            resposta.raise_for_status()
            
            conteudo = resposta.text
            lista_palavras = conteudo.split()
            
            random.shuffle(lista_palavras)
            
            return 0, [unidecode(p) for p in lista_palavras if len(p) <= self.__max_tamanho]
        
        except requests.exceptions.RequestException as e:
            return -1, 'Erro na solicitação: '.format(e)
        except Exception as e:
            return -2, 'Erro inesperado: '.format(e)    
            
#teste = Coletor_palavras('https://www.ime.usp.br/~pf/dicios/br-sem-acentos.txt',10)
#print(teste.coletar())
