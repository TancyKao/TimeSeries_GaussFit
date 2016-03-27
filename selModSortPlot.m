% selModSortPlot.m
% 

figure;
vox_i = 54;
k = 2;

for j = 1:20
    x = 1:size(aVol{vox_i}.y,2);
    y = aVol{vox_i}.y;
    
    yFit = aVol{vox_i}.md{k}.sort{j}.yFit;

    
    r2    = aVol{vox_i}.md{k}.sort{j}.r2;
    RMSE  = aVol{vox_i}.md{k}.sort{j}.RMSE;
    SSE   = aVol{vox_i}.md{k}.sort{j}.sse;
    AICc  = aVol{vox_i}.md{k}.sort{j}.AICc;
    vPeak = aVol{vox_i}.md{k}.sort{j}.mu; 

    vP = [vPeak, vPeak, vPeak];

    
    
    
    
    
    
    line([x(vP(1)) x(vP(1))],[min(y) max(y)], 'Color',[.8 .8 .8]);
    line([x(vP(2)) x(vP(2))],[min(y) max(y)], 'Color',[.8 .8 .8]);
    line([x(vP(3)) x(vP(3))],[min(y) max(y)], 'Color',[.8 .8 .8]);

    title(sprintf('%d ; r2=%0.3f; AICc =%0.3f', j, r2, AICc));

    
    h1 = subplot(5,4,j);
    
    plot(x, y,'o-');
    hold on;

    plot(x,yFit,'r-','LineWidth',1.5)
    hold off
    
end
