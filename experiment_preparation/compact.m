%% Script for calculating compaction %%
% 
%   By Frank Bo Buster Guldstrand, PhD-Candidate
%   Physics of Geological Processes
%   University of Oslo
%   2015

clear all; close all; clc;

% Input vectors
t=[];
Mes1=[]; % lower left corner
Mes2=[]; % Upper left corner
Mes3=[]; % Upper Right Corner
Mes4=[]; % Lower Right Corner

display('This script calculates the density of the host medium')
display('Suggested procedure is measuring depth in the corners of the')
display('box starting with the lower left corner and proceeding clockwise')
display('and then repeating this every 30 seconds.')
display('')

exptype=input('Enter experiment type (intrusion/test/shearbox): ','s');
expname=input('Enter experimenters initials: ','s');
expnr=input('Enter experiment nr: ','s');
expdate=input('Enter experiment date (DDMMYY): ','s');

% Constant inputs
M = input('Enter mass in kg (16): '); % mass in kg
%M = 16; % mass in kg
HeightPipe = input('enter height of pipe (m) (0.033): ');

Hw = input('enter nr of sections of walls used (0,1,2 or 3): ');
if Hw == 0;   
    Hw=0.085; % m   
elseif Hw == 1;
    Hw=0.135; % m
elseif Hw == 2;
    Hw=0.185;% m orig (0.1856)
elseif Hw == 3;
    Hw=0.235; % m
end

reply = input('Do you want to start measurement? (y/n): ','s');

%% Constants %%

thickp = 0.01; % thickness of plate

%Counter
n=0;
while reply =='y';


n=n+1; % counter

%% INPUTS %%

% depth measurements from top of box to surface
% starting from lower left corner moving clockwise

% Mes1 = [0.0977, 0.1074, 0.1086, 0.1086, 0.1132, 0.1137, 0.1138];
mestemp=input('Enter measure from lower left corner (cm): ');
Mes1(n) = mestemp/100;

% Mes2 = [0.0981, 0.1088, 0.1102, 0.1102, 0.114, 0.115, 0.1125];
mestemp=input('Enter measure from upper left corner (cm): ');
Mes2(n) = mestemp/100;

% Mes3 = [0.0978, 0.1085, 0.1123, 0.1138, 0.1109, 0.1121, 0.1128];
mestemp=input('Enter measure from upper right corner (cm): ');
Mes3(n)=mestemp/100;

% Mes4 = [0.0976, 0.1078, 0.1111, 0.1133, 0.1116, 0.1119, 0.1149];
mestemp=input('Enter measure from lower right corner (cm): ');
Mes4(n)=mestemp/100;

mes=[Mes1', Mes2', Mes3', Mes4'];       

%t = [0,30,60,90,120,150,180]'; % Time in seconds

if n > 1
t = [t,input('Enter time in seconds: ')]; % Time in seconds
else
display('');
t =[0]; display ('time = 0 second') 
end



%% Calculation %%

% thickness of flour in four corners
thick=(Hw*ones(size(mes)))-(thickp*ones(size(mes)))-mes;

AvThick=zeros(length(t'),1); % Average thickness for each timestep
Dpipe=zeros(length(t'),1);   % Depth to pipe
Vol=zeros(length(t'),1);     % cube volume
Volpipe=pi*0.005*0.005*HeightPipe; %The volume of inletpipe
Volflour=zeros(length(t'),1);    % Volume of silica flour
DensityFlour=zeros(length(t'),1); % Silica flour density

for i=1:length(t');   
    averagethickness = mean(thick(i,:));
    AvThick(i)=averagethickness;  
    Dpipe(i)=averagethickness-HeightPipe;
    Vol(i)=averagethickness*0.4*0.4;
    Volflour(i)=Vol(i)-Volpipe;
    DensityFlour(i)=M/Volflour(i);   
end

if n == 1 % Sets Initial Density
    InitialDensity = DensityFlour(1);  %863; %1285.623;
    else
end

% Calculate density difference and ratio with respect to inital density
    % Compacted density - initial density

dendiff = DensityFlour-InitialDensity;
denratio = DensityFlour./InitialDensity-1;
display('');
display('Results')
display('t(s), Density, Den-diff, Den-ratio')
for p=1:n
fprintf('%4.0f     %4.0f     %4.0f     %4.3f\n',t(p), DensityFlour(p), dendiff(p), denratio(p))
end

reply = input('do you want to do another measurement? (y/n): ','s');

end

%% PLOTTING %%
totexpname=[exptype,'_',expname,'_',expnr,'_',expdate];

display('Plotting Results');

    fn=figure(1);
    subplot(1,3,1)
    plot(t',DensityFlour,'-x')
    title('$$\rho_{[kg/m^{3}]}$$ vs $$ t_{(s)}$$','Interpreter','latex')
    grid on

    subplot(1,3,2)
    plot(t',dendiff,'-x')
    title('$$\Delta\rho_{[kg/m^{3}]}$$ vs $$t_{(s)}$$','Interpreter','latex')
    grid on

    subplot(1,3,3)
    plot(t',denratio,'-x')
    title('$$\rho_{[kg/m^{3}]}$$ ratio vs $$t_{(s)}$$','Interpreter','latex')
    grid on
%% SAVING %%

saveplace=[pwd,'/',totexpname];
    print(fn,saveplace,'-dpdf')

filename = [totexpname '.csv'];

fid = fopen(filename, 'w');
fprintf(fid, 't, densityflour, densitydiff, densityratio, depth to pipe\n');
fclose(fid);

A = [t' DensityFlour dendiff denratio Dpipe];

dlmwrite(filename, A, '-append', 'precision', '%.4f', 'delimiter', ',');
