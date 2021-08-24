# -*- coding: utf-8 -*-
"""
Created on Fri Jun 12 23:34:06 2020

@author: Juan Pablo
"""

import networkx as nx
from networkx.readwrite import json_graph
import matplotlib.pyplot as plt
import numpy as np
import csv

G=nx.read_shp(r"C:\Users\Juan Pablo\OneDrive - University of Illinois - Urbana\Thesis\QGIS Arg\Vial_Simplificada_v2_FINAL.shp") 
N=nx.read_shp(r"C:\Users\Juan Pablo\OneDrive - University of Illinois - Urbana\Thesis\QGIS Arg\Centroides_Shp.shp") 
#nx.draw(G)

G=nx.convert_node_labels_to_integers(G,first_label=1,ordering='default',label_attribute='location')

#G.edges[1,2]['LENGTH']

nx.write_weighted_edgelist(G, r'C:\Users\Juan Pablo\Desktop\Vial_Simplifi.txt')
# THIS THING ONLY GIVES BACK THE EDGELIST, EXPORT TO JSON AND THEN:

# IN MATLAB USE jsondecode(txt)


nx.write_multiline_adjlist(G, r'C:\Users\Juan Pablo\Desktop\multilineadjlist.txt')

data = []

for e in list(G.edges):
    temp = np.array( [G.edges[e]['LENGTH'], G.edges[e]['MATERIAL'],\
                      G.edges[e]['VEL_LIV'], G.edges[e]['VEL_PES'],\
                      G.edges[e]['CARRILES'], G.edges[e]['JERARQUIA'],\
                      G.edges[e]['ETIQUETA_R']])
    data.append(temp)
    
print (data)

# Write CSV file
with open("test.csv", 'w', newline='') as fp:
    writer = csv.writer(fp, delimiter=",")
    writer.writerow(["Length", "Material", "Vel_Liv",\
                     "Vel_Pes", "Carriles","Tipo","Nombre"])  # write header''
    writer.writerows(data)

# Read CSV file
with open("test.csv") as fp:
    reader = csv.reader(fp, delimiter=",", quotechar='"')
    # next(reader, None)  # skip the headers
    data_read = [row for row in reader]

print(data_read)