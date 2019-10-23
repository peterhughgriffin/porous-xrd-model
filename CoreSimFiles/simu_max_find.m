function Exp = simu_max_find (Exp)

	
	%find largest peak within the center part of the experimental spectra (1/3, 1/3, 1/3)
	S_counts=size(Exp.counts,2);
	%S_counts_search = floor(S_counts/3);
	S_counts_search = floor(S_counts/8);
		%search
	[M_val,M_i] = max (Exp.counts(1+S_counts_search:end-S_counts_search));
		%find the associate angle
	Exp.max = S_counts_search+M_i;
    try
        Exp.max_theta = Exp.theta(Exp.max);
    catch ME
        if strcmp(ME.identifier,'MATLAB:nonExistentField')
            msg = 'File is an Omega Scan'
        else
            rethrow(ME)
        end
    end
    try
        Exp.max_omega = Exp.omega(Exp.max);
    catch ME
        if strcmp(ME.identifier,'MATLAB:nonExistentField')
            msg = 'File is a theta Scan'
        else
            rethrow(ME)
        end
    end

end
