clear;

%%% Experiment Paramters
Ntrain = 5000;       % Specify the number of training samples to use.
Ntest  = 10000;      % Specify the number of testing samples to use.

%%% RBF-Kernel Optimal Parameters
% These are the optimal (C,\gamma) terms for the MNIST database for the
% RBF kernel. These were obtained via 5-fold CV on a 10000 samples from
% the training datset.
% Reported on:
%    http://peekaboo-vision.blogspot.co.uk/2010/09/mnist-for-ever.html
rbf_C  = 2;			 
rbf_g  = 0.0073;	

%%% Set the option string for svm-train
% -t 2   :   Use the RBF Kernel
% -q     :   Quiet mode
% -c     :   Set scaling/penalty term
% -g     :   Set \gamma term
svmtrain_opts = sprintf('-t 2 -q -c %0.2f -g %0.5f',rbf_C,rbf_g);


%%% Setting the Proper Path
setenv('PATH',['./libsvm/bin:' getenv('PATH')]);	% Put the libsvm executables on the path
addpath('./libsvm/bin');							% Put the MEX files on the MATLAB path

%%% Load Training Data
fprintf('Loading %d training samples...',Ntrain);
tic
[train_labels,train_data] = libsvmread('./data/mnist/mnist.scale');
loadtime = toc;
fprintf('done. (%0.2e sec)\n',loadtime);

%%% Load Testing Data
fprintf('Loading %d testing samples...',Ntest);
tic
[test_labels,test_data] = libsvmread('./data/mnist/mnist.scale.t');
loadtime = toc;
fprintf('done. (%0.2e sec)\n',loadtime);

%%% Experiment on the "first" set of N samples
train_labels = train_labels(1:Ntrain);
train_data   = train_data(1:Ntrain,:);
test_labels  = test_labels(1:Ntest);
test_data    = test_data(1:Ntest,:);

%%% Run Training
fprintf('Training SVM model...');
tic
model_rbf = svmtrain(train_labels,train_data,svmtrain_opts);
train_time = toc;
fprintf('done.\n');

%%% Run Testing
fprintf('Testing SVM model...');
tic
[predicted_labels, accuracy,toss] = svmpredict(test_labels,test_data,model_rbf,'-q');
test_time = toc;
fprintf('done.\n');

%%% Reporting final performance
fprintf('--------------------------\n');
fprintf('Training Time : %0.2e sec.\n',train_time);
fprintf('Testing Time  : %0.2e sec.\n',test_time);
fprintf('Accuracy      : %0.2f %%.\n' ,accuracy(1));
fprintf('--------------------------\n');