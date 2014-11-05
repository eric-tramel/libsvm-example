#!/bin/sh


# If we already have libsvm installed, make sure it is up to date
if [ -d "libsvm" ]; then
	cd ./libsvm
	git fetch origin
	git pull 
	cd ..
fi


# If we don't have it, install it locally, here
if [ ! -d "libsvm" ]; then
	git clone https://github.com/cjlin1/libsvm.git
fi

# Build executables
cd ./libsvm
make
cd ..

# Build MEX
cd ./libsvm/matlab
matlab -nosplash -nodesktop -nodisplay -r "make;exit;"
cd ../..

# Make a bin directory inside libsvm if it doesn't exist
cd ./libsvm
if [ ! -d "bin" ]; then
	mkdir bin
fi
mv svm-train ./bin/svm-train
mv svm-predict ./bin/svm-predict
mv svm-scale ./bin/svm-scale
mv ./matlab/libsvmread.mexmaci64 ./bin/libsvmread.mexmaci64
mv ./matlab/libsvmwrite.mexmaci64 ./bin/libsvmwrite.mexmaci64
mv ./matlab/svmtrain.mexmaci64 ./bin/svmtrain.mexmaci64
mv ./matlab/svmpredict.mexmaci64 ./bin/svmpredict.mexmaci64
cd ..

# Additional Tools
# ROC-Curve tool
wget http://www.csie.ntu.edu.tw/~cjlin/libsvmtools/roc/plotroc.m
mv plotroc.m ./libsvm/tools/plotroc.m


