%% X-ray Absorption

% 3.1.4.1 of T. Smeeton's thesis describes how absorption can be incorporated, using:

% Io(Zn,theta) = exp(-2*mu(ZN-Zn)/sin(theta))

% Where mu is the linear absorption coefficient of GaN (3.2 E4 /m according
% to Cullity 1978) 
%  2(ZN-Zn)/sin(theta) is the total distance an Xray scattered at Zn
%  travels through GaN

% Here we compute the contribution from the A layer, the B layer, the repeats and the template. 
%  How can I characterise the distance that the Xray travels through?

    % It is still angle dependent
    
%     Travelling through a micron of material Io is 0.9380 (there and back
%     Plus we are at a value of theta, which is roughly 17 degrees
%     This gives a value of 0.8, i.e. a 20 % reduction
%     Io = exp(-2*mu*T/sin(theta))
%     The half a degree scan each way (using 16.5 17 and 17.5) gives 
%       Io = 0.7982    0.8034    0.8083
%     So there is some increased intensity reduction at higher angle, but not very much
%       ~0.5%

% Could calculate an average Io for each layer (e.g. A, B and T) this would
% be a function of angle. This would come from considering the thickness of
% the stack above each layer.



function [Io_A,Io_B,Io_T] = simu_absorption(MatA, MatB, MatT, R, theta)
    mu =3.2E4; % Mu is the linear absorption factor, as described in Smeeton's thesis from Cullity 1978
%            theta should be theta_q_rad from DBRSimFunc
%     For reference Q is given by:
%     Q = 2 * sin (Theta_q_rad) / CuKa1; %and Q in angstrom^-1
%

% Input thicknesses are passed in expressed in nm need to be converted to m
nm=1E-9;

%% Define Absorption function
% func = @(t,mu,theta) exp(-2*mu*t./sin(theta)); % This was for the
% original slow way of doing the integral.
funcInt = @(mu,theta,tMax, tMin) -(sin(theta)/(2*mu))*(exp(-2*mu*tMax/sin(theta))-exp(-2*mu*tMin/sin(theta)));

%% Initialise Intensity variables
Range = length(theta);
Io_A = zeros(1,Range);
Io_B = zeros(1,Range);
Io_T = zeros(1,Range);

%% Effective thickness of porous layer
    % Assuming that 100 nm of 50% porous GaN is the same as 50 nm of solid GaN
EffT_A = MatA.thickness*MatA.volFrac;

%% Find thicknesses
% MatA
%  Min thickness
    MinT_A = MatB.thickness*nm;
%  Max thickness
    MaxT_A = (EffT_A + MatB.thickness)*R*nm;

% MatB
%  Min thickness
    MinT_B = 0;
%  Max thickness
    MaxT_B = (EffT_A *(R-1) + MatB.thickness*R)*nm;

% MatT
%  Min thickness
    MinT_T = (EffT_A + MatB.thickness)*R*nm;
%  Max thickness
    MaxT_T = (MinT_T + MatT.thickness)*nm;
    
%% Find Characteristic Absorption for each angle
    
for i =[1: 1: Range]
    Io_A(i) = funcInt(mu,theta(i),MaxT_A,MinT_A)/(MaxT_A-MinT_A);
    Io_B(i) = funcInt(mu,theta(i),MaxT_B,MinT_B)/(MaxT_B-MinT_B);
    Io_T(i) = funcInt(mu,theta(i),MaxT_T,MinT_T)/(MaxT_T-MinT_T);
end

end
