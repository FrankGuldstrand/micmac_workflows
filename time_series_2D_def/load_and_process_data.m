%LOADDATA
% loadData.m loads and formats various elevation and displacement data
% produced with MicMac. Set input and initialize according to data.
%   
%--------------------------------------------------------------------------
% F. B. B. Guldstrand        buster@geo.uio.no                       2017
%--------------------------------------------------------------------------

clear all;

fprintf('\nCalibration of Pixel to Meter:');

%% Choose Points
if exist('LXLY.mat','file')~=2 
calim=imread('cbundistort.tif');
imshow(calim); axis equal;
[x,y]=ginput(4);
close all;

imagesc(calim); hold on; axis equal
plot(x,y,'xr')

%% Pixel to Length Conversion Factor
    
L1=cosd(atand((abs(y(2)-y(1)))/(abs(x(2)-x(1)))))*(26*7e-3); % length of bottom side board in m
L2=cosd(atand((abs(y(3)-y(4)))/(abs(x(3)-x(4)))))*(26*7e-3); % length of top side board in m
LX=((L1/(abs(x(2)-x(1))))+(L2/(abs(x(3)-x(4)))))/2; %m/pixel

L1=cosd(atand((abs(x(4)-x(1)))/(abs(y(4)-y(1)))))*(30*7e-3); % lenght of Left Side board in m
L2=cosd(atand((abs(x(3)-x(2)))/(abs(y(3)-y(2)))))*(30*7e-3); % lenght of Rigt Side board in m
LY=((L1/(abs(y(4)-y(1))))+(L2/(abs(y(3)-y(2)))))/2; % m/pixel

savefile='LXLY.mat';
save(savefile,'LX','LY')

else
load LXLY.mat  
end
%% Input
rootFolder = 'output/';

timeSteps = dir(rootFolder);

fprintf('\nLoading and formating displacement data:');
                        
%% Initialize

QUAL=['-r150'];
THRES=2.5e-5;

% Extract scaling parameters from XML
% folderName = strcat(rootFolder,timeSteps(1),filesep);
nPxlCol = 3800+1;
nPxlRow = 4050+1;

% Figure scaling
x =0:1:nPxlCol;
y =0:1:nPxlRow;

% Allocate memory to variables
M = length(timeSteps)-2;
% indx = reshape(1:((M-1)*nPxlRow*nPxlCol), (M-1), nPxlRow, nPxlCol );

load texp.mat
texp=texp(12:12:314);

int = imageDatastore('../cam1/output/','FileExtensions','.tif'); % Files

mmx=zeros(2,length(timeSteps)-2);
mmy=mmx;
mmss=mmx;
mmdiv=mmx;
sigUx=zeros(3,length(timeSteps)-2);
sigUy=zeros(3,length(timeSteps)-2);
sigU=zeros(1,length(timeSteps)-2);
sigSS=zeros(3,length(timeSteps)-2);
sigDiv=zeros(3,length(timeSteps)-2);

U_x = zeros(M-1,nPxlRow,nPxlCol);
U_x_cum=zeros(nPxlRow,nPxlCol);
U_y = U_x;
U_y_cum=zeros(nPxlRow,nPxlCol);
shear_strain = U_x;
shear_strain_cum=zeros(nPxlRow,nPxlCol);
divergence = U_x;
divergence_cum=zeros(nPxlRow,nPxlCol);
TotMag_cum = zeros(nPxlRow,nPxlCol);
U_ew_prof=zeros(M-1,nPxlCol);
W_ud_prof=zeros(M-1,nPxlCol);


%% Load and format elevation and displacement data

if exist('mmx.mat','file')==2

load('mmy.mat');
load('mmx.mat');
load('mmss.mat');
load('mmdiv.mat');
%choose maximum and minimum

max_x= max(mmx(1,:));
min_x= min(mmx(2,:));

max_y= max(mmy(1,:));
min_y= min(mmy(2,:));

max_ss= max(mmss(1,:));
min_ss= min(mmss(2,:));

max_div= max(mmdiv(1,:));
min_div= min(mmdiv(2,:));

else
for m = 1:1:M
    folderName = strcat(rootFolder,timeSteps(m+2).name,filesep);
    fprintf(['\n-> Processing folder ' folderName]);

        %%% Horizontal displacement fields
        % x-displacement field
        imgName = strcat(folderName,'U_X.tif');
        U_x(m,:,:)= LX*smooth2a(double(imread(imgName)),10,10);
        mmx(1,m)=max(max(squeeze(U_x(m,:,:))));
        mmx(2,m)=min(min(squeeze(U_x(m,:,:))));
%        img = double(img) * resolutionAlti;
%        img(img < -thresholdU | img > thresholdU) = NaN;
              
        % y-displacement field
        imgName = strcat(folderName,'U_Y.tif');
        U_y(m,:,:)= LY*smooth2a(double(imread(imgName)),10,10);
        mmy(1,m)=max(max(squeeze(U_y(m,:,:) )));
        mmy(2,m)=min(min(squeeze(U_y(m,:,:))));

%         img = double(img) * resolutionAlti;
%         img(img < -thresholdU | img > thresholdU) = NaN;
 
        %%% Cauchy tensorial strain components, horizontal plane
        % Using engineering convention for shear strain
        [dUxdx,dUxdy]= gradient(squeeze(U_x(m,:,:)));
        [dUydx,dUydy]= gradient(squeeze(U_y(m,:,:)));
   
        shear_strain=  1/2*(dUxdy+dUydx);
        mmss(1,m)=max(max(shear_strain));
        mmss(2,m)=min(min(shear_strain));
        divergence= (dUxdx+dUydy);
        mmdiv(1,m)=max(max(divergence));
        mmdiv(2,m)=min(min(divergence));
   
        
end
%%Format Colorbar


% Save
savefile='mmx.mat';
save(savefile,'mmx')
savefile='mmy.mat';
save(savefile,'mmy')
savefile='mmss.mat';
save(savefile,'mmss')
savefile='mmdiv.mat';
save(savefile,'mmdiv')
clear savefile

max_x= max(mmx(1,:));
min_x= min(mmx(2,:));

max_y= max(mmy(1,:));
min_y= min(mmy(2,:));

max_ss= max(mmss(1,:));
min_ss= min(mmss(2,:));

max_div= max(mmdiv(1,:));
min_div= min(mmdiv(2,:));


end
%% PLot
clear U_x 

U_x_cum=zeros(size(U_x_cum));

close all;
fprintf('\nVisualizing loaded elevation and displacement data:');

set(0,'defaulttextinterpreter','latex')

mkdir 1.U_x_Inc
mkdir 2.U_x_Cum

for m =1:1:M
    folderName = strcat(rootFolder,timeSteps(m+2).name,filesep);
    fprintf('\nU_x...');
    fprintf(['-> Processing folder ' folderName]);

        %%% Horizontal displacement fields
        % x-displacement field
        imgName = strcat(folderName,'U_X.tif');
        U_x=double(imread(imgName));
        U_x=smooth2a(U_x,20,20);
        U_x(abs(U_x)<0.10)=0;
        U_x=U_x*LX;
        U_ew_prof(m,:)=U_x(950,:);
        
fprintf('\nIncremental Displacement');

%         % Incremental Ux   
%          figU_x = figure;  
%          % Intrusion
%          
%          p1=imread(int.Files{1});
%          p2=imread(int.Files{m+1});
%          t1=p1-p2; % Make change picture Pic
%          img = imbinarize(t1,0.1); % Binarize image in B/W
%          img = bwareafilt(img,[1000 5e8]); % choose three largest areas
%          img(1:950,1:min(size(img)))=0;
%          img(3700:max(size(img)),1:min(size(img)))=0;
% 
%          [I,J]=find(img==1); %Select Edges larger than threshold, active intrusion
%      
%          % Plot  
%          imagesc(x,y,U_x), axis equal, axis tight, box on, hold on
%          plot(J,I,'k.','MarkerSize',1)
%          
%          ax = gca;
%          ax.XTick = [];
%          ax.YTick = [];
%          colormap(ax,darkb2r(min_x,max_x));
%          titleText = sprintf('Time step: %s', timeSteps(m+2).name);
%          title(titleText)
%          suptitle('$U_x$ Incremental');
%          c = colorbar;
% 
%          filename=['1.U_x_Inc/U_x',timeSteps(m+2).name,'.jpg'];
%          print('-painters','-djpeg',QUAL,filename)
%          
%          close all
         
fprintf('\nCumulative Displacement');

        % Cumulative 
%          figU_x_cum = figure;
%          U_x_cum=U_x_cum+U_x;
%          imagesc(x,y,U_x_cum), axis equal, axis tight, box on
%          ax = gca;
%          ax.XTick = [];
%          ax.YTick = [];
%          colormap(ax,darkb2r(sum(mmx(2,:)),sum(mmx(1,:))));
%          titleText = sprintf('Time step: %s', timeSteps(m+2).name);
%          title(titleText)
%          suptitle('$U_x$ Cumulative');
%          c = colorbar;
%          filename=['2.U_x_Cum/U_x',timeSteps(m+2).name,'.jpg'];
%          print('-painters','-djpeg','-r300',filename)
%          close all
%          

%          %Signal
%          U_x(abs(U_x)<THRES)=0;       
%          U_x_pos=U_x(U_x>0);
%          U_x_neg=U_x(U_x<0);
%          
%          sigUx(1,m)=sum(sum(abs(U_x)));
%          sigUx(2,m)=sum(sum(abs(U_x_pos)));
%          sigUx(3,m)=sum(sum(abs(U_x_neg)));
%       
%          clear U_x_pos U_x_neg 
%     
end



savefile='U_ew_prof';
save(savefile,'U_ew_prof','texp');

%%

savefile='SigUx.mat';
save(savefile,'sigUx','texp')
%%
load SigUx.mat
%
close all
hold on
h1=plot(texp,mmx(1,:),'x-r');
h2=plot(texp,abs(mmx(2,:)),'x-b');
ylabel('Max displacement (m)')
xlabel('T (s)')
legend([h1;h2],'Ux Right','Ux Left','Location','NorthWest')
xlim([0 texp(end)])
grid on
box on
  title('Incremental Maximum $U_x$')
         hold off
         filename=['U_x_Max_plot.pdf'];
         print('-painters','-dpdf','-r300',filename)
close all
%%
nel=numel(U_x);

         hold on
         
         h1=plot(texp,sigUx(1,:)./nel,'k','LineWidth',1); % Total Mag
%          h2=plot(texp,movmean(sigUx(1,:)./nel,5),'k','LineWidth',1);
         h3=plot(texp,sigUx(2,:)./nel,'r','LineWidth',1); % Pos Right
%          h4=plot(texp,movmean(sigUx(2,:)./nel,5),'r','LineWidth',1);
         h5=plot(texp,sigUx(3,:)./nel,'b','LineWidth',1); % Neg Left
%          h6=plot(texp,movmean(sigUx(3,:)./nel,5),'b','LineWidth',1);
         grid on
         box on
  
%          legend([h1;h2;h3;h4;h5;h6],'Ux Tot','MovMean','Ux+','MovMean','Ux-','MovMean','Location','NorthWest')
         legend([h1;h3;h5],'Ux Tot','Ux+','Ux-','Location','NorthWest')
         ylabel('Average Displacement (m) per Pixel')
         xlabel('T (s)')
         xlim([0 texp(end)])
         title('Incremental $U_x$')
         hold off
         filename=['U_x_plot.pdf'];
         print('-painters','-dpdf','-r300',filename)
%          close all

%%      
clear U_y 

U_y_cum=zeros(size(U_y_cum));

mkdir 3.U_y_Inc
mkdir 4.U_y_Cum

for m = 1:1:M
    folderName = strcat(rootFolder,timeSteps(m+2).name,filesep);
    fprintf('\nU_y...');
    fprintf(['-> Processing folder ' folderName]);
        
        %%% Horizontal displacement fields
        % y-displacement field

         imgName = strcat(folderName,'U_Y.tif');
         U_y=-1*double(imread(imgName));
         U_y=smooth2a(U_y,20,20);
         U_y(abs(U_y)<0.10)=0;
         U_y=U_y*LY;  
         W_ud_prof(m,:)=U_y(950,:);

%          figU_y = figure;      
%         % Intrusion
%          
%          p1=imread(int.Files{1});
%          p2=imread(int.Files{m+1});
%          t1=p1-p2; % Make change picture Pic
%          img = imbinarize(t1,0.1); % Binarize image in B/W
%          img = bwareafilt(img,[1000 5e8]); % choose three largest areas
%          img(1:950,1:min(size(img)))=0;
%          img(3700:max(size(img)),1:min(size(img)))=0;
% 
%          [I,J]=find(img==1); %Select Edges larger than threshold, active intrusion
% 
%           % Plot  
%          imagesc(x,y,U_y), axis equal, axis tight, box on, hold on
%          plot(J,I,'k.','MarkerSize',1)    
%      
%          ax = gca;
%          ax.XTick = [];
%          ax.YTick = [];
%          colormap(ax,darkb2r(-1*max_y,-0.8*min_y));
%          titleText = sprintf('Time step: %s', timeSteps(m+2).name);
%          title(titleText)
%          suptitle('$U_y$ Incremental');
%          c = colorbar;
%          filename=['3.U_y_Inc/U_y',timeSteps(m+2).name,'.jpg'];
%          print('-painters','-djpeg',QUAL,filename)
%          close all
         
        % Cumulative 
%          figU_y_cum = figure;
%          U_y_cum=U_y_cum+U_y;
%          imagesc(x,y,U_y_cum), axis equal, axis tight, box on
%          ax = gca;
%          ax.XTick = [];
%          ax.YTick = [];
%          colormap(ax,darkb2r(-1*sum(mmy(1,:)),-1*sum(mmy(2,:))));
%          titleText = sprintf('Time step: %s', timeSteps(m+2).name);
%          title(titleText)
%          suptitle('$U_y$ Cumulative');
%          c = colorbar;
%          filename=['4.U_y_Cum/U_y',timeSteps(m+2).name,'.jpg'];
%          print('-painters','-djpeg','-r300',filename)
%          close all

                
%          %Signal
%          U_y(abs(U_y)<THRES)=0;       
%          U_y_pos=U_y(U_y>0);
%          U_y_neg=U_y(U_y<0);
%          
%          sigUy(1,m)=sum(sum(abs(U_y)));
%          sigUy(2,m)=sum(sum(abs(U_y_pos)));
%          sigUy(3,m)=sum(sum(abs(U_y_neg)));
%          
%          clear U_y_pos U_y_neg       
%          
end



savefile='W_ud_prof';
save(savefile,'W_ud_prof','texp');
%%

savefile='SigUy.mat';
save(savefile,'sigUy','texp')
%%
close all
hold on
h1=plot(texp,abs(mmy(2,:)),'x-r');
h2=plot(texp,abs(mmy(1,:)),'x-b');
ylabel('Max displacement (m)')
xlabel('T (s)')
legend([h1;h2],'Uy Up','Uy Down','Location','NorthWest')
xlim([0 texp(end)])
grid on
box on
  title('Incremental Maximum $U_y$')
         hold off
         filename=['U_y_Max_plot.pdf'];
         print('-painters','-dpdf','-r300',filename)
%%       
         close all

load SigUy.mat
nel=numel(U_y);
 
         hold on
         
         h1=plot(texp,sigUy(1,:)./nel,'k','LineWidth',1); % Total Mag
%          h2=plot(texp,movmean(sigUy(1,:)./nel,5),'k','LineWidth',1);
         h3=plot(texp,sigUy(2,:)./nel,'r','LineWidth',1); % Pos Right
%          h4=plot(texp,movmean(sigUy(2,:)./nel,5),'r','LineWidth',1);
         h5=plot(texp,sigUy(3,:)./nel,'b','LineWidth',1); % Neg Left
%          h6=plot(texp,movmean(sigUy(3,:)./nel,5),'b','LineWidth',1);
         grid on
         box on
  
%          legend([h1;h2;h3;h4;h5;h6],'Uy Tot','MovMean','Ux+','MovMean','Ux-','MovMean','Location','NorthWest')
         legend([h1;h3;h5],'Uy Tot','Ux+','Ux-' ,'Location','NorthWest')
         ylabel('Average Displacement (m) per Pixel')
         xlabel('T (s)')
         xlim([0 texp(end)])
         title('Incremental $U_y$')
         hold off
         filename=['U_y_plot.pdf'];
         print('-painters','-dpdf','-r300',filename)
         close all


%%
clear U_x U_y shear_strain divergence 


divergence_cum=zeros(size(U_x_cum));

shear_strain_cum=zeros(size(U_x_cum));

set(0,'defaulttextinterpreter','latex')

mkdir 5.Shear_strain_inc
mkdir 6.Shear_strain_cum
mkdir 7.Divergence_inc
mkdir 8.Divergence_cum

for m = 1:1:M
    folderName = strcat(rootFolder,timeSteps(m+2).name,filesep);
    fprintf('\nShear Strain and Divergence...');
    fprintf(['-> Processing folder ' folderName]);
    
        %%% Horizontal displacement fields

        imgName = strcat(folderName,'U_X.tif');
        
        
        U_x= smooth2a(double(imread(imgName)),30,30)*LX;
%         U_x(abs(U_x) < 0.25)=0;
        
        imgName = strcat(folderName,'U_Y.tif');
        U_y=smooth2a(double(imread(imgName)),30,30)*LY;
%         U_y(abs(U_y)<0.25)=0;

        
       %%% Cauchy tensorial strain components, horizontal plane
        % Using engineering convention for shear strain
        [dUxdx,dUxdy]= gradient(squeeze(U_x));
        [dUydx,dUydy]= gradient(squeeze(U_y));
   
        shear_strain=  1/2*(dUxdy+dUydx);

        divergence= (dUxdx+dUydy);
        
         %Incremental Shear Strain
        
         figSS_inc = figure;      
         
         % Intrusion
         
         p1=imread(int.Files{1});
         p2=imread(int.Files{m+1});
         t1=p1-p2; % Make change picture Pic
         img = imbinarize(t1,0.1); % Binarize image in B/W
         img = bwareafilt(img,[1000 5e8]); % choose three largest areas
         img(1:950,1:min(size(img)))=0;
         img(3650:max(size(img)),1:min(size(img)))=0;

         
         [I,J]=find(img==1); %Select Edges larger than threshold, active intrusion
     
         % Plot  
         imagesc(x,y,shear_strain), axis equal, axis tight, box on, hold on
         plot(J,I,'k.','MarkerSize',1)    

         ax = gca;
         ax.XTick = [];
         ax.YTick = [];
         colormap(ax,darkb2r(0.2*min_ss,0.2*max_ss));
         titleText = sprintf('Time step: %s', timeSteps(m+2).name);
         title(titleText)
         suptitle('Incremental Shear Strain');
         c = colorbar;
         filename=['5.Shear_strain_inc/s_s',timeSteps(m+2).name,'.jpg'];
         print('-painters','-djpeg',QUAL,filename)
         close all
         
     %    Cumulative Shear Strain
%          figSS_cum=figure;
         shear_strain_cum=shear_strain_cum+shear_strain;
%          
%          imagesc(x,y,shear_strain_cum), axis equal, axis tight, box on
%          ax = gca;
%          ax.XTick = [];
%          ax.YTick = [];
%          colormap(ax,darkb2r(0.25*sum(mmss(2,:)),0.25*sum(mmss(1,:))));
%          titleText = sprintf('Time step: %s', timeSteps(m+2).name);
%          title(titleText)
%          suptitle('Cumulative Shear Strain');
%          c = colorbar;
%          filename=['6.Shear_strain_cum/s_s',timeSteps(m+2).name,'.jpg'];
%          print('-painters','-djpeg','-r300',filename)
%          close all     
%          
            %Signal     
         SS_pos=shear_strain(shear_strain>0);
         SS_neg=shear_strain(shear_strain<0);
         
         sigSS(1,m)=sum(sum(abs(shear_strain)));
         sigSS(2,m)=sum(sum(abs(SS_pos)));
         sigSS(3,m)=sum(sum(abs(SS_neg)));
         
         %Incremental Divergence
         
%          figDiv_cum = figure; 
%          
%          imagesc(x,y,divergence), axis equal, axis tight, box on
%          ax = gca;
%          ax.XTick = [];
%          ax.YTick = [];
%          colormap(ax,darkb2r(0.5*min_div,0.5*max_div));
%          titleText = sprintf('Time step: %s', timeSteps(m+2).name);
%          title(titleText)
%          suptitle('Incremental Divergence');
%          c = colorbar;
%          filename=['7.Divergence_inc/Div',timeSteps(m+2).name,'.jpg'];
%          print('-painters','-djpeg','-r300',filename)
%          close all
%          
         % Cumulative Divergence 
%          figDiv = figure;
         divergence_cum=divergence_cum+divergence;
%          imagesc(x,y,divergence_cum), axis equal, axis tight, box on
%          ax = gca;
%          ax.XTick = [];
%          ax.YTick = [];
%          colormap(ax,darkb2r(0.25*sum(mmdiv(2,:)),0.25*sum(mmdiv(1,:))));
%          titleText = sprintf('Time step: %s', timeSteps(m+2).name);
%          title(titleText)
%          suptitle('Cumulative Divergence');
%          c = colorbar;
%          filename=['8.Divergence_cum/Div',timeSteps(m+2).name,'.jpg'];
%          print('-painters','-djpeg','-r300',filename)
%          close all
%          
         Div=divergence;
         
             %Signal     
         Div_pos=Div(Div>0);
         Div_neg=Div(Div<0);
         
         sigDiv(1,m)=sum(sum(abs(Div)));
         sigDiv(2,m)=sum(sum(abs(Div_pos)));
         sigDiv(3,m)=sum(sum(abs(Div_neg)));


end   
%%
hist(shear_strain_cum(:),1000);
      ylabel('Bin Count')
         xlabel('Shear Strain')
         title('Cumulative Shear Strain Histogram')
         hold off
         filename=['SSHist'];
         print('-painters','-dpdf','-r300',filename)


%%
close all
        hold on
         
         h1=plot(sigSS(1,:),'k.');
         h2=plot(sigSS(2,:),'b');
         h3=plot(-1.*sigSS(3,:),'b');
         
         h4=plot(sigDiv(1,:),'k');
         h5=plot(sigDiv(2,:),'r');
         h6=plot(-1.*sigDiv(3,:),'r');
         grid on
         box on
  
         legend([h1;h2;h3;h4;h5;h6],'SS Tot','SS+','SS-','Div Tot','Div+','Div-','NorthEast')
         ylabel('Normalised Signal')
         xlabel('Time Step')
         title('Shear Strain and Divergence')
         hold off
         filename=['SSandDiv.pdf'];
         print('-painters','-dpdf','-r300',filename)
         close all



%% Test

temp=divergence_cum;
temp(temp>0)=0;
mintemp=sum(sum(temp));
% temp(temp==0)=NaN;
 imagesc(x,y,temp), axis equal, axis tight, box on
         ax = gca;
         ax.XTick = [];
         ax.YTick = [];
         colormap(ax,darkb2r(-0.2,0));
         titleText = sprintf('Larger Negative Values Exist');
         title(titleText)
         suptitle('Negative Divergence');
         c = colorbar;
         filename=['8.Divergence_cum/NegDivforcomp.jpg'];
         print('-painters','-djpeg','-r300',filename)
         close all




%% Total Magnitude
% 
mkdir 9.TotalMagnitude_Inc
mkdir 10.TotalMagnitude_Cum
for m = 1:1:M
    folderName = strcat(rootFolder,timeSteps(m+2).name,filesep);
    fprintf('\nTotal Magnitude...');
    fprintf(['-> Processing folder ' folderName]);
    
        %%% Horizontal displacement fields

        imgName = strcat(folderName,'U_X.tif');
        U_x= smooth2a(double(imread(imgName)),30,30);
        imgName = strcat(folderName,'U_Y.tif');
        U_y= smooth2a(double(imread(imgName)),30,30);
        
         U_y(abs(U_y)<0.1)=0;  
         U_x(abs(U_x)<0.1)=0;
         U_x=U_x*LX;
         U_y=U_y*LY;
        
       %%% Total Magnitude Displacement 
        % Incremental

          TotM= sqrt(U_x.^2 + U_y.^2);
        
         figTotM = figure;      
         imagesc(x,y,TotM), axis equal, axis tight, box on
         ax = gca;
         ax.XTick = [];
         ax.YTick = [];
         
         limMaxu=max(max_x,max_y);
         limMinu=max(abs(min_x),abs(min_y));
         limMu=max(limMaxu,limMinu); 
         
         clear limMaxu limMinu
         colormap(ax,darkb2r(0,limMu));
         titleText = sprintf('Time step: %s', timeSteps(m+2).name);
         title(titleText)
         suptitle('$U$ Incremental');
         c = colorbar;
         filename=['9.TotalMagnitude_Inc/TotM',timeSteps(m+2).name,'.jpg'];
         print('-painters','-djpeg','-r300',filename)
         close all
        
        % Cumulative
         TotMag_cum=TotMag_cum+TotM;
         
        figTotM_cum = figure;      
         imagesc(x,y,TotMag_cum), axis equal, axis tight, box on
         ax = gca;
         ax.XTick = [];
         ax.YTick = [];
         
         limMaxu=max(sum(mmx(1,:)),sum(mmy(1,:)));
         limMinu=max(sum(abs(mmx(2,:))),sum(abs(mmy(2,:))));
         limMu=max(limMaxu,limMinu); 
           clear limMaxu limMinu
         colormap(ax,darkb2r(0,limMu));
         titleText = sprintf('Time step: %s', timeSteps(m+2).name);
         title(titleText)
         suptitle('$U$ Cumulative');
         c = colorbar;
         filename=['10.TotalMagnitude_Cum/TotM',timeSteps(m+2).name,'.jpg'];
         print('-painters','-djpeg','-r300',filename)
         close all
         
end   


fprintf('\n-> Cleaning up')
% clearvars -except timeSteps x y DEM U_DEM U_x U_y shear_strain divergence 

fprintf('\nDone!\n')
