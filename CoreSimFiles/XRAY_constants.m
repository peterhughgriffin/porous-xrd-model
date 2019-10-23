%constants

fprintf('\tLoading all X ray constants ...\t');

global CuKa1;CuKa1 = 1.540598;


%All from Wright Paper "Elastic properties of zinc-blende and wurtzite AlN, GaN, and InN" JAP 82 (6), 1197

global C11_GaN;C11_GaN=367;
global C12_GaN;C12_GaN=135;
global C13_GaN;C13_GaN=103;
global C33_GaN;C33_GaN=405;
global C44_GaN;C44_GaN=95;
global C66_GaN;C66_GaN=(C11_GaN-C12_GaN)/2;
%global C66_GaN=116;

global Cij_GaN;
Cij_GaN = [ C11_GaN , C12_GaN , C13_GaN , 0 , 0 , 0 ;
		C12_GaN , C11_GaN , C13_GaN , 0 , 0 ,0 ;
		C13_GaN , C13_GaN , C33_GaN, 0 , 0 , 0 ;
		0 , 0 , 0 , C44_GaN, 0 , 0;
		0 , 0 , 0 , 0, C44_GaN , 0;
		0 , 0 , 0 , 0, 0 , C66_GaN ];


global C11_InN;C11_InN=223;
global C12_InN;C12_InN=115;
global C13_InN;C13_InN=92;
global C33_InN;C33_InN=224;
global C44_InN;C44_InN=48;
global C66_InN;C66_InN=(C11_InN-C12_InN)/2;
%global C66_InN=54;

global Cij_InN;
Cij_InN = [ C11_InN , C12_InN , C13_InN , 0 , 0 , 0 ;
		C12_InN , C11_InN , C13_InN , 0 , 0 ,0 ;
		C13_InN , C13_InN , C33_InN, 0 , 0 , 0 ;
		0 , 0 , 0 , C44_InN, 0 , 0;
		0 , 0 , 0 , 0, C44_InN , 0;
		0 , 0 , 0 , 0, 0 , C66_InN ];



global C11_AlN;C11_AlN=396;
global C12_AlN;C12_AlN=137;
global C13_AlN;C13_AlN=108;
global C33_AlN;C33_AlN=373;
global C44_AlN;C44_AlN=116;
global C66_AlN;C66_AlN=(C11_AlN-C12_AlN)/2;
%global C66_AlN=130;

global Cij_AlN;
Cij_AlN = [ C11_AlN , C12_AlN , C13_AlN , 0 , 0 , 0 ;
		C12_AlN , C11_AlN , C13_AlN , 0 , 0 ,0 ;
		C13_AlN , C13_AlN , C33_AlN, 0 , 0 , 0 ;
		0 , 0 , 0 , C44_AlN, 0 , 0;
		0 , 0 , 0 , 0, C44_AlN , 0;
		0 , 0 , 0 , 0, 0 , C66_AlN ];



%%% Cell parameters (from Epitaxy v4.3a and Mary Vickers + Jonathan + Clifford Paper)

global a_GaN;a_GaN=3.1893;
global c_GaN;c_GaN=5.1851;

global a_AlN;a_AlN=3.1114;
global c_AlN;c_AlN=4.9792;

global a_InN;a_InN=3.538;
global c_InN;c_InN=5.7020;



%%%%%%%%%%%%%%% Kromer Mann coefficient

%Ga
global kr_aGa;kr_aGa = [ 15.235 , 6.701, 4.359 , 2.962 ];
global kr_bGa;kr_bGa = [ 3.067 , 0.241 , 10.781 , 61.414];
global kr_cGa;kr_cGa = 1.719;


%Al
global kr_aAl;kr_aAl = [ 6.420 , 1.900 , 1.594 , 1.965 ] ;
global kr_bAl;kr_bAl = [ 3.039 , 0.743 , 31.547 , 85.089];
global kr_cAl;kr_cAl = 1.115 ;

%In
global kr_aIn;kr_aIn = [ 19.162 , 18.560 , 4.295 , 2.040 ] ;
global kr_bIn;kr_bIn = [0.548 , 6.378 , 25.850 , 92.803];
global kr_cIn;kr_cIn = 4.939  ;

%N
global kr_aN;kr_aN = [ 12.213 , 3.132 , 2.013 , 1.166 ];
global kr_bN;kr_bN = [ 0.006 , 9.893 , 28.997 , 0.583 ];
global kr_cN;kr_cN = -11.529;



fprintf('done\n');
