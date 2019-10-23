function Xij = simu_elastic_rotate(C,theta)

%fprintf('Original Elasticity tensor GaN\n');
%disp(Cij);
%fprintf('\n');

%theta=58.4082;%GaN
%theta=58.1867;%InN
a=cos(theta*pi/180);
b=sin(theta*pi/180);

C11=C(1,1);
C12=C(1,2);
C13=C(1,3);
C22=C(2,2);
C33=C(3,3);
C44=C(4,4);



%rotation
X11=C11;
X12=b^2*C13+a^2*C12;

X13=a^2*C13+b^2*C12;

X14=a*b*C12-a*b*C13;

X22=a^4*C11+b^4*C33+4*a^2*b^2*C44+2*a^2*b^2*C13;

X23=a^2*b^2*C11+a^2*b^2*C33-4*a^2*b^2*C44+(a^4+b^4)*C13;

X24=a^3*b*C11-a*b^3*C33+(2*a*b^3-2*a^3*b)*C44 + (a*b^3-a^3*b)*C13;

X33=b^4*C11+a^4*C33 + 4*a^2*b^2*C44+2*a^2*b^2*C13;

X34=a*b^3*C11-a^3*b*C33+(2*a^3*b-2*a*b^3)*C44 + (a^3*b-a*b^3)*C13;

X44 = a^2*b^2*C11 + a^2*b^2*C33+ (a^4-2*a^2*b^2+b^4)*C44 - 2*a^2*b^2*C13;

X55 = b^2/2*C11 - b^2/2*C12 + a^2*C44;

X56 = a*b/2*C11 - a*b/2*C12 -a*b*C44;

X66 = a^2/2*C11 - a^2/2*C12 + b^2*C44;


%matrix form
Xij = [ X11 , X12, X13 , X14 , 0 , 0 ;
	X12 , X22 , X23, X24 , 0 , 0 ;
	X13 , X23 , X33, X34 , 0 , 0 ;
	X14 , X24 , X34, X44 , 0 , 0 ;
	 0  , 0  , 0   , 0  , X55 , X56;
	 0  , 0  , 0   , 0  , X56 , X66];

Xij=round(Xij);

%fprintf('New elasticity tensor GaN\n');
%disp(Xij);
%fprintf('\n');

end
