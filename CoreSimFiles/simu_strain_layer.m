function [MatA] = simu_strain_layer (MatA,MatT)
%%assuming full relaxation on template and fully strained layer

aa =MatA.aa;
bb= MatA.bb;
cc =MatA.cc;

Ca =MatA.Ca;
Cb= MatA.Cb;
Cc =MatA.Cc;

%template in plane parameters (possibly strained)
bb_t= MatT.bb_m;
cc_t =MatT.cc_m;


%strain equation
aa_m  = aa* (1 - 1/Ca *  ( Cb*(bb_t - bb)/bb + Cc * (cc_t-cc)/cc ));



% finalisation
MatA.aa_m = aa_m;
MatA.bb_m = bb_t;
MatA.cc_m = cc_t;

%strain
MatA.strain =struct ('aa',(aa_m-aa)/aa,...
				'bb',(bb_t-bb)/bb,...
				'cc',(cc_t-cc)/cc);

end
