import hdl_fft as hf
import math

def print_s(N):     
    seq,all_tw_vectors = hf.precompute_idx(N)


    s = ""
    for i,idx in enumerate(seq[1]):
        
        s += "assign out_vec[{}] = in_vec[{}];".format(i,idx)
        s += "\n"
        
    print(s)
    
def bit_reverse_test(N):
    
    n_bits= int(math.log2(N))
    
    seq,all_tw_vectors = hf.precompute_idx(N)
    
    start_idx_s1 = [ x for i,x in enumerate(seq[0]) if i%2==0 ]
    
    print(start_idx_s1)
    
    bit_reversed = [ int(bin(x)[2:].zfill(n_bits)[::-1],2)  for x in start_idx_s1  ]
    
    #print( bit_reversed )


def gen_idx(N):
    
    S = int(math.log2(N))
    
    B = lambda s : int(N/(2**(S-s)))
    G = lambda s : int(N/(2**(s+1)))
    
    SG = lambda s : 2*B(s)
    
    strides = [ [0 for i in range(N//2)] for s in range(S) ]

    
    for s in range(S):
        
        for k in range( N//2 ):
                        
            strides[s][k] = SG(s)*(k//B(s)) + k % B(s)
                
    
    print( strides )


gen_idx(8)