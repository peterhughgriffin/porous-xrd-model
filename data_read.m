%%This is a customised version of simu_read that reads the data from a
%%.xrdml file, rather than reading from a simulated.xrdml.znn file

function [X] = data_read(filename,path)

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
% Assume Not an Omega 2 Theta scan initially, check later
X.OmTwoTh = false;

%Read in xrdml file into struct
struct = xml2struct(filepath);

fprintf('\n\tReading Spectra file \n\t  %s\n',filepath);fflush_stdout();

%%This is horribly convoluted because the structure of the XML files can be
%%different, but I can't figure out how to navigate xml using tags
%%effectively. Hence I check whether I have "short" type of XML (Count =
%%10) or a long type (Count = 12). Then can get the values needed by brute
%%force.

%%Navigate struct to grab all the values we need. AT each point there is a
%%check to make sure we are in the right place of the xrdml file
if strcmp(struct.Children(6).Name,'xrdMeasurement') %Check navigation of structure is as expected
    if strcmp(struct.Children(6).Children(10).Children(4).Name,'scanAxisCenter') %Check navigation of structure is as expected
        Count=10;
    elseif strcmp(struct.Children(6).Children(12).Children(4).Name,'scanAxisCenter') %Check navigation of structure is as expected
        Count = 12;
	else
        error('data_read:StrangeXRDml','Tree structure did not follow expected path\n File says:\t %s\n Expected:\t scanAxisCenter \n At:\t struct.Children(6).Children(12).Children(4).Name',struct.Children(6).Children(12).Children(4).Name);
    end
    X.twotheta_center=str2double(struct.Children(6).Children(Count).Children(4).Children(2).Children.Data);
    if strcmp(struct.Children(6).Children(Count).Attributes(3).Value,'Omega-2Theta')
        X.omega_center=str2double(struct.Children(6).Children(Count).Children(4).Children(4).Children.Data);
        X.OmTwoTh = true;
    end
    if strcmp(struct.Children(6).Children(Count).Children(6).Name,'dataPoints')
        DataPointNum = 6;
    else
        DataPointNum = 8;
    end
    
    if strcmp(struct.Children(6).Children(Count).Children(DataPointNum).Children(4).Attributes(1).Value,'Omega') %Check navigation of structure is as expected
        X.omega_start=str2double(struct.Children(6).Children(Count).Children(DataPointNum).Children(4).Children(2).Children.Data);
        X.omega_end=str2double(struct.Children(6).Children(Count).Children(DataPointNum).Children(4).Children(4).Children.Data);
    else
        error('data_read:StrangeXRDml','Tree structure did not follow expected path\n File says:\t %s\n Expected:\t Omega \n At:\t struct.Children(6).Children(12).Children(8).Children(4).Attributes(1).Value',struct.Children(6).Children(12).Children(8).Children(4).Attributes(1).Value);
    end
    if strcmp(struct.Children(6).Children(Count).Children(DataPointNum).Children(16).Name,'commonCountingTime') %Check navigation of structure is as expected
            dwell_time = str2double(struct.Children(6).Children(Count).Children(DataPointNum).Children(16).Children.Data);
    elseif strcmp(struct.Children(6).Children(Count).Children(DataPointNum).Children(18).Name,'commonCountingTime') %Check navigation of structure is as expected
        dwell_time = str2double(struct.Children(6).Children(Count).Children(DataPointNum).Children(18).Children.Data);
    else
        error('data_read:StrangeXRDml','Tree structure did not follow expected path\n File says:\t %s\n Expected:\t commonCountingTime \n At:\t struct.Children(6).Children(12).Children(8).Children(18).Name',struct.Children(6).Children(12).Children(8).Children(16).Name);
    end
    if strcmp(struct.Children(6).Children(Count).Children(DataPointNum).Children(18).Name,'intensities') %Check navigation of structure is as expected
            X.counts = str2num(char(strsplit(struct.Children(6).Children(Count).Children(DataPointNum).Children(18).Children.Data)))/dwell_time;
            CountSize = length(X.counts);
            X.counts = reshape(X.counts,1,CountSize(1));
    elseif strcmp(struct.Children(6).Children(Count).Children(DataPointNum).Children(20).Name,'intensities') %Check navigation of structure is as expected
        X.counts = str2num(char(strsplit(struct.Children(6).Children(Count).Children(DataPointNum).Children(20).Children.Data)))/dwell_time;
        CountSize = length(X.counts);
        X.counts = reshape(X.counts,1,CountSize(1));
    else
        error('data_read:StrangeXRDml','Tree structure did not follow expected path\n File says:\t %s\n Expected:\t intensities \n At:\t struct.Children(6).Children(12).Children(8).Children(20).Name',struct.Children(6).Children(12).Children(8).Children(20).Name);
    end
else
    error('data_read:StrangeXRDml','Tree structure did not follow expected path\n File says:\t %s\n Expected:\t xrdMeasurement \n At:\t struct.Children(6).Children(12).Children.Name(4)',struct.Children(6).Children(12).Children.Name(4));

end

if X.OmTwoTh
    %Compute omega offset
    X.offset = (X.twotheta_center/2)-X.omega_center;
end

%Compute the step size
X.nbpoints=length(X.counts);

X.omega_step_size=(X.omega_end-X.omega_start)/(X.nbpoints-1);
fprintf('\tCalculated Step Size is %d\n',X.omega_step_size);fflush_stdout();

%Compute angle matrices
X.omega=X.omega_start:X.omega_step_size:X.omega_end;

if X.OmTwoTh
    X.twotheta=(X.omega+X.offset)*2;
    X.theta=X.twotheta/2;
end

%%Finished	
fprintf('\tdone\n');fflush_stdout();fflush_stdout();


end


