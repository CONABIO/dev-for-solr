import urllib
import simplejson
import pprint
import sys
from urllib.request import urlopen

def query_builder(host = "localhost", port = "8983", collection = "tech_products", qt = "select", q = "canon"): 
    url        = 'http://' + host + ':' + port + '/solr/' + collection + '/' + qt + '?' 
    q          = "q=" + q
    fl         = "fl=id,name"
    fq         = "fq="
    rows       = "rows=10"
    wt         = "wt=json"
    params     = [ q, fl, fq, wt, rows ] 
    p          = "&".join(params)
    
    # Se hace la union del url y la búsqueda
    connection = urlopen(url+p)
    if wt == "wt=json":
        response   = simplejson.load(connection) 
    else:
        response   = eval(connection.read())
        
    return print("Number of hits: " + str(response['response']['numFound']) +"\n" + str(response['response']['docs']))
