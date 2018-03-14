#!/usr/bin/env python

import sys
import pandas as pd 

in_param=sys.argv
in_param.pop(0)

print 'Reads file:', str(in_param)

#Location = r'C:\Users\david\notebooks\update\births1880.csv'
fname1=str(in_param)
print(fname1.__class__.__name__)
fname2=r'../input/test_cl.txt'
print(fname2.__class__.__name__)
print(fname1)
print(fname2)
df = pd.read_csv(fname2, sep='\t')






