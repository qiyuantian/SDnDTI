# SDnDTI Tutorial

![DeepDTI Pipeline](https://github.com/qiyuantian/SDnDTI/blob/main/pipeline.png)

**SDnDTI pipeline** for a DTI acquisition consisting of three b = 0 image volumes and 18 diffusion-weighted image volumes. SDnDTI employs the approach of first denoising, followed by averaging. 



![Comparison of results](https://github.com/qiyuantian/DeepDTI/blob/main/dwi_v1fa.png)

**Comprison of results**. DeepDTI results recover improved signal-to-noise ratio, image sharpness, and detailed anatomical information buried in the noise in the raw data and blurred out in the BM4D-noised results. Quantitative comparison can be found in the NeuroImage paper of DeepDTI.

![Comparison of tractography results](https://github.com/qiyuantian/DeepDTI/blob/main/tracks.png)

**Comprison of tractography results**. DeepDTI denoised data recover more white matter fibers. Quantitative comparison of reconstructed fiber tracts and tract-specific analysis can be found in the NeuroImage paper of DeepDTI.

## s_DeepDTI_prepData.m

Step-by-step MATLAB tutorial for preparing the input and ground-truth data for convolutional neural network in DeepDTI. HTML file can be automatically generaged using command: publish('s_DeepDTI_prepData.m', 'html').

**Utility functions**

- *amatrix.m*: create diffusion tensor transformation matrix for given b-vectors

- *bgr_colormap.m*: create blue-gray-red color map for visualizaing residual images

- *decompose_tensor.m*: decompose diffusion tensors and derive DTI metrics

- *rot3d.m*: create 3D rotation matrix to rotate b-vectors

**Output**

- *cnn_inout.mat*: input and ground-truth data prepared for CNN


## s_DeepDTI_trainCNN.py

Step-by-step Python tutorial for training the DnCNN in DeepDTI using data prepared using the s_DeepDTI_prepData.m script.

**Utility functions**

- *dncnn.py*: create DnCNN model

- *qtlib.py*: create custom loss functions to only include loss within brain mask, and extract blocks from whole brain volume data

**Output**

- *deepdti_nb1_ep100.h5*: DnCNN model trained for 100 epoches

- *deepdti_nb1_ep100.mat*: L2 losses for the training and validation

## **Refereces**

[1] Tian Q, Li Z, Fan Q, Polimeni JR, Bilgic B, Salat DH, Huang SY. [SDnDTI: Self-supervised deep learning-based denoising for diffusion tensor MRI](https://www.sciencedirect.com/science/article/pii/S1053811922001628). *NeuroImage*, 2022; 253: 119033. [[**PDF**](https://www.sciencedirect.com/science/article/pii/S1053811922001628)]


