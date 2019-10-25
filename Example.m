%% To run an experiment, set the desired values, as outlined below and run Porosity Runner.
%  If you wish to include an experimental datafile in your plot then make
%  sure that ref_path and ref_filename describe a .xrdml file. 


ref_path = 'XRD_Data\';
ref_filename='Porous-DBR-XRD-Data.xrdml';


Repeats = 10;
period =97.2;
Porosity = 37.0;
T_Rat = 0.347;
T_Por = period*T_Rat;
T_GaN = period-T_Por;
T_Temp = 1000;


%% Set boundaries for sliders
RatMin = 0;    
RatMax = 0.5;

PorMin = 0.0;
PorMax = 100.0;

PeriodMin =50.00;
PeriodMax =200.00;

T_TempMin = 0;
T_TempMax = 7000;

SlideVariable