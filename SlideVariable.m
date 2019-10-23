close all;

%% Set up plot and plot experimental data
f1=figure ('name',ref_filename);
set(f1);%,'position',full_seen_pos);
% Plot relevant experimental scans
Exp = XRDmlPlotter(ref_path, ref_filename);

%% Build Struct for input data
Inputs = struct ( 'Repeats', Repeats,...
				'Period',period,...
                'Porosity',Porosity,...
                'T_Rat',T_Rat,...
                'T_Por',T_Por,...
				'T_GaN',T_GaN,...
				'T_Temp',T_Temp,...
                'ref_path',ref_path,...
                'ref_filename',ref_filename);

%% Plot initial Simulation
% % No Absorption
% Sim = DBRsimFunc(Inputs.Porosity, Inputs.T_Por, Inputs.T_GaN, Inputs.Repeats, Inputs.T_Temp, Inputs.ref_path, Inputs.ref_filename,0);
% SimPlot1 = semilogy(Sim.relarcsec,Sim.counts, 'DisplayName',[...
%             'Period = ' num2str(Sim.porethickness+Sim.GaNthickness) 'nm, ',...
%             'T-Por = ' num2str(Sim.porethickness) 'nm, ',...
%             'T-GaN = ' num2str(Sim.GaNthickness) 'nm, ',...
%             'Porosity = ' num2str(Sim.porosity) '%, ',...
%             'Neglecting Absorption'],'color','green');
% hold on;
% With Absorption
SimAbs = DBRsimFunc(Inputs.Porosity, Inputs.T_Por, Inputs.T_GaN, Inputs.Repeats, Inputs.T_Temp, Inputs.ref_path, Inputs.ref_filename,1);
SimPlotAbs1 = semilogy(SimAbs.relarcsec,SimAbs.counts, 'DisplayName',[...
            'Period = ' num2str(SimAbs.porethickness+SimAbs.GaNthickness) 'nm, ',...
            'T-Por = ' num2str(SimAbs.porethickness) 'nm, ',...
            'T-GaN = ' num2str(SimAbs.GaNthickness) 'nm, ',...
            'Porosity = ' num2str(SimAbs.porosity) '%, ',...
            'Including Absorption'],'color','magenta');
       
        
% % These lines are for plotting other curves from the sim. To use uncomment:
%     A "delete" line for each one (around line 207)
%     The relevant replot line (around line 226)

% Periodic = semilogy(SimAbs.relsec_parts,SimAbs.periodic,'color','black','DisplayName','Periodic');
% Envelope = semilogy(SimAbs.relsec_parts,SimAbs.crosstalk/1000000,'color','blue','DisplayName','Envelope');
% Envelope2 = semilogy(Sim.relsec_parts,Sim.crosstalk/1000000,'color','black','DisplayName','Envelope');

% Y1 = semilogy(SimAbs.relsec_parts,SimAbs.periodic.*SimAbs.crosstalk/1000000,'color','red','DisplayName','Y1');

xlim([-2000 2000]);

% Set axis position within figure
set(gca,'outerposition',[0,0.12,1,0.9])

set(gcf,'position',[0,0,1024,650])
legend(gca,'show');
%% Make GUI things
% T_Rat controls
    % Label
uicontrol('Style', 'text', 'string', 'T_Rat value is:','Position',[0 50 200 20]);
    % Value
uicontrol('Style', 'text', 'Position',[135 50 50 20],'Tag','T_RatVal');
    % Define slider 
T_RatSlider = uicontrol('Style', 'slider', 'Callback', @T_RatCallback,'Position',[50 20 200 20],...
                        'Min',RatMin,'Max',RatMax,'Value',T_Rat,'UserData',Inputs,'Tag','T_RatSlider');

% Porosity controls
    % Label
uicontrol('Style', 'text', 'string', 'Porosity value is:','Position',[250 50 220 20]);
    % Value
uicontrol('Style', 'text', 'Position',[400 50 50 20],'Tag','PorVal');
    % Define slider 
PorSlider = uicontrol('Style', 'slider', 'Callback', @PorCallback,'Position',[280 20 200 20],...
                        'Min',PorMin,'Max',PorMax,'Value',Porosity,'UserData',Inputs,'Tag','PorSlider');                    
                    
% Period controls
    % Label
uicontrol('Style', 'text', 'string', 'Period value is:','Position',[490 50 220 20]);
    % Value
uicontrol('Style', 'text', 'Position',[640 50 50 20],'Tag','PeriodVal');
    % Define slider 
PeriodSlider = uicontrol('Style', 'slider', 'Callback', @PeriodCallback,'Position',[540 20 200 20],...
                        'Min',PeriodMin,'Max',PeriodMax,'Value',period,'UserData',Inputs,'Tag','PeriodSlider');
                    
% T_Temp controls
    % Label
uicontrol('Style', 'text', 'string', 'Template thickness is:','Position',[740 50 230 20]);
    % Value
uicontrol('Style', 'text', 'Position',[910 50 100 20],'Tag','T_TempVal');
    % Define slider 
T_TempSlider = uicontrol('Style', 'slider', 'Callback', @T_TempCallback,'Position',[790 20 200 20],...
                        'Min',T_TempMin,'Max',T_TempMax,'Value',T_Temp,'UserData',Inputs,'Tag','T_TempSlider');                    
%% GUI control functions
% Display Initial Slider Values
    % Get slider object
    h = findobj('Tag','T_RatSlider');
    %Display slider value
    Text = findobj('Tag','T_RatVal');    
    set(Text,'String',num2str(h.UserData.T_Rat));
    
    % Get slider object
    h = findobj('Tag','PorSlider');
    % Display slider value
    Text = findobj('Tag','PorVal');    
    set(Text,'String',num2str(h.UserData.Porosity));
    
    % Get slider object
    h = findobj('Tag','PeriodSlider');
    % Display slider value
    Text = findobj('Tag','PeriodVal');    
    set(Text,'String',num2str(h.UserData.Period));

    % Get slider object
    h = findobj('Tag','T_TempSlider');
    % Display slider value
    Text = findobj('Tag','T_TempVal');    
    set(Text,'String',num2str(h.UserData.T_Temp));
    
% T_Rat Slider
function T_RatCallback(hObject, evt, handles, varargin)
    % Get slider object
    h = findobj('Tag','T_RatSlider');
%     Get slider value
    h.UserData.T_Rat = get(hObject, 'Value');
%    Display slider value
    Text = findobj('Tag','T_RatVal');    
    set(Text,'String',num2str(h.UserData.T_Rat));
    
    % Could add something to appear here and disappear after Replot has
    % been called, to indicate clearly when it is updating.
    Replot;
end

% Porosity Slider
function PorCallback(hObject, evt, handles, varargin)
    % Get slider object
    h = findobj('Tag','PorSlider');
%     Get slider value
    h.UserData.Porosity = get(hObject, 'Value');
%    Display slider value
    Text = findobj('Tag','PorVal');    
    set(Text,'String',num2str(h.UserData.Porosity));
    
    % Could add something to appear here and disappear after Replot has
    % been called, to indicate clearly when it is updating.
    Replot;
end

% Period Slider
function PeriodCallback(hObject, evt, handles, varargin)
    % Get slider object
    h = findobj('Tag','PeriodSlider');
%     Get slider value
    h.UserData.Period = get(hObject, 'Value');
%    Display slider value
    Text = findobj('Tag','PeriodVal');    
    set(Text,'String',num2str(h.UserData.Period));
    
    % Could add something to appear here and disappear after Replot has
    % been called, to indicate clearly when it is updating.
    Replot;
end

% T_Temp Slider
function T_TempCallback(hObject, evt, handles, varargin)
    % Get slider object
    h = findobj('Tag','T_TempSlider');
%     Get slider value
    h.UserData.T_Temp = get(hObject, 'Value');
%    Display slider value
    Text = findobj('Tag','T_TempVal');    
    set(Text,'String',num2str(h.UserData.T_Temp));
    
    % Could add something to appear here and disappear after Replot has
    % been called, to indicate clearly when it is updating.
    Replot;
end

% Replot function
function Replot()
    % Get new variables
    h = findobj('Tag','T_RatSlider');
	TRatStruct = h.UserData;
    h = findobj('Tag','PorSlider');
    PorStruct = h.UserData;
    h = findobj('Tag','PeriodSlider');
    PeriodStruct = h.UserData;
    h = findobj('Tag','T_TempSlider');
    T_TempStruct = h.UserData;
    
    % Calculate layer thickness from period and ratio
    TRatStruct.T_Por = PeriodStruct.Period*TRatStruct.T_Rat;
    TRatStruct.T_GaN = PeriodStruct.Period-TRatStruct.T_Por;
    
    PeriodStruct.T_Por = TRatStruct.T_Por;
    PeriodStruct.T_GaN = TRatStruct.T_GaN;
    
    % Recalculate graph
    Sim = DBRsimFunc(PorStruct.Porosity, TRatStruct.T_Por, TRatStruct.T_GaN, TRatStruct.Repeats, T_TempStruct.T_Temp, TRatStruct.ref_path, TRatStruct.ref_filename,0);
    SimAbs = DBRsimFunc(PorStruct.Porosity, TRatStruct.T_Por, TRatStruct.T_GaN, TRatStruct.Repeats, T_TempStruct.T_Temp, TRatStruct.ref_path, TRatStruct.ref_filename,1);
    
    % Delete previous simulation
    h = findobj(gca,'type','line');
    delete(h(1));
%     delete(h(2));
%     delete(h(3));
%     delete(h(4));
    
    % Replot graph
%     SimPlot1 = semilogy(Sim.relarcsec,Sim.counts, 'DisplayName',[...
%             'Period = ' num2str(Sim.porethickness+Sim.GaNthickness) 'nm, ',...
%             'T-Por = ' num2str(Sim.porethickness) 'nm, ',...
%             'T-GaN = ' num2str(Sim.GaNthickness) 'nm, ',...
%             'Porosity = ' num2str(Sim.porosity) '%, ',...
%             'Neglecting Absorption'],'color','green');
        
    SimPlotAbs1 = semilogy(SimAbs.relarcsec,SimAbs.counts, 'DisplayName',[...
            'Period = ' num2str(SimAbs.porethickness+SimAbs.GaNthickness) 'nm, ',...
            'T-Por = ' num2str(SimAbs.porethickness) 'nm, ',...
            'T-GaN = ' num2str(SimAbs.GaNthickness) 'nm, ',...
            'Porosity = ' num2str(SimAbs.porosity) '%, ',...
            'Including Absorption'],'color','magenta');
%     Periodic = semilogy(SimAbs.relsec_parts,SimAbs.periodic,'color','black','DisplayName','Periodic');
%     Envelope = semilogy(SimAbs.relsec_parts,SimAbs.crosstalk/1000000,'color','blue','DisplayName','EnvelopeAbs');
%     Envelope2 = semilogy(Sim.relsec_parts,Sim.crosstalk/1000000,'color','black','DisplayName','Envelope');
%     Y1 = semilogy(SimAbs.relsec_parts,SimAbs.periodic.*SimAbs.crosstalk/1000000,'color','red','DisplayName','Y1');
end
