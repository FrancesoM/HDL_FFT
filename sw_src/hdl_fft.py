# -*- coding: utf-8 -*-
"""
Created on Mon Apr 25 09:36:00 2022

@author: francesco.maio
"""

import math
import numpy as np
import copy
import matplotlib.pyplot as plt

import functools

def find_first_free(l):
    for i,el in enumerate(l):
        if el==0:
            return i
        
def gen_strides(N):
    
    S = int(math.log2(N))
    
    B = lambda s : int(N/(2**(S-s)))
    G = lambda s : int(N/(2**(s+1)))
    
    SG = lambda s : 2*B(s)
    
    strides = [ [0 for i in range(N//2)] for s in range(S) ]

    
    for s in range(S):
        
        for k in range( N//2 ):
                        
            strides[s][k] = SG(s)*(k//B(s)) + k % B(s)
                
    
    print( strides )
   

def gen_sequence_algo(d,N):
    
    free = [0 for i in range(N)]
    out_seq = [0 for i in range(N)]
    n=0
    while( n < N//2):
        # find first unoccupied
        ff = find_first_free(free)
        
        # update occupied places
        free[ff]=1
        free[ff+d]=1
        
        out_seq[2*n] = ff
        out_seq[2*n+1] = ff+d
        
        n+=1
        
    return out_seq

def btfly(v,w):
    ov = [0,0]
    ov[0] = v[0] + v[1]*w[0]
    ov[1] = v[0] + v[1]*w[1]
    return ov

def omega( N , a , sign):
    
    pi_slice = 2*math.pi/N
    re =      math.cos( (a) *pi_slice) #mod because periodicic number
    im = sign*math.sin( (a) *pi_slice)
    
    return re + 1j*im

def bit_reverse(vin):
    
    N = len(vin)
    bits = math.floor(math.log2(N))
    out = copy.deepcopy(vin)
    for i in range(N):
        
        bit_rev_i = int(bin(i)[2:].zfill(bits)[::-1],2)
        #print(i,bit_rev_i)
        
        out[bit_rev_i]=vin[i]
    
    return out

@functools.lru_cache(4)
def precompute_twiddles(N,direction):
    
    if direction == "fft":
        sign = -1
    else:
        sign = 1
    
    n_stages = math.floor(math.log2(N))
    twiddles     = [ [ omega(N, i*N//(2**(n+1)) , sign  ) for i in range(N) ]    for n in range(n_stages) ]
    
    return twiddles
    
def hdl_fft(vin,twiddles,N0):
    
    N = len(vin)
    
    if N < N0:
        #zero padding input
        vin = vin+[0]*(N0-N)
    
    S = math.floor(math.log2(N))
    
    # must be power of two
    assert math.floor(math.log2(N)) == math.ceil(math.log2(N)) 
    
    # functions to calculate strides
    # X = lambda s : int(N/(2**(S-s)))
    B = lambda s : int(N/(2**(S-s)))
    G = lambda s : int(N/(2**(s+1)))
    
    SG = lambda s : 2*B(s)
    
    # perform FFT
    
    buffer = bit_reverse(vin)
    vout = [0]*N
    
    for s in range( S ):

        # At each stage we perform N/2 butterfly
        tw_vec_this_stage = twiddles[s]; 
        for k in range( N//2):
        
            bb_i0         = SG(s)*(k//B(s)) + k % B(s)
            bb_i1         = bb_i0 + B(s)

            btfly_out_v = btfly( [ buffer[bb_i0]              , buffer[bb_i1]  ] , 
                                 [ tw_vec_this_stage[bb_i0] , tw_vec_this_stage[bb_i1]  ] )
            
            vout[bb_i0] = btfly_out_v[0]
            vout[bb_i1] = btfly_out_v[1]

        # reiterate 
        buffer = copy.deepcopy(vout)
        
        
    return vout











