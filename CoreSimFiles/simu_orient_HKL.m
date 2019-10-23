function [alloyA,alloyB,alloyT] = simu_orient_HKL(HKL,alloyA,alloyB,alloyT)

h = HKL(1); k = HKL(2) ; l = HKL(3);

if ( h==0 && k==0) %cplane
	orient = 'c';
	r = l;
	if (l==0)
		error(' Incorrect HKL vector given : %d %d %\n',h,k,l);
	end
	
elseif (l==0) % non polar
	if (h == k )
		orient = 'a';
		r = h+k;
	elseif (h == -k)
		orient = 'm';
		r = abs(h-k);
	else
		error ('sorry  HKL [%d %d %d] currently not implemented\n',h,k,l);
	end
elseif (h==1 && k==1 && l==2)
		orient='t';
		r=1; %only 1 plane for 11-22
else 
	error ('sorry  HKL [%d %d %d] currently not implemented\n',h,k,l);
end

fprintf('\n\t[%d %d %d]\torientation type : "%s" \t with nb_plane = %d\n\n',h,k,l,orient,r);

alloyA.orientation = orient;
alloyB.orientation = orient;
alloyT.orientation = orient;

alloyA.nb_plane = r;
alloyB.nb_plane = r;
alloyT.nb_plane = r;

end
