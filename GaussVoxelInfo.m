% GaussVoxellnfo.m
% Based on Gaussian model 
% save voxel info, coord, amp, and orient

%

clear all;
%% load Data

    cd /Users/tancy/fMRIData_RIKEN/AnalyData/Chisato_130215_01/

    Filename1 = 'r_pFFA_OFA_combine_Concatenation_1.mat'; % 
    load(Filename1)

    Filename2 = 'r_pFFA_OFA_combine_ConcateTruncate_1_4s.mat'; % load corr data
    load(Filename2)

    modfitfolder='/Users/tancy/fMRIData_RIKEN/AnalyData/Chisato_130215_01/modFit/';
    
    svOutput = 1;
    Savename =[modfitfolder, 'Chisato_critData2fit_r2_008'];
    
    
%% free parameters
    
    % set criterial
    r2Cutoff = 0.08; % find the voxels whose r2 are significant p<.05 
    corrCutoff = 0.00; % Corr could be 0

    r2Index = find(TargRoi_r2 >= r2Cutoff);
    CorrIndex = find(covalData >= corrCutoff);
    r2CorrIndex = intersect(r2Index,CorrIndex);
    
    
    % define the voxelIndex we want to fit
    dataVoxel = r2CorrIndex; 

%% GaussVoxel

critData=[];
for i = 1: length(dataVoxel)
    
    critData{i}.index = dataVoxel(i);
    critData{i}.coord = roiCoords(:,dataVoxel(i));
    critData{i}.r2 = TargRoi_r2(dataVoxel(i));
    critData{i}.coh = covalData(dataVoxel(i));
    critData{i}.ph = phvalData(dataVoxel(i));
    
    
end    


if svOutput ~= 0;
      
      
      save(Savename,'critData');
      disp('critData2fit save Done')
      
end








