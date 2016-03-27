

clear all;clc;
cd /Users/tancy/fMRIData_RIKEN/AnalyData/Wan_121214_01/modFit/

%Filename = 'Kenji_rOFAFitDataCrt007_Left.mat'; % 
Filename = 'wan_rOFAFitData.mat'; % 


load(Filename)

dn = 31; % data points

nparMd1 = 2; % number of parameters
nparMd2 = 4;
nparMd3 = 6;

svOutput =1;
Savename = ['Wan_rOFAFitDataCrt007_Left'];
%Savename = ['Chisato_demoStat2'];


nVol = length(Vol); % number of voxel
nMd  = 3; % number of model fit

for i = 1 : nVol
    
  aVol{i}.Index = Vol{i}.Index;
  aVol{i}.y = Vol{i}.y;
  aVol{i}.dy = Vol{i}.dy;

    
   for j = 1: nMd
       
       % remove empty []
       temp = Vol{i}.md{j};
       volMdtemp = temp(~cellfun('isempty', temp));
       
       volMdsort =[]; muInd =[];
       for k = 1 : length(volMdtemp)
            
            y = Vol{i}.y;  
            yFit = volMdtemp{k}.yFit;

             sst = sum(abs(yFit-mean(y)).^2);
             sse = sum(abs(yFit-y).^2);
             RMSE = sqrt(sse/dn);
             rsq= 1-(sse/sst);
             
             [rPearson p] = corrcoef(yFit,y);
             corRsq = rPearson(2).^2;

           
            % check AIC
            npar = length(volMdtemp{k}.guesspar); % number of parameters
            AIC = dn * (log(sse/dn)) + 2*npar; % 
            AICc = AIC + ((2*npar*(npar+1))/(dn-npar-1)); % for small size data points 
            
            
            volMdtemp{k}.sse = sse;
            volMdtemp{k}.RMSE = RMSE;
            volMdtemp{k}.r2 = rsq;
            volMdtemp{k}.corR2 = corRsq;
            volMdtemp{k}.AICc = AICc;
                       
            peakMu = volMdtemp{k}.peakMu;
            peakMu = [peakMu, peakMu, peakMu];

            % select positive y(mu)
            if y(peakMu(1)) > 0 && y(peakMu(2)) > 0 && y(peakMu(3)) > 0
                
                muInd(k) = 1;
                
            else
                
                muInd(k) = 0;
                
            end
            
            
            volMdsort = cat(1, volMdsort, rsq);
            
       end
             muInd = muInd';
             volMdsort = [volMdsort muInd];
        
             % sort muInd as ascending and then sort volMdsort as ascending
             [r2 sortIndex] = sortrows(volMdsort,[-2, -1]);
             
             [minR2 minIndex] = min(volMdsort);
             %[maxR2 maxIndex] = max(volMdsort);
                          
             aVol{i}.md{j}.sort = volMdtemp(sortIndex);
             aVol{i}.md{j}.min = volMdtemp{minIndex};
             aVol{i}.md{j}.max = volMdtemp{sortIndex(1)};
             
             
             % Chi-square test for max model
             yFit = aVol{i}.md{j}.max.yFit;
             chi2stat = sum((y-yFit).^2./yFit);
             p = 1-chi2cdf(chi2stat,1);
             aVol{i}.md{j}.max.chi2stat = chi2stat;
             aVol{i}.md{j}.max.chi2p = p;
          
             
   end

   
   
        % AICc comparsion
        diffmd_32 = abs(aVol{i}.md{3}.max.AICc) - abs(aVol{i}.md{2}.max.AICc);
        diffmd_31 = abs(aVol{i}.md{3}.max.AICc) - abs(aVol{i}.md{1}.max.AICc);
        diffmd_21 = abs(aVol{i}.md{2}.max.AICc) - abs(aVol{i}.md{1}.max.AICc);
        
        % Akaike's weight
        Prob_32 = exp(-0.5*diffmd_32)/(1+exp(-0.5*diffmd_32)); % probability
        Prob_31 = exp(-0.5*diffmd_31)/(1+exp(-0.5*diffmd_31)); % probability
        Prob_21 = exp(-0.5*diffmd_21)/(1+exp(-0.5*diffmd_21)); % probability
        
        % evidence ratio
        evRatio_32 = (Prob_32)/(1-Prob_32);
        evRatio_31 = (Prob_31)/(1-Prob_31);
        evRatio_21 = (Prob_21)/(1-Prob_21);
        
        aVol{i}.Prob = [Prob_32 Prob_31 Prob_21];
        aVol{i}.evRatio = [evRatio_32 evRatio_31 evRatio_21];
   
     
   
         % F test
       
%         df3 = dn-nparMd3;
%         df2 = dn-nparMd2;
%         df1 = dn-nparMd1;
%         Ftest_32 = ((aVol{i}.md{3}.sse - aVol{i}.md{1}.sse)/(df3-df2))/...
%                    (aVol{i}.md{1}.sse/df2);  
%     
%         Ftest_31 = ((aVol{i}.md{3}.sse - aVol{i}.md{1}.sse)/(df3-df1))/...
%                    (aVol{i}.md{1}.sse/df1);
%                
%         Ftest_21 = ((aVol{i}.md{2}.sse - aVol{i}.md{1}.sse)/(df2-df1))/...
%                    (aVol{i}.md{1}.sse/df1);
%                
%                
%         p_md32 = 1-fcdf(Ftest_32, df3, df2);
%          
%         p_md31 = 1-fcdf(Ftest_31, df3, df1);
%          
%         p_md21 = 1-fcdf(Ftest_21, df2, df1);
%      
%         aVol{i}.Ftest = [Ftest_32 Ftest_31 Ftest_21];
%         aVol{i}.pValue = [p_md32 p_md31 p_md21];
%         
        
        
        
end


if svOutput ~= 0;
      
      
      save(Savename,'aVol');
      disp('Fitting & Save Done')
      
end
       
   


