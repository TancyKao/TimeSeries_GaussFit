% segmd_3.mat
% 3 models fit

% p1 = y(abs(y)==max(abs(y))); % inital guess height 
% p2 = std(y); % inital guess
% 
% 
% p3 = y(abs(y)==max(abs(y))); % inital guess height 
% p4 = std(y); % inital guess
% 
% p5 = y(abs(y)==max(abs(y))); % inital guess height 
% p6 = std(y); % inital guess

miny = min(y); % y offset

flag =0;
stg=[];
for step1 = initalstep:(dn-initalstep)
    for initmu = 0:dn
        for step2 = initalstep:(dn-initalstep)
            flag =flag + 1;
            
            stg1 = double(initmu+1);
            stg2 = double(stg1 + step1);
            stg3 = double(stg2 + step2);

            if (stg1 + step >= dn) || (stg3 >=dn)
                break;
            end
            
            
            
            
            temp1 = find(y(1:stg2-1)>0);
            
            if temp1 > 0
                p1 = max(y(temp1));
                mu1 = find(y==p1);
            else
                p1 = y(abs(y)==max(abs(y(1:stg2-1)))); % inital guess height 
                mu1 = find(y == p1);
            end
                
                p2 = std(y(1:stg2-1)); % inital guess
                miny1 = min(y(1:stg2-1)); % y offset


            temp2 = find(y(stg2:stg3-1)>0);
            
            if temp2 > 0
                temp2 = temp2 + stg2-1;
                p3 = max(y(temp2));
                mu2 = temp2(find(y(temp2)==p3));
            else
                p3 = y(abs(y)==max(abs(y(stg2:stg3-1)))); % inital guess height 
                mu2 = find(y == p3);
            end
                p4 = std(y(stg2:stg3-1)); % inital guess
                miny2 = min(y(stg2:stg3-1)); % y offset
            
            
            temp3 = find(y(stg3:dn)>0);
            
            if temp3 > 0
                
                temp3 = temp3 + stg3-1;
                p5 = max(y(temp3));
                mu3 = temp3(find(y(temp3)==p5));
            else
                p5 = y(abs(y)==max(abs(y(stg3:dn)))); % inital guess height 
                mu3 = find (y==p5);
            end
            
            
            p6 = std(y(stg3:dn)); % inital guess
            miny3 = min(y(stg3:dn)); % y offse
            
            
            p7 = mu1;
            p8 = mu2;  
            p9 = mu3;
      
            
%             p1 = y(abs(y)==max(abs(y(1:stg2-1)))); % inital guess height 
%             p2 = std(y(1:stg2-1)); % inital guess
%             miny1 = min(y(1:stg2-1)); % y offset
%         
% 
%             p3 = y(abs(y)==max(abs(y(stg2:stg3-1)))); % inital guess height 
%             p4 = std(y(stg2:stg3-1)); % inital guess
%             miny2 = min(y(stg2:stg3-1)); % y offset
%         
%             
%             p5 = y(abs(y)==max(abs(y(stg3:dn)))); % inital guess height 
%             p6 = std(y(stg3:dn)); % inital guess
%             miny3 = min(y(stg3:dn)); % y offset
%         
            


            gaumd1 = @(p, x)...
                     (p(1).* exp(-(((x-p(7)).^2)/(2*p(2)^2)))+miny1) + ...
                     (p(3).* exp(-(((x-p(8)).^2)/(2*p(4)^2)))+miny2) + ...
                     (p(5).* exp(-(((x-p(9)).^2)/(2*p(6)^2)))+miny3);

            p = [p1 p2 p3 p4 p5 p6 p7 p8 p9]; 
            
            stg = [stg1 stg2 stg3];
            opts = statset('MaxIter',600);
            betafit = nlinfit(x,y,gaumd1,p, opts);
            % control which parameter is fixed (true is fix)
            [gaubt,r,J,cov,mse] = nlinfitsome([false false false false false false true true true],x,y,gaumd1,p,opts);
        
            yFit = gaumd1(gaubt,x);


            %fittedCurves{ixTimeInterval}.x = x;    
            %fittedCurves{ixTimeInterval}.y = yFit;


            % calculate statistic and plot figures
            % StatMdPlot
            infoMd{flag}.guesspar = [p1 p2 p3 p4 p5 p6];
            infoMd{flag}.peakMu = [p7 p8 p9];
            infoMd{flag}.stg = stg;
            infoMd{flag}.nlin_beta = gaubt; 
            infoMd{flag}.nlin_resR = r;
            infoMd{flag}.nlin_Jacobian = J;
            infoMd{flag}.nlin_cov = cov;
            infoMd{flag}.nlin_mse = mse;
            infoMd{flag}.yFit = yFit;

        end
    end

    
end


% save info
Vol{i}.md{3} = infoMd;

%strMd='md3';
%Vol{i}.(strMd) = infoMd;
clear infoMd p

fprintf('Voxel %d for model 3 done \n', i);