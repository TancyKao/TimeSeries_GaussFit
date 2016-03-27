% selMdSelect.m
%
% purpose: select the best fitting models
% after GaussFitMain.m selMdStat2.m
% 1. set crit for r2
% 2. compare AICc
% 
% Tancy 140820 wrote



%% load Data

clear all;clc;

%% load mod

cd /Users/tancy/fMRIData_RIKEN/AnalyData/Chisato_131025_01/modFit/

Filename = 'Chisato_FitStatCrt01_1_4s.mat'; % 
load(Filename)

% setting
nsortVol= length(aVol);

r2_crit = 0.5; % set r2 criteria
AICdiff_crit = 2; 

svOutput =1;
Savename = ['Chisato_volMdData01_1_4s'];

%%
volMdData=[];
for i = 1:nsortVol
    
    x = 1:size(aVol{i}.y,2);
    y = aVol{i}.y;
    dn = length(x);
    
    % compare r2 of three fitting conditions
    rsq_1 = aVol{i}.md{1}.max.r2;
    rsq_2 = aVol{i}.md{2}.max.r2;
    rsq_3 = aVol{i}.md{3}.max.r2;
    rsqAll = [rsq_1 rsq_2 rsq_3];
    
    AICc_1 = aVol{i}.md{1}.max.AICc;
    AICc_2 = aVol{i}.md{2}.max.AICc;
    AICc_3 = aVol{i}.md{3}.max.AICc;
    AICcAll = [AICc_1 AICc_2 AICc_3];
    
    
    rsqIndex = find(rsqAll>=r2_crit);

    if isempty(rsqIndex) % no prefer any model

        volMdData(i) = 0;

    % find the best fitting
    elseif length(rsqIndex)==3 % 3 rsq > crit

        
        modelBad = find(AICcAll == max(AICcAll(rsqIndex)));
        modelGood = find(AICcAll == min(AICcAll(rsqIndex)));
        secondGood = 6-modelGood-modelBad;
        
        diffAICc = abs(abs(AICcAll(modelGood))-abs(AICcAll(secondGood)));
        
        
        % determine diffAIC and all mu > 0
        if diffAICc <= AICdiff_crit & sum(y(aVol{i}.md{modelGood}.max.mu)>0) == modelGood
            
            volMdData(i) = modelGood;
        
        % if goodmodel contains negative mu, we selected small model     
        elseif diffAICc <= AICdiff_crit & sum(y(aVol{i}.md{modelGood}.max.mu)>0) ~= modelGood
            
            volMdData(i) = modelGood-1;
             
        elseif diffAICc >= AICdiff_crit
            
            volMdData(i) = modelGood;
        end
    
     elseif  length(rsqIndex)==2
                
        modelGood = find(AICcAll == min(AICcAll(rsqIndex)));
        secondGood =find(AICcAll == max(AICcAll(rsqIndex)));
        
        diffAICc = abs(abs(AICcAll(modelGood))-abs(AICcAll(secondGood)));
         
        % determine diffAIC and all mu > 0
        if diffAICc <= AICdiff_crit & sum(y(aVol{i}.md{modelGood}.max.mu)>0) == modelGood
            
            volMdData(i) = modelGood;
            
        % if goodmodel contains negative mu, we selected small model     
        elseif diffAICc <= AICdiff_crit & sum(y(aVol{i}.md{modelGood}.max.mu)>0) ~= modelGood
            
            % check the peak of smaller model >0 or not 
           if sum(y(aVol{i}.md{modelGood-1}.max.mu)>0) == modelGood-1
               
               volMdData(i) = modelGood-1;
               
           elseif sum(y(aVol{i}.md{modelGood-1}.max.mu)>0) ~= modelGood-1
                
               if sum(y(aVol{i}.md{modelGood-1-1}.max.mu)>0) ~= modelGood-1-1
                    volMdData(i) = 0;
               else
                   volMdData(i) = modelGood-1-1;
               end
           end
            
        
        elseif diffAICc >= AICdiff_crit
            
             if sum(y(aVol{i}.md{modelGood}.max.mu)>0) == modelGood

                volMdData(i) = modelGood;
             else

               % check the peak of smaller model >0 or not 
               if sum(y(aVol{i}.md{modelGood-1}.max.mu)>0) == modelGood-1

                   volMdData(i) = modelGood-1;

               elseif sum(y(aVol{i}.md{modelGood-1}.max.mu)>0) ~= modelGood-1

                   if sum(y(aVol{i}.md{modelGood-1-1}.max.mu)>0) ~= modelGood-1-1
                        volMdData(i) = 0;
                   else
                       volMdData(i) = modelGood-1-1;
                   end
               end

             end

            
        end
        
      elseif length(rsqIndex)==1

        % 
        modelGood = find(AICcAll == min(AICcAll(rsqIndex)));
        volMdData(i) = sum(y(aVol{i}.md{modelGood}.max.mu)>0); 
        
         
                        
            
      end
         
         
     
end


%% define amp and orientation

volMdDataSum =[];

for j = 1:length(volMdData)
    
    volMdDataSum{j}.indx = aVol{j}.Index;
    volMdDataSum{j}.md = volMdData(j);
    
    
    
    if volMdData(j) == 0
        volMdDataSum{j}.mu = NaN;
        volMdDataSum{j}.yFitPeak = NaN;
    else
        mu = aVol{j}.md{volMdData(j)}.max.mu;
        volMdDataSum{j}.mu = mu;
        volMdDataSum{j}.yFitPeak = aVol{j}.md{volMdData(j)}.max.yFit(mu);
    end    
end


if svOutput ~= 0;
      
      
      save(Savename,'volMdDataSum');
      disp('ModelSelect & Save Done')
      
end
       





