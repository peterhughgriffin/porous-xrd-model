function Sim = DBRsimFunc(Porosity, T_Por, T_GaN, repeat_R, T_Temp, ref_path, ref_filename, Absorption)
% function Sim = DBRsimFunc(Porosity, T_Por, T_GaN, repeat_R, T_Temp, Absorption)

if nargin < 8 %Check this number corresponds to the above stuff
    fprintf('\tAbsorption not defined. Therefore will be neglected\t');
    Absorption =   0;
end

%close all;

%check octave/matlab by defining Moctave=true if octave intepreter
moctave_check;

%load all the constants;
fprintf('\n');
XRAY_constants;


%loading experimental data
Exp = data_read(ref_filename,ref_path);
%searching for maximum
Exp = simu_max_find (Exp);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DATA INPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MODEL	Tpyical : A= InGaN 		B=GaN%%
%BBBBBBBB
%BBBBBBBB
%AAAAAAAA
%BBBBBBBB
%BBBBBBBB
%AAAAAAAA
%TEMPLATE
%TEMPLATE
%TEMPLATE

%Mat_typeA='AlGaN';
%Mat_typeA='AlInN';

%% material type definition x_i = 0-1 and h_i in nm (need x definition even if pure GaN, pure AlN or pure InN)
Mat_typeA='GaN';			x_A = 0.00;	    h_A = T_Por;		%please define x_A even if pure compound "Porous" GaN
VolFrac=(100-Porosity)/100; %Create fractional GaN volume value from percentage porosity. This scales the structural factors of the porous layer
Mat_typeB='GaN';			x_B = 0.00;		h_B = T_GaN;       %please define x_B even if pure compound
template_type = 'GaN';		x_T = 0.00;		h_T = T_Temp;			%please define x_T even if pure compound


%strain state of the template in orthorhombic like coordinate (direct basis : [in1,in2,out])
%c-plane : [a,2m,c]		a-plane [2m,c,a]		m-plane : [c,a,2m]
% for bi-axial along c-plane the 2m strain is the same as the a strain(in1=in2)
template_strain_in_plane1 = 0;
template_strain_in_plane2 = 0;
template_strain_out_plane = 0;

%symmetric reflection only (in standard hexa coordinates)
HKL_hexa = [0 0 2];
%HKL_hexa = [1 1 2];


%plot setting
% omega scan range in degree
scan_range = 2;
scan_range_rad = scan_range * pi()/180;

%resolution is fixed to 2s = 0.000556 degree 
res = 0.0005; 

%Was 0.0005, but this lead to strange effects at the centre peak
% increase by factor (also used to change Gaussian window
ResFactor = 2;
res=res/ResFactor;

res_rad = res * pi()/180;

nb = scan_range/res;
nb_approx = ceil (nb/1E3);
nb_points = (nb_approx+1)*1E3;

%TA FHWM is 11 arcs
%OD with 1° slit FHWM is 860 arcs




%%%%%%%%%%%%%%%% varia definition based on above info %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
strainT = struct('aa',template_strain_out_plane,...
				'bb',template_strain_in_plane1,...
				'cc',template_strain_in_plane2);

MatA = struct ( 'name','Mat A',...
				'c_type',Mat_typeA,...
				'X',x_A,...
				'HKL',HKL_hexa,...
                'thickness',h_A,...
                'volFrac',VolFrac);
				
MatB = struct ( 'name','Mat B',...
				'c_type',Mat_typeB,...
				'X',x_B,...
                'thickness',h_B,...
				'HKL',HKL_hexa);
				
MatT = struct ( 'name', 'Template',...
				'c_type',template_type,...
				'X',x_T,...
				'HKL',HKL_hexa,...
                'thickness',h_T,...
				'strain',strainT);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% GETTING THE CELL, ORIENTIATION and STRAIN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% getting the orientation 'c','a','m' for the HKL value
%as well as the number of plane spacing per cell for the symmetric HKL chosen (ie. nb_plane=2 for R=[0 0 2] or [1 1 0])

[MatA,MatB,MatT]=simu_orient_HKL(HKL_hexa,MatA,MatB,MatT);


%getting the Cij and lattice parameters for each material
[MatT] = simu_mat_parameter (MatT);
[MatA] = simu_mat_parameter (MatA);
[MatB] = simu_mat_parameter (MatB);
fprintf('\n');

%orienting the cell in a orthorhombic basis (Cij & cell)
[MatT] = simu_orient_mat (MatT);
[MatA] = simu_orient_mat (MatA);
[MatB] = simu_orient_mat (MatB);
fprintf('\n');

%stressing the template
[MatT] = simu_strain_template(MatT);

%stressing the layers
[MatA] = simu_strain_layer (MatA,MatT);
[MatB] = simu_strain_layer (MatB,MatT);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SETTING THE DISTANCES  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('\n');
fflush_stdout();


[Na,da]  = simu_thickness_layer(MatA,h_A);
[Nb,db]  = simu_thickness_layer(MatB,h_B);
[Nt,dt]  = simu_thickness_layer(MatT,h_T);


H = Na*da + Nb*db;
Ht = dt*Nt;
R= repeat_R;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SETTING THE X axis  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% setting the plot parameter with q
% centering on q_template
	q_template = 1/dt;

	theta_template_rad = asin(CuKa1/(2*dt));
	theta_template = theta_template_rad/pi()*180;
	
	X=0:1:nb_points;
	Theta_q_deg = theta_template + (X-(nb_points)/2)*res;
	Theta_q_rad = Theta_q_deg * pi()/180;
	Q = 2 * sin (Theta_q_rad) / CuKa1; %and Q in angstrom^-1

	%scan_range_rad = abs((scan_range*pi()/180))/2; %should be half the scan range in omega (the computation is made in theta, not 2theta)
	%q_max = 2*sin(theta_template_rad+scan_range_rad)/CuKa1;
	%delta_q = abs(q_max - q_template);

	%% setting up the ramp
	%Q = -delta_q  : delta_q / (nb_points) :  delta_q;
	%% centering the ramp;
	%Q = Q + q_template;
	
	%Theta_q_deg = asin(CuKa1*Q/2)*180/pi();
	

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Getting the structure factors %%%%%%%%%%%%%
fprintf('\n');
fflush_stdout();

%fixed structure factor weakly depending on the angle... to check
fA = VolFrac*simu_structure_factor (MatA,theta_template_rad,HKL_hexa);
fB = simu_structure_factor (MatB,theta_template_rad,HKL_hexa);
fT = simu_structure_factor (MatT,theta_template_rad,HKL_hexa);


%% %%%%%%%%%%%%%%%%%%%%% Computing the stuff (in vector mode) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

piQ = Q*pi();

%% AB stack
% Dodgy get Around?
%     The value at the centre, i.e. 0 arcsecs is eroneous for each of
%     yA,yB,yT and yR. I Resolve this here, by finding it's index:
ind = ceil(length(piQ)/2);
%     And then setting this to the average of its nearest neighbours in
%     each case. I also double the resolution, so this is as good as doing
%     this at normal res.

%% Absorption
% To neglect Absorption
Io_A =1;
Io_B =1;
Io_T =1;

if Absorption
    % To include absorption:
    [Io_A, Io_B, Io_T] = simu_absorption(MatA, MatB, MatT, R, Theta_q_rad);
end


%% 	%Amplitude AB
yA = sqrt(Io_A).*(fA* sin(piQ*Na*da) ./ sin(piQ*da));
yA(ind)=(yA(ind-1)+yA(ind+1))/2; %Dodgy get around?
yB = sqrt(Io_B).*(fB* sin(piQ*Nb*db) ./ sin(piQ*db));
yB(ind)=(yB(ind-1)+yB(ind+1))/2; %Dodgy get around?
	%Intensity AB
yA2 = yA.^2;
yB2 = yB.^2;
yAB = 2*cos(piQ*H).*yA.*yB;

	%Repeat
yR = sin(piQ*H*R) ./ sin(piQ*H);
yR(ind)=(yR(ind-1)+yR(ind+1))/2; %Dodgy get around?
yR2 = yR .^2;

	%total AB stack
yAB2 = yA2 + yB2 + yAB;
Y1 = yR2 .* yAB2;

	%template
yT = sqrt(Io_T).*(fT* sin(piQ*Ht) ./ sin(piQ*dt));
yT(ind)=(yT(ind-1)+yT(ind+1))/2; %Dodgy get around?

yT2 = yT.^2;

yTA = 2*cos( piQ*(Ht+R*H-db*Nb)).*yT.*yA.*yR;
yTB = 2*cos( piQ*(Ht+R*H+da*Na)).*yT.*yB.*yR;

YT = yT2;
YT_full = yT2+yTA+yTB ;%for now


%total with template
Y2 = Y1 + YT; 			%without coupling substrate layer
Y3 = Y1 + YT_full; 		%with coupling substrate layer

%% 

%moving average using a gaussian window 
%TA is about sigma = 4, as res is 2s and FHWM TA is 10s. Use a large windows like 400.
%OD is about 40 ?
gauss_space = 400; %TA
gauss_sigma = 4; %TA

%gauss_space = 400;  %for OD on a (11-22)
%gauss_sigma = 60;   %for OD on a (11-22)

% Resolution was 0.0005 (or 2s) but this lead to strange effects at the centre peak
% Increased resolution by ResFactor and therefore increase gauss_sigma by same factor for the same size window in angle
gauss_space = gauss_space*ResFactor;
gauss_sigma = gauss_sigma*ResFactor;



[WY2,WTheta_q_deg] = simu_average_gaussian(Y2,Theta_q_deg,gauss_space,gauss_sigma,res);
[WY3,WTheta_q_deg] = simu_average_gaussian(Y3,Theta_q_deg,gauss_space,gauss_sigma,res);
[OD3,OD3Theta_q_deg] = simu_average_gaussian(Y3,Theta_q_deg,400,40,res);


%normalisation
% max_counts=5E6; %c-plane TA
%max_counts=4E5; %a-plane TA
max_counts=max(Exp.counts);


% 
% %1.37E6; %a-plane OD
% 
background=0.001;
% background=0;
WY2=simu_normalize(WY2,max_counts,background);
WY3=simu_normalize(WY3,max_counts,background);
OD3=simu_normalize(OD3,max_counts,background);


% Convert Thetas to relative arc seconds

% Find index of maximum value then subtract and *3600
[~,MaxInd] = max(WY2);
RelSec = (WTheta_q_deg-WTheta_q_deg(MaxInd))*3600;
[~,MaxInd] = max(Y2);
RelSec_Parts = (Theta_q_deg-Theta_q_deg(MaxInd))*3600;

%Y3=simu_normalize(Y3,max_counts,background);
%Y2=simu_normalize(Y2,max_counts,background);


%setting down the log
epsilon1 = 1E4;
yA2 = yA2+epsilon1;
yB2 = yB2+epsilon1;
yAB2 = yAB2+epsilon1;
yR2 = yR2 + 1;

%epsilon2 = 1E6;
%Y2 = Y2+epsilon2;
%YT = YT+epsilon2;

%building simulation result
Sim = struct ('name',sprintf('%d x %s(%4.2f nm of %4.1f%% porous)/%s(%4.2fnm) on %s',repeat_R,MatA.c_type,Na*da/10,Porosity,MatB.c_type,Nb*db/10,MatT.c_type),...
            'porosity',Porosity,...
            'porethickness',T_Por,...
            'GaNthickness',T_GaN,...
            'repeats',repeat_R,...
            'filename',sprintf('simu_%s',Exp.filename),...
            'path',Exp.path,...
            'theta',WTheta_q_deg,...
            'relarcsec',RelSec,...
            'counts', WY3,...
            'theta_parts', Theta_q_deg,...
            'relsec_parts', RelSec_Parts,...
            'matA',yA2,...
            'matB',yB2,...
            'crosstalk',yAB2,...
            'ABInterference',yAB,...
            'periodic',yR2);
	
%% These Could also be included. They were plotted in the original.     
%     WY2
%     Y2
%     OD3Theta_q_deg
%     OD3

%%

%search for max
Sim = simu_max_find (Sim);

%finding possible shift
delta_theta = Sim.max_theta- Exp.max_theta;
Sim.theta_shift = Sim.theta - delta_theta;

%finding the strain
sim_d = CuKa1/(2*sin(Sim.max_theta*pi()/180));
exp_d = CuKa1/(2*sin(Exp.max_theta*pi()/180));

delta_strain = (exp_d - sim_d)/sim_d;
if (delta_strain >0)
	strain_string = 'expansion';
else
	strain_string = 'compression';
end

fprintf('\nExperimental data is shifted by %4.4f degree (theta)\n\tcorresponding to a %4.2e global strain (%s)\n\n',delta_theta , delta_strain, strain_string); 

end