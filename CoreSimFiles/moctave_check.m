%matlab / octave check

v= ver();
vv=v.Name;

global Moctave;
if strcmp(vv,'Octave')
	Moctave=true;
else
	Moctave=false;
end
