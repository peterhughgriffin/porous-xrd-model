function YY = simu_normalize(Y,max_counts,background)


Max_Y = max(Y);
r = max_counts/Max_Y;
YY = Y*r;

%WY2n = 0.1+WY2n+1*rand(1,nb_points+1);
YY = background+YY;

end
