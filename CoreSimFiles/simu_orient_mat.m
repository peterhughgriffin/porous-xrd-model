function [mat] = simu_orient_mat(mat);

%aa is the symmetric orientation (out of plane), bb is the first in plane direction (in1),  and cc is the second in-plane direction (in2)

orientation_type = mat.orientation;
a= mat.a;
c= mat.c;
Cij = mat.Cij;

fprintf('\tOrienting cell and Cij (%s) ...\t',mat.name);

	if (strcmp(orientation_type,'c'))
	
		mat.aa=c;
		mat.bb=a;
		mat.cc=a;
		
		mat.Ca = Cij(3,3);
		mat.Cb = Cij(1,3);
		mat.Cc = Cij(1,3);
		
		

	elseif (strcmp(orientation_type,'a'))
		%a plane  : we use the orthorhombic bases 
		% aa the symmetric is the a direction (by accident)
		% cc is also c 
		% bb is the m direction (actually is is norm(bb)= 2m = sqrt(3)*a 
		%note that the sqrt(3) will cancel out in the strain and only mutliply the polynom factor by a constant but it is clearer this way)
		

		mat.aa=a;
		mat.bb=sqrt(3)*a; %bb = 2m;
		mat.cc=c;
		
		mat.Ca = Cij(1,1);
		mat.Cb = Cij(1,2);
		mat.Cc = Cij(1,3);
		

	elseif (strcmp(orientation_type,'m'))
		%m plane  : we use the orthorhobic bases 
		% aa the symmetric is the 2m direction 
		% the first in plane direction in c
		% the second  in-plane direction is a

		mat.aa=sqrt(3)*a; %aa = 2m;
		mat.bb=c; 
		mat.cc=a;
		
		mat.Ca = Cij(1,1);
		mat.Cb = Cij(1,3);
		mat.Cc = Cij(1,2);
		
		
	elseif (strcmp(orientation_type,'t')) %%11-22 plane
	
		h=1;k=1;l=2;
	
		cos_beta = l/(sqrt(  (h^2+h*k+k^2)*4/3*(c/a)^2+l^2) );
		beta_deg=acos(cos_beta)*180/pi();

		Xij = simu_elastic_rotate (Cij,beta_deg)

		mat.aa= 1/sqrt( (h^2+h*k+k^2)*4/3/(a^2) + l^2/(c^2) );  %%out of plane (zz)
		mat.bb= a; 														%%m direction (xx)
		mat.cc= a/cos_beta;												%% (yy)

		mat.Ca = Xij(3,3);
		mat.Cb = Xij(3,1);
		mat.Cc = Xij(3,2);
		
		
	else 
		error('Unknown orientation type : "%s"\n\n',orientation_type);
		%this is where you would need to rotate the Cij matrix
		
	end

fprintf('done\n');
end
