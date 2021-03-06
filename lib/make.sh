#!/usr/bin/env bash

#CUDA_PATH=/usr/local/opt/cuda-8.0/
CUDA_PATH=/usr/local/cuda/


python setup.py build_ext --inplace
rm -rf build

#CUDA_ARCH="-gencode arch=compute_52,code=sm_52" 
#CUDA_ARCHY="-gencode arch=compute_35,code=sm_35 \
#           -gencode arch=compute_50,code=sm_50 \
#           -gencode arch=compute_52,code=sm_52 \
#           -gencode arch=compute_60,code=sm_60 \
#           -gencode arch=compute_61,code=sm_61 "
CUDA_ARCHY="-arch=sm_50 \
	    -gencode=arch=compute_50,code=sm_50 \
	    -gencode=arch=compute_52,code=sm_52 \
	    -gencode=arch=compute_60,code=sm_60 \
	    -gencode=arch=compute_61,code=sm_61 \
	    -gencode=arch=compute_70,code=sm_70 \
	    -gencode=arch=compute_75,code=sm_75 \
	    -gencode=arch=compute_75,code=compute_75  "




# compile NMS
cd model/nms/src
echo "Compiling nms kernels by nvcc..."
nvcc -c -o nms_cuda_kernel.cu.o nms_cuda_kernel.cu \
	 -D GOOGLE_CUDA=1 -x cu -Xcompiler -fPIC $CUDA_ARCH

cd ../
CFLAGS="-std=c11" python build.py
echo "aveam si ha anat bé"
# compile roi_pooling
cd ../../
cd model/roi_pooling/src
echo "Compiling roi pooling kernels by nvcc..."
nvcc -c -o roi_pooling.cu.o roi_pooling_kernel.cu \
	 -D GOOGLE_CUDA=1 -x cu -Xcompiler -fPIC $CUDA_ARCH
cd ../

CFLAGS="-std=c11" python build.py

# compile roi_align
cd ../../
cd model/roi_align/src
echo "Compiling roi align kernels by nvcc..."
nvcc -c -o roi_align_kernel.cu.o roi_align_kernel.cu \
	 -D GOOGLE_CUDA=1 -x cu -Xcompiler -fPIC $CUDA_ARCH
cd ../
CFLAGS="-std=c11" python build.py


# compile roi_crop
cd ../../
cd model/roi_crop/src
echo "Compiling roi crop kernels by nvcc..."
nvcc -c -o roi_crop_cuda_kernel.cu.o roi_crop_cuda_kernel.cu \
	 -D GOOGLE_CUDA=1 -x cu -Xcompiler -fPIC $CUDA_ARCH
cd ../
CFLAGS="-std=c11" python build.py
