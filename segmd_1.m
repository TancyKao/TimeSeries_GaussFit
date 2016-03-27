% segmd_1.mat
% one model fit

flag = 1; 

%p1 = y(abs(y)==max(y)); % inital guess height 

%p2 = std(y); % inital guess
%miny = min(y); % y offset

%[yval, yloc] = max(y(:));

%mu = yloc;


mu=[];
for step = 3%initalstep:(dn-initalstep)
    for initmu = 0:dn
        flag = flag +1;
        stg1 = double(initmu+1);
        stg2 = double(stg1 + step);
        
        if (stg1 + step >= dn) || (stg2 >= dn)
            break;
        end
        
        
        temp1 = find(y(1:stg2)>0);
        
        if temp1 > 0
           p1 = max(y(temp1));
           mu1 = find(y==p1);
        else 
           p1 = y(abs(y)==max(abs(y(1:stg2)))); % inital guess height 
           mu1 = find(y==p1);
        end
        p2 = std(y(1:stg2)); % inital guess
        miny = min(y(1:stg2)); % y offset
        p3 = mu1;
        
        
                
        gaumd1 = @(p, x)(p(1).* exp(-(((x-p(3)).^2)/(2*p(2)^2)))+miny);
        p = [p1 p2 p3];

        opts = statset('MaxIter',600);
        betafit = nlinfit(x,y,gaumd1,p, opts);
        % control which parameter is fixed (true is fix)
        [gaubt,r,J,cov,mse] = nlinfitsome([false false true],x,y,gaumd1,p,opts);
        
        yFit=gaumd1(gaubt,x);

        % calculate statistic and plot figures
        %StatMdPlot

        infoMd{flag}.guesspar = [p1 p2];
        infoMd{flag}.peakMu = p3;
        infoMd{flag}.stg = stg1;
        infoMd{flag}.nlin_beta = gaubt; 
        infoMd{flag}.nlin_resR = r;
        infoMd{flag}.nlin_Jacobian = J;
        infoMd{flag}.nlin_cov = cov;
        infoMd{flag}.nlin_mse = mse;
        infoMd{flag}.yFit = yFit;

 
    end
end



% save info
strMd='md1';
Vol{i}.md{1} = infoMd;

clear infoMd p

fprintf('Voxel %d for model 1 done \n', i);