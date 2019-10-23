function [X] = simu_read(filename,path)


%clear all;

% Z00 file example
%[GeneralParameters]
%FileFormatVersion=1.0
%FileFormatRevision=1.1
%CreatedBy=1;Epitaxy 4.0
%DateCreated=14-FEB-2012
%TimeCreated=21:18
%DateModified=14-FEB-2012
%TimeModified=21:18
%[SampleParameters]
%SampleIdentification=
%SubstrateHKL=
%[ScanParameters]
%ScanIdentification=
%CountTimePerSec=20.0        
%UsedWaveLengthValueAng=1.540598
%UsedWaveLengthKV=45
%UsedWaveLengthmA=40
%ConversionType=0
%ScanType=0;MEASURED
%StartAngleDeg=14.56825  
%EndAngleDeg=19.55325  
%StepSizeDeg=0.002500000000
%CenterOmegaDeg=17.06080  
%Center2ThetaDeg=34.54470  
%NoOfPoints=1995
%ScanAxis=2;Omega/2Theta
%PhiAngleDeg=0.00      
%PsiAngleDeg=-0.22     
%XPositionMm=0.00      
%YPositionMm=0.00      
%MeasurementType=1;Absolute single scan
%AngleOfInclinationDeg=0.00000   
%[ConvolutionParameters]
%MonochromatorType=0 ;None|None|0.00488889|0.000137|0
%[DataPoints]
%0.25
%0.35
%0.45
%0.45
%0.45
%0.15
%0.45
%0.4


%filename = 'C4819A_TA_mqw_002.xrdml.Z00';
X.filename=filename;
X.path=path;


%for easier use later on
xname='';
for cc=X.filename
	if strcmp(cc,'_')
		cc='-';
	end
	xname=strcat(xname,cc);
end
X.name=xname;

filepath = strcat(path,filename);


[fid,msg] = fopen(filepath,'r');

	if (fid==-1)
		error('Could not open file "%s" \n\t->%s\n',filepath,msg);
    end

	fprintf('\n\tReading Spectra file \n\t  "%s"\n',filepath);fflush_stdout();
	
	


%skip header (all blank line and lines wihth ## ) and get to the BEGIN line ##WHITE_WAVELENGTH
go_on=true;

check_start_angle=0;
check_end=0;
check_size=0;
check_c_omega=0;
check_c_theta=0;
check_nb_points=0;


while ( not(feof(fid)) && go_on )
	line_b=fgetl(fid);
	go_on = not(( size(line_b,2)>11) && strcmp ('[DataPoints]',line_b(1:12)));
	%fprintf('\n%s\n',line_b);
	
	if ( not(isempty(line_b)) && size(line_b,2)>14 && strcmp ('StartAngleDeg=',line_b(1:14)))
		l_start_angle=line_b;
		check_start_angle=1;
	elseif (not(isempty(line_b)) && size(line_b,2)>12  &&strcmp ('EndAngleDeg=',line_b(1:12)))
		l_end_angle=line_b;
		check_end=1;
	elseif (not(isempty(line_b)) && size(line_b,2)>12  &&strcmp ('StepSizeDeg=',line_b(1:12)))
		l_step_size=line_b;
		check_size=1;
	elseif (not(isempty(line_b)) && size(line_b,2)>16 &&strcmp ('CenterOmegaDeg=',line_b(1:15)))
		l_center_omega=line_b;
		check_c_omega=1;
	elseif (not(isempty(line_b)) && size(line_b,2)>17  &&strcmp ('Center2ThetaDeg=',line_b(1:16)))
		l_center_2tetha=line_b;
		check_c_theta=1;
	elseif (not(isempty(line_b)) && size(line_b,2)>12  &&strcmp ('NoOfPoints=',line_b(1:11)))
		l_nb_points=line_b;
		check_nb_points=1;
	end

end

if (check_start_angle+check_end+check_size+check_c_omega+check_c_theta+check_nb_points~=6)
		error('Something went wrong during the parsing of the header');
end


X.omega_start=sscanf(l_start_angle,'StartAngleDeg=%f');
X.omega_end=sscanf(l_end_angle,'EndAngleDeg=%f');
X.omega_step_size=sscanf(l_step_size,'StepSizeDeg=%f');
X.omega_center=sscanf(l_center_omega,'CenterOmegaDeg=%f');
X.twotheta_center=sscanf(l_center_2tetha,'Center2ThetaDeg=%f');
X.nbpoints=sscanf(l_nb_points,'NoOfPoints=%d');

%offset  2theta/2 - omega
X.offset = (X.twotheta_center/2)-X.omega_center;

check1 = (X.omega_end-X.omega_start)/(X.nbpoints-1);

%disp(abs(check1-X.omega_step_size));

if ( abs(check1-X.omega_step_size)>1E-8)
	error('Start, End, Nb points and Step size do not match\n');
end

check2 = X.omega_start + (X.nbpoints-1)/2*X.omega_step_size;
if ( abs(check2-X.omega_center)>X.omega_step_size)
	error ('Start, Step Size, Nb points and Center do not match\n');
end

X.omega=X.omega_start:X.omega_step_size:X.omega_end;
X.twotheta=(X.omega+X.offset)*2;
X.theta=X.twotheta/2;


%omega(center) = omega ( (nbpoints-1)/2 + 1 )

X.counts=zeros(1,X.nbpoints);

%disp(line_b);

%%get the data (all the numerics after the BEGIN line)
i=0;
while ( not(feof(fid))  )
	line=fgetl(fid); %get new line with the number
	A=sscanf(line,'%f');
	if (not(isempty(A)))
	i=i+1;
	X.counts(i)=A;
    end
end

if(X.nbpoints==i)
	fprintf('\t\tsucessfully found %d points\n',i);
else 
	error('Found %d points in file while header data reads %d points\n',i,X.nbpoints);
end
	

%close the file
fprintf('\tdone\n');fflush_stdout();
fclose(fid);

%flush the output
fflush_stdout();


%print the name of the files of the structure
%fieldnames(X)
end


