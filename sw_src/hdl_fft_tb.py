# -*- coding: utf-8 -*-
"""
Created on Thu May 19 17:15:31 2022

@author: francesco.maio
"""

import numpy as np
import hdl_fft as hf
import math
import matplotlib.pyplot as plt

if __name__ == "__main__":

    TMAX = 100 #s
    N = 2048
    timestep = TMAX/N 
    # timestep*n = TMAX
    t = np.arange(0,TMAX,timestep)
    
    sin1 = 4*np.sin(2*math.pi*t)
    sin2 = np.sin(10*2*math.pi*t)
    sin3 = 3*np.sin(22*2*math.pi*t)

    x = (sin1 + sin2 +sin3)
    x = x/(np.abs(np.max(x)-np.min(x)))
        
        
    freq = np.fft.fftshift(np.fft.fftfreq(N, d=timestep))
    
    X_numpy = np.fft.fftshift(np.abs(np.fft.fft(x)))/N
    
    TW_FFT  = hf.precompute_twiddles(N,"fft")
    TW_IFFT = hf.precompute_twiddles(N, "ifft")
    
    F1 = hf.hdl_fft(x,TW_FFT,N)
    X_hf = np.fft.fftshift(np.abs(F1))/N
    
    x_ifft_np = np.fft.ifft(np.fft.fft(x))
    x_ifft_hf = hf.hdl_fft(hf.hdl_fft(x,TW_FFT,N),TW_IFFT,N)
    
    fig,axs = plt.subplots(3,2)
    axs[0][0].plot(t,x)
    axs[0][1].plot(t,x)

    axs[1][0].plot(freq,X_numpy)
    axs[1][1].plot(freq,X_hf)
    
    axs[2][0].plot(t,np.real(x_ifft_np))
    axs[2][1].plot(t,np.real(x_ifft_hf))