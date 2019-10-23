function  simu_write(X)

%Epitaxy file are windows files : they terminate each line by CR LF, instead of linux or mac which uese only LF or only CR
%the CR LF termination is are then hard coded by this script with the sequance char([13, 10])

%filename='simu.Z00'
filepath=strcat(X.path,X.filename);

%open and discart previous content
[fid,msg] = fopen(filepath,'w');

	if (fid==-1)
		error('Could not open file%s \n\t->%s\n',filepath,msg);
    end

	fprintf('\n\tWriting Spectra file \n\t  "%s"\n',filepath);fflush_stdout();

	fprintf(fid,'[GeneralParameters]%s',char([13, 10]));
	fprintf(fid,'FileFormatVersion=1.0%s',char([13, 10]));
	fprintf(fid,'FileFormatRevision=1.1%s',char([13, 10]));
	fprintf(fid,'CreatedBy=1;Epitaxy 4.0%s',char([13, 10]));
	fprintf(fid,'DateCreated=14-FEB-2012%s',char([13, 10]));
	fprintf(fid,'TimeCreated=21:18%s',char([13, 10]));
	fprintf(fid,'DateModified=14-FEB-2012%s',char([13, 10]));
	fprintf(fid,'TimeModified=21:18%s',char([13, 10]));
	fprintf(fid,'[SampleParameters]%s',char([13, 10]));
	fprintf(fid,'SampleIdentification=%s',char([13, 10]));
	fprintf(fid,'SubstrateHKL=%s',char([13, 10]));
	

	fprintf(fid,'[ScanParameters]%s',char([13, 10]));
	fprintf(fid,'ScanIdentification=%s',char([13, 10]));
	fprintf(fid,'CountTimePerSec=20.0%s',char([13, 10]));        
	fprintf(fid,'UsedWaveLengthValueAng=1.540598%s',char([13, 10]));
	fprintf(fid,'UsedWaveLengthKV=45%s',char([13, 10]));
	fprintf(fid,'UsedWaveLengthmA=40%s',char([13, 10]));
	fprintf(fid,'ConversionType=0%s',char([13, 10]));
	fprintf(fid,'ScanType=0;MEASURED%s',char([13, 10]));
	
	fprintf(fid,'StartAngleDeg=%8.5f%s',X.theta(1),char([13, 10]));
	fprintf(fid,'EndAngleDeg=%8.5f%s',X.theta(end),char([13, 10]));
	
	nb_points = size (X.theta,2);
	step_size= (X.theta(end)-X.theta(1))/nb_points;
	mid_point = floor(nb_points/2)+1;
	
	fprintf(fid,'StepSizeDeg=%14.12f%s',step_size,char([13, 10]));
	fprintf(fid,'CenterOmegaDeg=%8.5f%s',X.theta(mid_point),char([13, 10]));
	fprintf(fid,'Center2ThetaDeg=%8.5f%s',2*X.theta(mid_point),char([13, 10]));
	fprintf(fid,'NoOfPoints=%d%s',nb_points,char([13, 10]));
	
	fprintf(fid,'ScanAxis=2;Omega/2Theta%s',char([13, 10]));
	fprintf(fid,'PhiAngleDeg=0.00    %s',char([13, 10]));  
	fprintf(fid,'PsiAngleDeg=0.00    %s',char([13, 10]));  
	fprintf(fid,'XPositionMm=0.00    %s',char([13, 10]));  
	fprintf(fid,'YPositionMm=0.00    %s',char([13, 10]));  
	fprintf(fid,'MeasurementType=1;Absolute single scan%s',char([13, 10]));
	fprintf(fid,'AngleOfInclinationDeg=0.00000   %s',char([13, 10]));
	fprintf(fid,'[ConvolutionParameters]%s',char([13, 10]));
	fprintf(fid,'MonochromatorType=0 ;None|None|0.00488889|0.000137|0%s',char([13, 10]));
	fprintf(fid,'[DataPoints]%s',char([13, 10]));

for c=X.counts
	fprintf(fid,'%4.2f%s',c,char([13, 10]));
end

fclose(fid);

end
