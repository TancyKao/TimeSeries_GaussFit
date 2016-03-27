%%
%%

timeIntervals = [1 31];%[1 5; 4 11; 10 20;19 26; 25 31];
fittedCurves = cell(1);


for ixTimeInterval=1:size(timeIntervals,1)
    disp(ixTimeInterval);
    data=sptseries(5,:); % select voxel
    y = data(timeIntervals(ixTimeInterval, 1):timeIntervals(ixTimeInterval, 2)); %truncate data point
    %y = y';
    x = timeIntervals(ixTimeInterval, 1):timeIntervals(ixTimeInterval, 1) + length(y)-1;

    [sigma, mu]=gaussfit_tancy(x,y);
    
    yFitted=(1/(sqrt(2*pi)* sigma ) * exp( - (x-mu).^2 / (2*sigma^2)));
 
    fittedCurves{ixTimeInterval}.x = x;    
    fittedCurves{ixTimeInterval}.y = yFitted;
  
end
%%
 figure;
 x = 1:length(data);
 plot(x, data,'o-');
 hold on; 
 for ixTimeInterval=1:size(timeIntervals,1)
     
     xFitted = fittedCurves{ixTimeInterval}.x;
     yFitted = fittedCurves{ixTimeInterval}.y;
     plot(xFitted,yFitted,'r-','LineWidth',1.5)
 end

 

%model = ampval * sin(2*pi*ncycles/nframes * [0:nframes-1]' - phval);


