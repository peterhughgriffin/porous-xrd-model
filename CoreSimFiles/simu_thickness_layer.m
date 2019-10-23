function [Na,da] = simu_thickness_layer(MatA,h_A)


%all in angstrom
ha = h_A*10;

A_m = MatA.aa_m;

r=MatA.nb_plane; %is the same for MatB and MatT

%round to nearest integer (h_a in in nm, da in Angrstrom)
	da = A_m/r;
	Na = round(ha/da);
	if (Na==0)
		Na =1;
		end 
	fprintf('(%s:%s%s) h=%4.2fnm (N=%4.2f) approximated by N=%d (h`=%4.3fnm)\n',MatA.name,MatA.c_type,MatA.compo_string,h_A,ha/da,Na,Na*da/10);


end
