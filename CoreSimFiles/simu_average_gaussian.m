function [WY,Xtrunc] = simu_average_gaussian(Y,X,gauss_space,gauss_sigma,res)

%moving average using FIR


%create a gaussian window of size gauss_space and sigma = gauss_sigma centered in the middle of the window
XW = linspace (-gauss_space/2,gauss_space/2,gauss_space);
XW = XW.^2;
W = exp(-XW/(2*gauss_sigma^2));
WW = W/(sum(W)/2.7);

%do the moving average using Finite Impulse Response Filter (FIR) function
%WW = [1,2,4,2,1]./10;
%WW=ones(20,1)/20;
WY = filter(WW,1,Y);

%truncate both ends of the windows for signal and abscisse
WY(1:gauss_space)=[];
WY(end-gauss_space:end)=[];

Xtrunc = X(gauss_space+1:end-gauss_space-1);

%shift the X axis by half the moving average windows since the gaussian is centered
Xtrunc = Xtrunc - gauss_space/2*res;

end
