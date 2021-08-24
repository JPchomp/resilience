# -*- coding: utf-8 -*-
"""
Created on Fri Nov  1 18:01:55 2019

@author: Juan Pablo
"""

import networkx as nx

import matplotlib.pyplot as plt

G=nx.read_shp(r"C:\Users\Juan Pablo\Desktop\gistrial\input\Chi.shp") 
nx.write_edgelist(G,r"C:\Users\Juan Pablo\Desktop\gistrial\input\edges.txt")
pos = {k: v for k,v in enumerate(G.nodes())}
X=nx.Graph() #Empty graph
X.add_nodes_from(pos.keys()) #Add nodes preserving coordinates
l=[set(x) for x in G.edges()] #To speed things up in case of large objects
edg=[tuple(k for k,v in pos.items() if v in sl) for sl in l] #Map the G.edges start and endpoints onto pos
nx.draw_networkx_nodes(X,pos,node_size=100,node_color='r')
X.add_edges_from(edg)
nx.draw_networkx_edges(X,pos)
plt.xlim(490000, 470000) #This changes and is problem specific
plt.ylim(430000, 450000) #This changes and is problem specific
plt.xlabel('X [m]')
plt.ylabel('Y [m]')
plt.title('From shapefiles to NetworkX')
nx.draw(G, with_labels=False)

nx.write_edgelist(G,r"C:\Users\Juan Pablo\Desktop\gistrial\input")

##This JavaScript uses the Haversine Formula (shown below) expressed in terms of a two-argument inverse tangent function to calculate the great circle distance between two points on the Earth. This is the method recommended for calculating short distances by Bob Chamberlain (rgc@jpl.nasa.gov) of Caltech and NASA's Jet Propulsion Laboratory as described on the U.S. Census Bureau Web site.

##dlon = lon2 - lon1
#dlat = lat2 - lat1
#a = (sin(dlat/2))^2 + cos(lat1) * cos(lat2) * (sin(dlon/2))^2
#c = 2 * atan2( sqrt(a), sqrt(1-a) )
#d = R * c (where R is the radius of the Earth)
#Note: this formula does not take into account the non-spheroidal (ellipsoidal) shape of the Earth. It will tend to overestimate trans-polar distances and underestimate trans-equatorial distances. The values used for the radius of the Earth (3961 miles & 6373 km) are optimized for locations around 39 degrees from the equator (roughly the Latitude of Washington, DC, USA).
#Use LatLong.net to find the Latitude and Longitude for any U.S. address and DistanceFrom to find as-the-crow-flies distances. Also, I wrote a script to convert between decimal degrees and degrees/minutes/seconds formats.