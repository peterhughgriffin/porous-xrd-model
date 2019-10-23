function [a,c,Cij] = simu_template_type (template)

fprintf('\tGetting template type ...\t');

%%Get the parameter from the global variable
	global a_GaN;
	global c_GaN;

	global a_AlN;
	global c_AlN;

	global a_InN;
	global c_InN;

	global Cij_GaN;
	global Cij_AlN;
	global Cij_InN;


 %template type definition
	if (strcmp(template.c_type,'GaN'))
		%cell parameters
		a=a_GaN;
		c=c_GaN;
		%Elastic constant
		Cij = Cij_GaN;

	elseif (strcmp(template.c_type,'AlN'))
		%cell parameters
		a=a_AlN;
		c=c_AlN;
		%Elastic constant
		Cij = Cij_AlN;

	elseif (strcmp(template.c_type,'InN'))
		%cell parameters
		a=a_InN;
		c=c_InN;
		%Elastic constant
		Cij = Cij_Inn;
	
	else 
		error('Unknown template type : '%s'\n\n',template.c_type);
	end

fprintf('done\n');
end
