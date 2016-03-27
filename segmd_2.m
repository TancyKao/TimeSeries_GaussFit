% segmd_2.mat
% 2 models fit



% p1 = y(abs(y)==max(abs(y))); % inital guess height 
% p2 = std(y); % inital guess
% p3 = y(abs(y)==max(abs(y))); % inital guess height 
% p4 = std(y); % inital guess

miny = min(y); % y offset

flag =0;
mu=[];
for step = initalstep:(dn-initalstep)
    for initmu = 0:dn
        flag = flag +1;
        stg1 = double(initmu+1);
        stg2 = double(stg1 + step);
        
        if (stg1 + step >= dn) || (stg2 >= dn)
            break;
        end
        
        
        
        temp1 = find(y(1:stg2-1)>0);
        
        
        if temp1 > 0
            p1 = max(y(temp1)); %postive value    
            mu1 = find(y==p1);
        else
            p1 = y(abs(y)==max(abs(y(1:stg2-1)))); % inital guess height
            mu1 = find(y==p1);
        end
        
        p2 = std(y(1:stg2-1)); % inital guess
        miny1 = min(y(1:stg2-1)); % y offset
        
        
        temp2 = find(y(stg2:dn)>0);
        
        if temp2 > 0
            temp2 = temp2 + stg2-1;
            p3 = max(y(temp2));
            mu2 = temp2(find(y(temp2)==p3));
        else
            p3 = y(abs(y)==max(abs(y(stg2:dn)))); % inital guess height 
            mu2 = find(y==p3);
        end
        
        p4 = std(y(stg2:dn)); % inital guess
        miny2 = min(y(stg2:dn)); % y offset
        
        
        p5 = mu1;
        p6 = mu2;   
      

        gaumd1 = @(p, x)...
                 (p(1).* exp(-(((x-p(5)).^2)/(2*p(2)^2)))+miny1)+ ...
                 (p(3).* exp(-(((x-p(6)).^2)/(2*p(4)^2)))+miny2);

        p = [p1 p2 p3 p4 p5 p6];
        

        stg = [stg1 stg2];
        opts = statset('MaxIter',600);
        
        betafit = nlinfit(x,y,gaumd1,p, opts);
        % control which parameter is fixed (true is fix)
        [gaubt,r,J,cov,mse] = nlinfitsome([false false false false true true],x,y,gaumd1,p,opts);
        
        yFit = gaumd1(gaubt,x);

        
        
        %fittedCurves{ixTimeInterval}.x = x;    
        %fittedCurves{ixTimeInterval}.y = yFit;

        
        % calculate statistic and plot figures
        %StatMdPlot
        infoMd{flag}.guesspar = [p1 p2 p3 p4];
        infoMd{flag}.peakMu = [p5 p6];
        infoMd{flag}.stg = stg;
        infoMd{flag}.nlin_beta = gaubt; 
        infoMd{flag}.nlin_resR = r;
        infoMd{flag}.nlin_Jacobian = J;
        infoMd{flag}.nlin_cov = cov;
        infoMd{flag}.nlin_mse = mse;
        infoMd{flag}.yFit = yFit;

    end
end


% save info

Vol{i}.md{2} = infoMd;

%strMd='md2';
%Vol{i}.(strMd) = infoMd;

clear infoMd p

fprintf('Voxel %d for model 2 done \n', i);