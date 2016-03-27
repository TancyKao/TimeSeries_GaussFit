%StatMdPlot.m


% confidence interval 95% 
% ci = nlparci(gaubt,r,'covar',cov);

% % check for r2
% sst = sum(abs(yFit-mean(y)).^2);
% sse = sum(abs(yFit-y).^2);
% RMSE = sqrt(sse/dn);
% rsq = 1-(sse/sst);
% 
% fprintf('sse %0.3f; sst % 0.3f; rsq %0.3f \n', sse, sst, rsq);
% 
% % C = corrcoef(y, yFit);
% % rsq1 = C(1,2)^2;
% % rsq2 = 1-(sum(r.^2)/sst);
% 
% 
% 
% % check AIC
% npar = length(p); % number of parameters
% AIC = dn * (log(sse/dn)) + 2*npar; % 
% AICc = AIC + ((2*npar*(npar+1))/(dn-npar-1)); % for small size data points 



infoMd{flag}.guesspar = p;
infoMd{flag}.mu = mu;
infoMd{flag}.nlin_beta = gaubt; 
infoMd{flag}.nlin_resR = r;
infoMd{flag}.nlin_Jacobian = J;
infoMd{flag}.nlin_cov = cov;
infoMd{flag}.nlin_mse = mse;
infoMd{flag}.yFit = yFit;
% infoMd{flag}.sse = sse;
% infoMd{flag}.RMSE = RMSE;
% infoMd{flag}.r2 = rsq;
% infoMd{flag}.AICc = AICc;
% 
%         


% plot fitting figures
if drwFig ~= 0

     figure;

     x = 1:size(data2fit,2);
     errorbar(x, data2fit, dy, 'o-');
     hold on;
     for ixTimeInterval=1:size(timeIntervals,1)
         xFitted = fittedCurves{ixTimeInterval}.x;
         yFitted = fittedCurves{ixTimeInterval}.y;
         plot(xFitted,yFitted,'r-','LineWidth',1.5)

     end
     hold off


     title(sprintf('r2=%0.3f; AICc =%0.3f', f.r, AICc)); % subtitle

end