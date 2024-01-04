import numpy as np
import librosa, librosa.display
import matplotlib.pyplot as plt
from torchvision.utils import save_image
import torch
FIG_SIZE = (30, 10)
for i in range(50):
    i=i+50
    sig, sr = librosa.load("/workspace/DSD100/Mixtures/Dev/allwav/"+'{:03d}'.format(i+1)+'.wav',sr=44100)
    sig=sig[44100*4:-44100*5]
    sigarr=[]
    for j in range(int(sig.shape[0]/(44100*5))):
        sigarr.append(sig[(44100*5)*(j):(44100*5)*(j+1)])
    y=[]
    for j in range(len(sigarr)):
        y.append(librosa.stft(sigarr[j], n_fft=4096, hop_length=1024))
        
    y[:]=torch.Tensor(y[:])
    for j in range(len(sigarr)):
        torch.save(y[j], '/workspace/DSD100/sepration/'+"{:03d}_".format(i)+str(j)+"mix.pt")
