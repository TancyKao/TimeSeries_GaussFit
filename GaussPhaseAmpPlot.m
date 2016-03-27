% GaussPhaseAmpPlot.m
% plot distributation of Orientation and Amp based on Gauss fitting


clear all;
%%

cd /Users/tancy/fMRIData_RIKEN/AnalyData/Wan_140319_01/modFit/   % Chisato_131025_01 Wan_140319_01 Kenji_131209_02

Filename = 'Wan_volMdData007_1_4s_Left.mat'; % Chisato_volMdData01_1_4s Wan_volMdData007_1_4s Kenji_volMdData007_1_4s
load(Filename)


dist_GaussOrient = 1;
dist_ampOrient = 1;

%%
PlotType = 'MaxPeak'; %'MultiPeak'

RotPref=[];
Amp=[];

switch PlotType

    case 'MaxPeak' 

        % only select max peak of each voxel

        for  i = 1: length(volMdDataSum)
                if volMdDataSum{i}.md==1

                    if volMdDataSum{i}.yFitPeak<=0 % remove peak<=0
                        RotPref = cat(2,RotPref,NaN);
                        Amp = cat(2,Amp,NaN);

                    else
                        RotPref = cat(2,RotPref,volMdDataSum{i}.peakMu);
                        Amp = cat(2,Amp,volMdDataSum{i}.yFitPeak);

                    end

                elseif volMdDataSum{i}.md>=2
                     % if fit model more than 2, we choice the peakest one    
                     yFitPeak = volMdDataSum{i}.yFitPeak;
                     peakIndx = find(yFitPeak==max(yFitPeak));
                     RotPref = cat(2,RotPref,volMdDataSum{i}.peakMu(peakIndx));
                     Amp = cat(2,Amp,yFitPeak(peakIndx));



                % No prefer Gaussian
                else

                     RotPref = cat(2,RotPref,NaN);
                     Amp = cat(2,Amp,NaN);
                end

        end

    case 'Mutipeak'

        % select multiple peaks of each voxel
        
        disp('DDDD')

end

 


%% Plot Orientation Perferences 

if dist_GaussOrient ~= 0
    
    figure; % for phase
    
    % high-res
     binranges = [0, 1.5, 3.5, 6.5, 7.5, 9.5];
    
    % low-res
    % binranges = [0,5,11,20,26,31];
    
    [bincounts]=histc(RotPref,binranges);
    
    bar(bincounts,1);%,'histc');
    %set (gca,'XTickLabel',{'L90';'L60';'L30';'0';'R30';'R60';'R90'}) ;
    Labels = {'R90';'R45';'0';'L45';'L90'};
    set (gca,'XTick', 1:5, 'XTickLabel',Labels) ;
    set(gca,'yLim',[0,max(bincounts+2)]);
    
    xlabel('preferred orientation','FontSize',14);
    ylabel('number of voxels','FontSize',14);
    %title(sprintf('Subj-%s; %s; R2> %0.3f; Corr > %0.3f; voxelNum = %d',Subj,roiName,r2Cutoff, CorCutoff, sum(bincounts)),'FontSize',14); 
end

%%
if dist_ampOrient ~= 0
    
    
    figure; % for amp
    
        krange = [0,1.5, 3.5, 6.5, 7.5, 9.5];
        
        %krange = [0,5,11,20,26,31];
        
        for kk = 1:length(krange)-1
            ampIndex = find(RotPref >= krange(kk) & RotPref <= krange(kk+1));                            
            ampsum(kk) = sum(Amp(ampIndex)); 
            ampavg(kk) = mean(Amp(ampIndex));
            ampste(kk) = std(Amp(ampIndex))/sqrt(length(Amp(ampIndex)));% standard error of the mean
            
        end
    
        
    bar(ampavg);% 'histc');
    hold on
    h = errorbar(ampavg,ampste,'k');
    set(h,'linestyle','none');
    %x = linspace(0,pi);
    %plot(ampavg,exp(-ampavg.^2)*300,'r')
    
    % set (gca,'XTickLabel',{'L90';'L60';'L30';'0';'R30';'R60';'R90'}) ;
    
    Labels = {'R90';'R45';'0';'L45';'L90'};
    set (gca,'XTick', 1:5, 'XTickLabel',Labels) ;
   
    
    xlabel('preferred orientation','FontSize',14);
    ylabel('BOLD signal (%)','FontSize',14);
    %title(sprintf('Subj-%s; %s; R2> %0.3f; Corr > %0.3f; voxelNum = %d',Subj,roiName,r2Cutoff, CorCutoff, sum(bincounts)),'FontSize',14);
   
end

