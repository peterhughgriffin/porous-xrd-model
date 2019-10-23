clear all;
close all;

%check octave/matlab by defining Moctave=true if octave intepreter
moctave_check;

%load all the constants;
fprintf('\n');
XRAY_constants;

%%%%%filename for reference data%%%%%
%ref_filename='C4819A_TA_mqw_002.xrdml.Z00';
%ref_filename='C4819A.Z00';
%ref_filename='C5025A[110]_omega.xrdml.Z00';
ref_path = 'ForMartin\C7381A\';
ref_filename='C7381A_w2t_TA(1-1.0)(b).xrdml';
%ref_filename='C5276E[112-m]OD_map_400nm_extracted.Z00';
    
%loading the data
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

%% C7300A 
% %% material type definition x_i = 0 -1 and h_i in nm (need x definition even if pure GaN, pure AlN or pure InN)
% Mat_typeA='AlGaN';			x_A = 0.135;	    h_A = 10.8;		%please define x_A even if pure compound
% Mat_typeB='GaN';			x_B = 0;		h_B = 10.8;       %please define x_B even if pure compound
% template_type = 'GaN';		x_T = 0.00;		h_T = 3000;			%please define x_T even if pure compound
% 
% %number of repeat
% %repeat_R = 10;
% repeat_R = 25;

%%C7381A 
% material type definition x_i = 0 -1 and h_i in nm (need x definition even if pure GaN, pure AlN or pure InN)
Mat_typeA='AlGaN';			x_A = 0.15;	    h_A = 11.3;		%please define x_A even if pure compound
Mat_typeB='GaN';			x_B = 0;		h_B = 11.3;       %please define x_B even if pure compound
template_type = 'GaN';		x_T = 0.00;		h_T = 3000;			%please define x_T even if pure compound

%number of repeat
%repeat_R = 10;
repeat_R = 25;



%strain state of the template in orthorhombic like coordinate (direct basis : [in1,in2,out])
%c-plane : [a,2m,c]		a-plane [2m,c,a]		m-plane : [c,a,2m]
% for bi-axial along c-plane the 2m strain is the same as the a strain(in1=in2)
template_strain_in_plane1 = 0;
template_strain_in_plane2 = 0;
template_strain_out_plane = 0;



%symmetric reflection only (in standard hexa coordinates)
%HKL_hexa = [0 0 2];
% HKL_hexa = [1 1 0]; % A-plane
HKL_hexa = [1 -1 0]; % M-plane


%plot setting
% omega scan range in degree
scan_range = 4;
scan_range_rad = scan_range * pi()/180;

%resolution is fixed to 2s = 0.000556 degree 
res = 0.0005;
%res = 0.0002;
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
				'HKL',HKL_hexa);
				
MatB = struct ( 'name','Mat B',...
				'c_type',Mat_typeB,...
				'X',x_B,...
				'HKL',HKL_hexa);
				
MatT = struct ( 'name', 'Template',...
				'c_type',template_type,...
				'X',x_T,...
				'HKL',HKL_hexa,...
				'strain',strainT);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% GETTING THE CELL, ORIENTIATION and STRAIn %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
%centering on q_template
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
fA = simu_structure_factor (MatA,theta_template_rad,HKL_hexa);
fB = simu_structure_factor (MatB,theta_template_rad,HKL_hexa);
fT = simu_structure_factor (MatT,theta_template_rad,HKL_hexa);



%%%%%%%%%%%%%%%%%%%%%%%Computing the stuff (in vector mode)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

piQ = Q*pi();


%% AB stack
	%Amplitude AB
yA = fA* sin(piQ*Na*da) ./ sin(piQ*da);
yB = fB* sin(piQ*Nb*db) ./ sin(piQ*db);

	%Intensity AB
yA2 = yA.^2;
yB2 = yB.^2;
yAB = 2*cos(piQ*H).*yA.*yB;

	%Repeat
yR = sin(piQ*H*R) ./ sin(piQ*H);
yR2 = yR .^2;

	%total AB stack
yAB2 = yA2 + yB2 + yAB;
Y1 = yR2 .* yAB2;

	%template
yT = fT* sin(piQ*Nt*dt) ./ sin(piQ*dt);
yT2 = yT.^2;

yTA = 2*cos( piQ*(Ht+R*H-db*Nb)).*yT.*yA.*yR;
yTB = 2*cos( piQ*(Ht+R*H+da*Na)).*yT.*yB.*yR;

YT = yT2;
YT_full = yT2+yTA+yTB ;%for now


%total with template
Y2 = Y1 + YT; 			%without coupling substrate layer
Y3 = Y1 + YT_full; 		%with coupling substrate layer




%moving average using a gaussian window 
%TA is about sigma = 4, as res is 2s and FHWM TA is 10s. Use a large windows like 400.
%OD is about 40 ?
gauss_space = 400; %TA
gauss_sigma = 4; %TA
% gauss_space = 400;  %for OD on a (11-22)
% gauss_sigma = 60;   %for OD on a (11-22)


[WY2,WTheta_q_deg] = simu_average_gaussian(Y2,Theta_q_deg,gauss_space,gauss_sigma,res);
[WY3,WTheta_q_deg] = simu_average_gaussian(Y3,Theta_q_deg,gauss_space,gauss_sigma,res);
[OD3,OD3Theta_q_deg] = simu_average_gaussian(Y3,Theta_q_deg,400,40,res);


%normalisation
%max_counts=5E6; %c-plane TA
% max_counts=4E5; %a-plane TA
max_counts=4E5; % C7300A data
% max_counts=3E6; %a-plane OD

background=0.2;
WY2=simu_normalize(WY2,max_counts,background);
WY3=simu_normalize(WY3,max_counts,background);
OD3=simu_normalize(OD3,max_counts,background);


Y3=simu_normalize(Y3,max_counts,background);
Y2=simu_normalize(Y2,max_counts,background);


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
Sim = struct ('counts', WY3,...
            'theta',WTheta_q_deg,...
            'name',sprintf('%d x %s(%4.2f%%,%4.2fnm)/%s(%4.2f%%,%4.2fnm) on %s',repeat_R,MatA.c_type,MatA.X,Na*da/10,MatB.c_type,MatB.X,Nb*db/10,MatT.c_type),...
            'filename',sprintf('simu_%s',Exp.filename),...
            'path',Exp.path);
	

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


%write_the_data
% simu_write(Sim);




%%%%%%%%%%%%%%%%%%%%%%%%PLotting the stuff %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
full_seen_pos = [20,20,1220,620];

%f1=figure('name','AB stack');
	%set(f1,'position',full_seen_pos);
	%subplot(3,1,1);
	%semilogy(Theta_q_deg,yA2,Theta_q_deg,yB2);
	%legend(MatA.c_type,MatB.c_type);


	%subplot(3,1,2);
	%semilogy(Theta_q_deg,yAB2,'color','red');
	%legend('cross talk');

	%subplot(3,1,3);
	%semilogy(Theta_q_deg,yR2,'color','black');
	%l_string = sprintf('%dx%4.2fnm',repeat_R,H/10);
	%legend(l_string);

%f2=figure ('name',sprintf('[%d %d %d] raw theta plot (%d points)',HKL_hexa(1),HKL_hexa(2),HKL_hexa(3),nb_points));
%set(f2,'position',full_seen_pos);

	%semilogy(Sim.theta,WY2*1000,'-b',Sim.theta,WY3,'-r',Theta_q_deg,Y2*1000000,'-k',OD3Theta_q_deg,OD3/10000,'--r');
	%legend('No coupling', 'With coupling' ,'No convolution','Heavy convolution');
	%xlim([14 20]);
	%ylim([1E-5, 1E+11]);


%f2=figure ('name',sprintf('[%d %d %d] raw theta plot (%d points)',HKL_hexa(1),HKL_hexa(2),HKL_hexa(3),nb_points));
%set(f2,'position',full_seen_pos);
	%semilogy(Sim.theta,Sim.counts,'-b',Exp.theta,Exp.counts,'-r');
	%legend(sprintf('%s',Sim.name),sprintf('%s',Exp.name));



f3=figure ('name',sprintf('[%d %d %d] shifted theta plot (%d points)',HKL_hexa(1),HKL_hexa(2),HKL_hexa(3),nb_points));
set(f3,'position',full_seen_pos);
	semilogy(Sim.theta_shift,Sim.counts,'-b',Exp.theta,Exp.counts,'-r');
	legend(sprintf('%s',Sim.name),sprintf('%s',Exp.name));

	%current window restriction for a-plane [110]
	%xlim ([26 , 31.5]);
	%ylim ([1e-1, 1e+6]);

