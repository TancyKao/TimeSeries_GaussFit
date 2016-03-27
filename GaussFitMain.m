% Main program for GaussFit

clear all;clc;  warning('off');

%% load Data
    cd /Users/tancy/fMRIData_RIKEN/AnalyData/Wan_121214_01/

    Filename1 = 'rOFA_final_Concatenation_1.mat'; % 
    load(Filename1)

    Filename2 = 'rOFA_final_ConcateTruncate_1_4s.mat'; % load corr data
    load(Filename2)

    modfitfolder='/Users/tancy/fMRIData_RIKEN/AnalyData/Wan_121214_01/modFit/';
    
    Savename=[modfitfolder,'Wan_rOFAFitData'];
%% free parameters
    
    % set criterial
    r2Cutoff = 0.07; % find the voxels whose r2 are significant p<.05 
    corrCutoff = 0.00; % Corr could be 0

    r2Index = find(TargRoi_r2 >= r2Cutoff);
    CorrIndex = find(covalData >= corrCutoff);
    r2CorrIndex = intersect(r2Index,CorrIndex);
    
    
    % define the voxelIndex we want to fit
    dataVoxel = r2CorrIndex; 
    
    % for debug
    %dataVoxel = [160];% define the voxelIndex we want to fit
    %timeIntervals = [1 8; 5 10; 10 20;20 25; 25 31];%10; 10 31];
    

    
%% output selection
    
    % apply filter or not
    gtfilter = 1; 
    
    % which models to use 
    numMd = 3; % 0, 3, or 99 
    singleMd = 2; % numMd ==99; singleMd =1, 2, 3
    
    
    % smallest step between two fitting curves
    initalstep = int8(3); 
    
    % repeat
    repStimulate = 1; % repeated stimulation
        
    
    % draw figure
    drwFig = 1;

    % save data
    svOutput = 1;
    
   
    
    %% segnum
    
    seg{1} = [1 31];
%     seg{1} = [1 9];
%      seg{2} = [1 15; 15 31];
%      seg{3} = [1 10; 10 20; 20 31];
%      seg{4} = [1 8; 8 16; 16 24; 25 31];
%      seg{5} = [1 5; 6 10; 11 20; 21 25; 26 31];
    
%%
% 
  fittedCurves = cell(1);
  guDataVoxel = [];
  tic
  for i = 1: length(dataVoxel)

      %  apply Gaussian temporal filter to single Tseries
        if gtfilter ~= 0

            sigma = 0.5;
            gsize = 100;
            gx = linspace(-gsize / 2, gsize / 2, gsize);
            gaussFilter = exp(-gx .^ 2 / (2 * sigma ^ 2));
            gaussFilter = gaussFilter / sum (gaussFilter); % normalize
            
            seTemp = sptseries(dataVoxel(i),:);
            yfilt = filter (gaussFilter,1,seTemp );
            yfilt = conv (seTemp, gaussFilter, 'same');
            
            data2fit = yfilt;
        else
            data2fit = sptseries(dataVoxel(i),:);

        end
      
      
        dy = sptseriesSte(dataVoxel(i),:); 

        k = 0; % start to stimulation
        while k < repStimulate
              k = k + 1;
           
            % Gaussian fit 
           
            m = 0;
            while m < size(seg,2);
                m = m+1;
                timeIntervals = seg{m};
                            
                for ixTimeInterval=1:size(timeIntervals,1)
                
                y = data2fit(timeIntervals(ixTimeInterval, 1):timeIntervals(ixTimeInterval, 2));
                x = timeIntervals(ixTimeInterval, 1):timeIntervals(ixTimeInterval, 1) + length(y)-1;
                dn = length(x); % data points
               
                    switch numMd
                        
                        
                        
                        case 0
                            segmd_0
                        case 3
                            segmd_1
                            segmd_2
                            segmd_3
                            
                         case 99
                            switch singleMd
                                case 1
                                    segmd_1
                                case 2
                                    segmd_2
                                case 3
                                    segmd_3
                            end
                    end

               
                %[gaubt,r,J,cov,mse, yFit, p, mu] = segGaussFit(x, y, numMd,initalstep);
                  
                
                end % end of ixTimInterval
   
                
            end % segment of time
            
            
            
 
 
        end % repeat stimulate
 
        
        Vol{i}.Index = dataVoxel(i);
        Vol{i}.y = y;
        Vol{i}.dy = dy;
       
        
  end % for voxels
toc


  
  
  
  if svOutput ~= 0;
      
      
      save(Savename,'Vol');
      disp('Fitting Done')
  end
        
  
  
  
  
  
  
% p1(1) = y(abs(y)==max(abs(y))); %min(YlimRange)+rand*sum([abs(min(YlimRange)),abs(max(YlimRange))]);
%             p1(2) = mean(x) + mean(y);  
%             p1(3) = std(y);
            
  
  
%     for ixTimeInterval=1:size(timeIntervals,1)
%             
%             data = sptseries(dataVoxel(i),:); % select voxel
%             y = data2fit(timeIntervals(ixTimeInterval, 1):timeIntervals(ixTimeInterval, 2));
%             x = timeIntervals(ixTimeInterval, 1):timeIntervals(ixTimeInterval, 1) + length(y)-1;
%framePeriod = 4.04;
    
%                 if size(y,1)>1
%                     dy = y(2,:);  % second line = error bars (1/weight)
%                     y = y(1,:);   % first line = data
%                 else
%                     dy = ones(1,length(y));    % default error bars: 1
%                 end % if size


