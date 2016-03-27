% segmd_4.mat
% 4 models fit

p1 = y(abs(y)==max(abs(y))); % inital guess height 
p2 = std(y); % inital guess


p3 = y(abs(y)==max(abs(y))); % inital guess height 
p4 = std(y); % inital guess

p5 = y(abs(y)==max(abs(y))); % inital guess height 
p6 = std(y); % inital guess


p7 = y(abs(y)==max(abs(y))); % inital guess height 
p8 = std(y); % inital guess



miny = min(y); % y offset

flag =0;
mu=[];
for step1 = initalstep:(dn-initalstep)
    for initmu = 0:dn
        for step2 = initalstep:(dn-initalstep)
            
            for step3 = initalstep:(dn-initalstep)
                
                flag =flag + 1;

                mu1 = double(initmu+1);
                mu2 = double(mu1 + step1);
                mu3 = double(mu2 + step2);
                mu4 = double(mu3 + step3);

                if (mu1 + step >= dn) || (mu3 >=dn) || mu4>=dn
                    break;
                end

                gaumd1 = @(p, x)...
                         (p(1).* exp(-(((x-mu1).^2)/(2*p(2)^2)))+miny) + ...
                         (p(3).* exp(-(((x-mu2).^2)/(2*p(4)^2)))+miny) + ...
                         (p(5).* exp(-(((x-mu3).^2)/(2*p(6)^2)))+miny) + ...
                         (p(7).* exp(-(((x-mu4).^2)/(2*p(8)^2)))+miny);

                p = [p1 p2 p3 p4 p5 p6 p7 p8]; 

                mu = [mu1 mu2 mu3 mu4];
                opts = statset('MaxIter',600);
                [gaubt,r,J,cov,mse] = nlinfit(x,y,gaumd1,p, opts);
                yFit = gaumd1(gaubt,x);


                fittedCurves{ixTimeInterval}.x = x;    
                fittedCurves{ixTimeInterval}.y = yFit;


                % calculate statistic and plot figures
                StatMdPlot

            end
        end
    end

    
end


% save info
strMd='md3';
Vol{i}.(strMd) = infoMd;
clear infoMd