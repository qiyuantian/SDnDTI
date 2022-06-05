# SDnDTI Tutorial

![DeepDTI Pipeline](https://github.com/qiyuantian/SDnDTI/blob/main/pipeline.png)

**SDnDTI pipeline**. SDnDTI pipeline is demonstrated for a DTI acquisition consisting of three b = 0 image volumes and 18 diffusion-weighted image volumes. Instead of directly averaging multiple repetitions of acquired images, SDnDTI first denoises each single noisy image using a CNN with the averaged image as the higher-SNR training target, following normal supervised learning based denoising methods. Implementing SDnDTI for multiple interspersed b = 0 image volumes of a DTI dataset is straightforward. However, raw acquired data do not readily provide multiple repetitions of DWI volumes with identical image contrasts but independent noise observations. SDnDTI leverages the diffusion tensor model to transform the image contrast of DWIs. Specifically, SDnDTI divides all DWI volumes into several subsets (e.g., m subsets), each with six DWI volumes along diffusion-encoding directions optimized for the tensor fitting, then estimates diffusion tensors from each subset of DWI volumes (along with the averaged b = 0 image volume), and finally synthesizes DWI volumes along all acquired directions to generate m sets of DWI volumes with identical image contrasts but independent noise observations.

![Comparison of results](https://github.com/qiyuantian/SDnDTI/blob/main/v1fa.png)

**Comprison of results**. SDnDTI results recover improved signal-to-noise ratio, image sharpness, and detailed anatomical information, are similar to those from supervised learning with external ground-truth data, and outperform results from raw data, BM4D-denoised and AONLM-denoised data. Quantitative comparison can be found in the NeuroImage paper of SDnDTI.

![Effects of training data](https://github.com/qiyuantian/SDnDTI/blob/main/trainingsubj.png)

**Effects of training data**. The denoising performance of SDnDTI depends on the number of training subjects. Even when the CNN of SDnDTI is trained on the data of each single subject, SDnDTI could still produce high-quality results that outperform those from BM4D and AONLM.

## s_SDnDTI_designBvec.m

Step-by-step MATLAB tutorial for designing diffusion encoding directions for SDnDTI data acquisition. HTML file can be automatically generaged using command: publish('s_SDnDTI_designBvec.m', 'html'). Subsequent data preparation and CNN training and application follows DeepDTI (https://github.com/qiyuantian/DeepDTI)

**Utility functions**

- *potentialenergy.m*: compute electrostatic potential energy of a set of directions

- *rot3d.m*: create 3D rotation matrix to rotate b-vectors

**Output**

- *bvecs_whole*: uniformly distributed diffusion encoding directions



## **Refereces**

[1] Tian Q, Li Z, Fan Q, Polimeni JR, Bilgic B, Salat DH, Huang SY. [SDnDTI: Self-supervised deep learning-based denoising for diffusion tensor MRI](https://www.sciencedirect.com/science/article/pii/S1053811922001628). *NeuroImage*, 2022; 253: 119033. [[**PDF**](https://www.sciencedirect.com/science/article/pii/S1053811922001628)]


