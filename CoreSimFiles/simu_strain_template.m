function [mat] = simu_strain_template (mat)

strain = mat.strain;

mat.aa_m = mat.aa * (1+strain.aa);
mat.bb_m = mat.bb * (1+strain.bb);
mat.cc_m = mat.cc * (1+strain.cc);

%checking the strain equation
check = mat.Ca*strain.aa + mat.Cb*strain.bb + mat.Cc*strain.cc;

checkA = abs((check)/(mat.Ca*(1+strain.aa))*100);
checkB = abs((check)/(mat.Cb*(1+strain.bb))*100);
checkC = abs((check)/(mat.Cc*(1+strain.cc))*100);

fprintf('Residual template strain not accounted for is : \n    %d%% out of plane\n or %d%% in plane 1\n or %d%% in plane 2\n',checkA,checkB,checkC);


if (checkA > 10 || checkB > 10 || checkC>10)
	fprintf('\tWarning template strain might not be adequate\n')
end

end
