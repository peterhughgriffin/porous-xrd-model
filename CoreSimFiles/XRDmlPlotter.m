%% This function takes a given folder and plots all the xrdml files it finds in it on one logy plot.

function Exp = XRDmlPlotter(ref_path, ref_filename)

close all;

% %% File info
% ref_path = 'C6533D\';
% Can use match_string to plot multiple xrdml files in a directory
% files = dir (strcat(ref_path,'*',match_string,'*.xrdml'));
files = dir (strcat(ref_path,ref_filename));

%% Figure Setup
% full_seen_pos = [20,20,1220,620];
f1=figure ('name',ref_path);
% set(f1,'position',full_seen_pos);

%% Loop through given directory and draw graphs
for file = files'
    Exp = data_read(file.name,ref_path);
    %searching for maximum
	Exp = simu_max_find (Exp);
    Exp.RelArcSec = (Exp.theta-Exp.max_theta)*3600;
    semilogy(Exp.RelArcSec,Exp.counts, 'DisplayName',Exp.name);
    legend('-DynamicLegend');
    hold on;   
end

xlabel('Angle (Relative secs)');
ylabel('Intensity (Count per second)');


end