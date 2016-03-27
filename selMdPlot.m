% selMdPlot.m
% select model and do fitting plot
clear all;clc;

%% load mod

cd /Users/tancy/fMRIData_RIKEN/AnalyData/Chisato_130215_01/modFit/

Filename = 'Chisato_rOFAFitDataCrt008_Left.mat'; % 
load(Filename)

%%
mcond = 1;
nMd =3;
nsortVol= length(aVol);
framePeriod = 1.05; % 4.04 for high-res; 1.05 for low-res



% decide to plot which voxel
for i = 1:nsortVol
    
    x = 1:size(aVol{i}.y,2);
    y = aVol{i}.y;
    ySte = aVol{i}.dy;
    dn = length(x);
    
    switch mcond  
        
        case 1  % plot max of each model
            
            figure;
            for j = 1:nMd
                
                yFit  = aVol{i}.md{j}.max.yFit;
                r2    = aVol{i}.md{j}.max.r2;
                RMSE  = aVol{i}.md{j}.max.RMSE;
                SSE   = aVol{i}.md{j}.max.sse;
                AICc  = aVol{i}.md{j}.max.AICc;
                vPeak = aVol{i}.md{j}.max.peakMu;
                corR2 = aVol{i}.md{j}.max.corR2;
                
                vP = [vPeak, vPeak, vPeak];
                
                time = linspace(framePeriod/2,(dn-.5)*framePeriod,dn)';
                % plot md1
                
                h1 = subplot(3,1,j);
                errorbar(time,y,ySte,'k-','LineWidth',1);%,'k.-','LineWidth',0.1);hold on
                %plot(time, y,'k-');
                hold on;
            
                % plot(time,model(1:length(time)),'r-','LineWidth',1.5);

                plot(time,yFit,'r-','LineWidth',1.5)
                hold off

                
                %line([time(vP(1)) time(vP(1))],[min(y) max(y)], 'Color',[.8 .8 .8]);
                %line([time(vP(2)) time(vP(2))],[min(y) max(y)], 'Color',[.8 .8 .8]);
                %line([time(vP(3)) time(vP(3))],[min(y) max(y)], 'Color',[.8 .8 .8]);

                title(sprintf('%d GaussFit; r2=%0.3f; corRsq= % 0.3f; SSE = % 0.3f; RMSE = %0.3f; AICc =%0.3f', j, r2, corR2, SSE, RMSE, AICc));

            end
            
                
% 
%                 vPeak1 = aVol{i}.md2max.mu(1);
%                 vPeak2 = aVol{i}.md2max.mu(2);
% 
%                 line([x(vPeak1) x(vPeak1)],[min(y) max(y)], 'Color',[.8 .8 .8]);
%                 line([x(vPeak2) x(vPeak2)],[min(y) max(y)], 'Color',[.8 .8 .8]);
% 
% 
% 
%                 set(gcf,'NextPlot','add');
%                 ax=axes('Units','Normal','Position',[ 0.1 0.01 0.8 0.01],'Visible','off');
%                 %h = title(sprintf( 'Nested Ftest; Model 3 vs 2 p < %0.3f; Model 3 vs 1 p<%0.3f; Model 2 vs 1 p<%0.3f',...
%                 %           aVol{i}.pValue(1),aVol{i}.pValue(2),aVol{i}.pValue(3)));
% 
%                 %h = title(sprintf( 'Nested Ftest; Model 3 vs 2 p < %0.3f; Model 3 vs 1 p<%0.3f; Model 2 vs 1 p<%0.3f',...
%                 %           aVol{i}.pValue(1),aVol{i}.pValue(2),aVol{i}.pValue(3))); 
% 
% 
%                 set(gca,'Visible','off');
%                 set(h,'Visible','on');

           
            
    
        case 2 % plot all fitting md2 
            
            % plot sort
            j = 1; %
            sortNum = 5;
            for k =1:sortNum
                yFit = aVol{i}.md{j}.sort{k}.yFit;
                r2Md = aVol{i}.md{j}.sort{k}.r2;
                AICc = aVol{i}.md{j}.sort{k}.AICc;
                vPeak = aVol{i}.md{j}.sort{k}.stg;

                
                vP = [vPeak, vPeak, vPeak];
                time = linspace(framePeriod/2,(dn-.5)*framePeriod,dn)';
               
                subplot(sortNum,1,k);
                plot(time, y,'o-');
                hold on;

                plot(time,yFit,'r-','LineWidth',1.5)
                hold off
                
                line([time(vP(1)) time(vP(1))],[min(y) max(y)], 'Color',[.8 .8 .8]);
                line([time(vP(2)) time(vP(2))],[min(y) max(y)], 'Color',[.8 .8 .8]);
                line([time(vP(3)) time(vP(3))],[min(y) max(y)], 'Color',[.8 .8 .8]);
                
                title(sprintf('r2=%0.3f; AICc =%0.3f', r2Md, AICc));
            end
            
         
%             figure;
%             
%             plot(x, y,'o-', 'LineWidth',10);
%             hold on;
%             
%             for k = 1: length(aVol{i}.md2)
%                 
%                 plot(x, aVol{i}.md2{k}.yFit,'r-');
%             
%             end
%             
%             title(sprintf(' all fitting curves'));
%             
            
            
       case 3 
            
            yFitmax = aVol{i}.md3max.yFit;
            r2Mdmax = aVol{i}.md3max.r2;
            RMSEmax = aVol{i}.md3max.RMSE;
            AICcmax = aVol{i}.md3max.AICc;
            
            yFitmin = aVol{i}.md3min.yFit;
            r2Mdmin = aVol{i}.md3min.r2;
            RMSEmin = aVol{i}.md3min.RMSE;
            AICcmin = aVol{i}.md3min.AICc;
            
            yFitmid = aVol{i}.md3mid.yFit;
            r2Mdmid = aVol{i}.md3mid.r2;
            RMSEmid = aVol{i}.md3mid.RMSE;
            AICcmid = aVol{i}.md3mid.AICc;
            
            
            
            figure;
            subplot(3,1,1);
            plot(x, y,'o-');
            hold on;

            plot(x,yFitmin,'r-','LineWidth',1.5)
            hold off
            title(sprintf('3 GaussFit_min; r2=%0.3f; RMSE = %0.3f; AICc =%0.3f', r2Mdmin, RMSEmin, AICcmin));
            

            subplot(3,1,2);
            plot(x, y,'o-');
            hold on;
            
            plot(x,yFitmid,'r-','LineWidth',1.5)
            hold off

            title(sprintf(' 3 GaussFit_mid; r2=%0.3f; RMSE = %0.3f; AICc =%0.3f', r2Mdmid, RMSEmid, AICcmid));
 
            
           
            subplot(3,1,3);
            plot(x, y,'o-');
            hold on;
            
            plot(x,yFitmax,'r-','LineWidth',1.5)
            hold off

            title(sprintf(' 3 GaussFit_max; r2=%0.3f; RMSE = %0.3f; AICc =%0.3f', r2Mdmax, RMSEmax, AICcmax));
            
            
            figure;
            
            plot(x, y,'o-', 'LineWidth',10);
            hold on;
            
            for k = 1: length(aVol{i}.md2)
                
                plot(x, aVol{i}.md2{k}.yFit,'r-');
            
            end
            
            title(sprintf(' all fitting curves'));

     
     
    end
    
    
    
end





