% segmd_0.mat
% segment of time


p1 = y(abs(y)==max(abs(y))); % inital guess height 
p2 = std(y); % inital guess
miny = min(y); % y offset

[yval, yloc] = max(y(:)>0);

mu =min(x)+yloc;%median(x)+rand(1)*2;
gaumd1 = @(p, x)(p(1).* exp(-(((x-mu).^2)/(2*p(2)^2)))+miny);
p = [p1 p2];

% calculate statistic and plot figures
StatMdPlot
