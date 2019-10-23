function [alloy] = simu_mat_parameter (alloy)

%copy
	alloy=alloy;

fprintf('\tGetting %s parameters (%s) ...\t',alloy.name,alloy.c_type);

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


	%cell parameters for base material a = a0 * (1-x) + x*a1
	%same for Cij

, %alloy type definition
	if (strcmp(alloy.c_type,'AlGaN'))

		alloy.a0=a_GaN;
		alloy.c0=c_GaN;
		alloy.Cij0 = Cij_GaN;

		alloy.a1=a_AlN;
		alloy.c1=c_AlN;
		alloy.Cij1 = Cij_AlN;
		
		alloy.X_type='Al';

	elseif (strcmp(alloy.c_type,'InGaN'))
	
		alloy.a0=a_GaN;
		alloy.c0=c_GaN;
		alloy.Cij0 = Cij_GaN;

		alloy.a1=a_InN;
		alloy.c1=c_InN;
		alloy.Cij1 = Cij_InN;
		
		alloy.X_type='In';

	elseif (strcmp(alloy.c_type,'AlInN'))

		alloy.a0=a_AlN;
		alloy.c0=c_AlN;
		alloy.Cij0 = Cij_AlN;

		alloy.a1=a_InN;
		alloy.c1=c_InN;
		alloy.Cij1 = Cij_InN;
		
		alloy.X_type='Al';
		
	elseif (strcmp(alloy.c_type,'GaN'))
	
		alloy.a0=a_GaN;
		alloy.c0=c_GaN;
		alloy.Cij0 = Cij_GaN;

		alloy.a1=a_GaN;
		alloy.c1=c_GaN;
		alloy.Cij1 = Cij_GaN;
		
		alloy.X_type='';
		
	elseif (strcmp(alloy.c_type,'AlN'))
	
	
		alloy.a0=a_AlN;
		alloy.c0=c_AlN;
		alloy.Cij0 = Cij_AlN;

		alloy.a1=a_AlN;
		alloy.c1=c_AlN;
		alloy.Cij1 = Cij_AlN;
		
		alloy.X_type='';
		
	elseif (strcmp(alloy.c_type,'InN'))
	
	
		alloy.a0=a_InN;
		alloy.c0=c_InN;
		alloy.Cij0 = Cij_InN;

		alloy.a1=a_InN;
		alloy.c1=c_InN;
		alloy.Cij1 = Cij_InN;
		
		alloy.X_type='';
	
	else 
		error('Unknown alloy type : "%s"\n\n',alloy.c_type);
	end
	
	
	%Applying Vegards Law
	if (isfield (alloy,'X'))
		x = alloy.X;
		
		if (x==NaN)
			%do nothing it is a flag use for composition calculation
		elseif (x<0 || x>1)
			error('Atomic composition must be between 0 and 1');
		else
			%it is ok
		
			if (x~=0)
				alloy.compo_string=sprintf(' %4.2f%%',x*100);
			else
				alloy.compo_string='';
			end
			
			
			alloy.a=alloy.a0 * (1-x) + alloy.a1*x;
			alloy.c=alloy.c0 * (1-x) + alloy.c1*x;
			
			alloy.Cij=alloy.Cij0 * (1-x) + alloy.Cij1*x;
		end
	else
		if ((alloy.a0 == alloy.a1) && (alloy.a0 == alloy.a1))
			alloy.a = alloy.a0;
			alloy.c = alloy.c0;
			alloy.Cij = alloy.Cij0;
		else
			fprintf('Warning no composition defined and alloy type use\n Material parameter not complete\n');
		end
	end


fprintf('done\n');
end
