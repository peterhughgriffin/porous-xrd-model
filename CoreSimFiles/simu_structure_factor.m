function FF2 = simu_structure_factor(alloy,theta_rad,HKL_hexa)

fprintf('\tComputing structure factors (%s) ...\t',alloy.c_type);

%Ga
global kr_aGa;global kr_bGa; global kr_cGa;
%Al
global kr_aAl;global kr_bAl;global kr_cAl;
%In
global kr_aIn;global kr_bIn;global kr_cIn;
%N
global kr_aN ;global kr_bN ;global kr_cN ;

%lambda
global CuKa1;



	%determine alloy alloy.c_type
if (strcmp(alloy.c_type,'GaN'))
		kr_a1=kr_aGa;
		kr_b1=kr_bGa;
		kr_c1=kr_cGa;

		kr_a2=kr_aGa;
		kr_b2=kr_bGa;
		kr_c2=kr_cGa;

	elseif (strcmp(alloy.c_type,'AlN'))
		kr_a1=kr_aAl;
		kr_b1=kr_bAl;
		kr_c1=kr_cAl;
		
		kr_a2=kr_aAl;
		kr_b2=kr_bAl;
		kr_c2=kr_cAl;

	elseif (strcmp(alloy.c_type,'InN'))
		kr_a1=kr_aIn;
		kr_b1=kr_bIn;
		kr_c1=kr_cIn;
		
		kr_a2=kr_aIn;
		kr_b2=kr_bIn;
		kr_c2=kr_cIn;
		
		elseif (strcmp(alloy.c_type,'InGaN'))
		kr_a1=kr_aGa;
		kr_b1=kr_bGa;
		kr_c1=kr_cGa;
		
		kr_a2=kr_aIn;
		kr_b2=kr_bIn;
		kr_c2=kr_cIn;
		
		elseif (strcmp(alloy.c_type,'AlGaN'))
		kr_a1=kr_aGa;
		kr_b1=kr_bGa;
		kr_c1=kr_cGa;
		
		kr_a2=kr_aAl;
		kr_b2=kr_bAl;
		kr_c2=kr_cAl;
		
		elseif (strcmp(alloy.c_type,'AlInN'))
		kr_a1=kr_aAl;
		kr_b1=kr_bAl;
		kr_c1=kr_cAl;
		
		kr_a2=kr_aIn;
		kr_b2=kr_bIn;
		kr_c2=kr_cIn;
		
	
	else 
		error('Unknown alloy type : "%s"\n\n',template_alloy.c_type);
end


	%compute the structure factor
	
	%approximation here,  [h k l] should be equivalent to the angle, different for template and for the alloy, etc...
	% here theta_rad is fixed (by the template) and [h k l] is also fixed
	% the same angle and [h k l]  are used independantly for the template and the alloy.... and fixed for all angles  !
	
	Q2 = (sin(theta_rad)/CuKa1)^2;
	

	%atomic scattering factor using the Cromer-Mann coefficent
	fX1=kr_c1;
	fX2=kr_c2;
	
	fN=kr_cN;
	for n=1:4
		fX1 = fX1 + kr_a1(n)*exp(-kr_b1(n)*Q2);
		fX2 = fX2 +kr_a2(n)*exp(-kr_b2(n)*Q2);
		fN = fN + kr_aN(n)*exp(-kr_bN(n)*Q2);
	end

	x=alloy.X;
	fX = (1-x)*fX1 + x*fX2;

	h = HKL_hexa(1);k = HKL_hexa(2);l = HKL_hexa(3);



	%motif scatering using the atomic scattering factors computed above (norm of the complex scattering vector) in the hexagonal crystal
	F1 = fX^2 + fN^2 + 2*cos(2*pi()*l*3/8)*fX*fN;
	F2 = 4*cos(pi()*(h/3+k*2/3+l/2))^2;
	Fscat = F1*F2;
	
	%thermal vibration (Debye–Waller)
		B_thermal = 1 ;
		%could be anything from 5 to 10 but is homogeneous for all the atoms in our solid (would be different with protein for example)
		%so taken as 1 as a scaling factor
		Fthermal = exp(- B_thermal * Q2);
	
	%Polarisation 
		%should depend on the setup here 
		
		%with nothing
		Fpol = (1+ cos(2*theta_rad)^2)/2;
	
		%with a 4bounce Ge [220] monochromator  (and no analyser)
		%Ge cubic 5.660A, lamba= CuKa1 = 1.540598  -> theta_Ge = 22.64°
		theta_Ge=22.64*pi()/180;
		Fpol4x = (1+ cos(2*theta_rad)^2*cos(2*theta_Ge)^8)/2;

	%Lorentz factor (scanning speed) using the simple Darwinian form
	Florentz= 1/sin(2*theta_rad);
	
	
	%Final factor (using a standard setup with no monochromator)
	FF = Fscat*Fthermal*Fpol*Florentz;
	FF2 = Fscat*Fthermal*Fpol4x*Florentz;
	
fprintf('done\n');
end
