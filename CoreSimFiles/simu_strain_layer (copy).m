function [A_m,T_m] = composition_strain_layer (alloy,template,orientation)
%%assuming full relaxation on template and fully strained layer


%% getting the parameter for the compounds
	[a,c,Cij ,a_XyN,c_XyN ,Cij_XyN ] = compo_alloy_parameter (alloy);
	[ta,tc,tCij ,ta_XyN,tc_XyN, tCij_XyN ] = compo_alloy_parameter(template);


%% orienting the crystal with aa being the 'measured value' on the symmetric scan and 'bb,cc' the other parameters
	%layer
	[aa,bb,cc] = compo_orientation_cell(orientation, a,c);
	[aa_XyN,bb_XyN,cc_XyN] = compo_orientation_cell(orientation, a_XyN,c_XyN);

	[Ca,Cb,Cc] = compo_orientation_elastic(orientation,Cij);
	[Ca_XyN,Cb_XyN,Cc_XyN] = compo_orientation_elastic(orientation,Cij_XyN);

%template
	[taa,tbb,tcc] = compo_orientation_cell(orientation, ta,tc);
	[taa_XyN,tbb_XyN,tcc_XyN] = compo_orientation_cell(orientation, ta_XyN,tc_XyN);

	[tCa,tCb,tCc] = compo_orientation_elastic(orientation,tCij);
	[tCa_XyN,tCb_XyN,tCc_XyN] = compo_orientation_elastic(orientation,tCij_XyN);
	
	%fflush(stdout);

% strain for the template
	x = template.c_X;
	
	%fully relaxed template
	taa_mx = taa + x* (taa_XyN-taa);
	tbb_mx = tbb + x* (tbb_XyN-tbb);
	tcc_mx= tcc + x* (tcc_XyN-tcc);


% strain for the layer

	%defintion of delta in length
	Da = aa_XyN - aa;
	Dc = cc_XyN - cc;
	Db = bb_XyN - bb;

	%delta of elastic constants based on the same principle
	DCa=Ca_XyN-Ca;
	DCb=Cb_XyN-Cb;
	DCc=Cc_XyN-Cc;
	
	%alloying
	x = alloy.c_X;
	
	Ca_x = Ca + x*DCa;
	Cb_x = Ca + x*DCa;
	Cc_x = Ca + x*DCa;

	aa_x = aa + x*Da;
	bb_x = bb + x*Db;
	cc_x = cc + x*Dc;
	
	%strain equation
	aa_mx=aa_x*(1 - 1/Ca_x*(   Cb_x*(tbb_mx - bb_x)/bb_x + Cc_x*(tcc_mx - cc_x)/cc_x  )   );


% finalisation
A_m = aa_mx;
T_m = taa_mx;


end
