function [gaubt,r,J,cov,mse, yFit, p, mu] = segGaussFit(x, y,numMd, initalstep)


dn = length(x);

    switch numMd

                case 0 % segment for each fitting
                    p1 = y(abs(y)==max(abs(y))); % inital guess height 
                    p2 = std(y); % inital guess
                    miny = min(y); % y offset

                    [yval, yloc] = max(y(:)>0);

                    mu =min(x)+yloc;%median(x)+rand(1)*2;
                    gaumd1 = @(p, x)(p(1).* exp(-(((x-mu).^2)/(2*p(2)^2)))+miny);
                    p = [p1 p2];


                case 1 % one model

                    p1 = y(abs(y)==max(abs(y))); % inital guess height 
                    p2 = std(y); % inital guess
                    miny = min(y); % y offset

                    [yval, yloc] = max(y(:));

                    mu =min(x)+yloc;
                    gaumd1 = @(p, x)(p(1).* exp(-(((x-mu).^2)/(2*p(2)^2)))+miny);
                    p = [p1 p2];

                case 2

                    p1 = y(abs(y)==max(abs(y))); % inital guess height 
                    p2 = std(y); % inital guess
                    p3 = y(abs(y)==max(abs(y))); % inital guess height 
                    p4 = std(y); % inital guess

                    miny = min(y); % y offset


                    for step = initalstep:(dn-initalstep)
                        for initmu = 0:dn
                            mu1 = initmu+1;
                            mu2 = mu1 + step;

                            if (mu1 + step >= dn) || (mu2 >= dn)
                                break;
                            end

                            gaumd1 = @(p, x)...
                                     (p(1).* exp(-(((x-mu1).^2)/(2*p(2)^2)))+miny)+ ...
                                     (p(3).* exp(-(((x-mu2).^2)/(2*p(4)^2)))+miny);

                            p = [p1 p2 p3 p4];

                            mu = [mu1 mu2];
                        end
                    end


                case 3

                    p1 = y(abs(y)==max(abs(y))); % inital guess height 
                    p2 = std(y); % inital guess


                    p3 = y(abs(y)==max(abs(y))); % inital guess height 
                    p4 = std(y); % inital guess

                    p5 = y(abs(y)==max(abs(y))); % inital guess height 
                    p6 = std(y); % inital guess

                    miny = min(y); % y offset


                    for step1 = initalstep:(dn-initalstep)
                        for initmu = 0:dn
                            for step2 = initalstep:(dn-initalstep)

                                mu1 = initmu+1;
                                mu2 = mu1 + step1;
                                mu3 = mu2 + step2;

                                if (mu1 + step >= dn) || (mu3 >=dn)
                                    break;
                                end

                                gaumd1 = @(p, x)...
                                         (p(1).* exp(-(((x-mu1).^2)/(2*p(2)^2)))+miny) + ...
                                         (p(3).* exp(-(((x-mu2).^2)/(2*p(4)^2)))+miny) + ...
                                         (p(5).* exp(-(((x-mu3).^2)/(2*p(6)^2)))+miny);

                                p = [p1 p2 p3 p4 p5 p6];    

                        end
                    end
               end

    end


    
     opts = statset('MaxIter',600);
     [gaubt,r,J,cov,mse] = nlinfit(x,y,gaumd1,p, opts);
     yFit=gaumd1(gaubt,x);
     
end


 




% switch numMd
% 
%                         case 0 % segment for each fitting
%                             p1 = y(abs(y)==max(abs(y))); % inital guess height 
%                             p2 = std(y); % inital guess
%                             miny = min(y); % y offset
%                             
%                             [yval, yloc] = max(y(:)>0);
% 
%                             mu =min(x)+yloc;%median(x)+rand(1)*2;
%                             gaumd1 = @(p, x)(p(1).* exp(-(((x-mu).^2)/(2*p(2)^2)))+miny);
%                             p = [p1 p2];
% 
% 
%                         case 1 % one model
%                             p1 = y(abs(y)==max(abs(y))); % inital guess height 
%                             p2 = std(y); % inital guess
%                             miny = min(y); % y offset
%                             
%                             [yval, yloc] = max(y(:));
% 
%                             mu =min(x)+yloc;
%                             gaumd1 = @(p, x)(p(1).* exp(-(((x-mu).^2)/(2*p(2)^2)))+miny);
%                             p = [p1 p2];
% 
% 
%                         case 2  % two model
%                             p1 = y(abs(y)==max(abs(y))); % inital guess height 
%                             p2 = randi([1 31]);%min(x)+rand(1)*length(x);
%                             p3 = std(y); % inital guess
% 
%                             miny = min(y); % y offset
%                             [yval, yloc] = max(y(:));
%                             mu =min(x)+yloc;
% 
%                             p4 = y(abs(y)==max(abs(y))); % inital guess height 
%                             p5 = min(x)+rand(1)*length(x);
%                             p6 = std(y); % inital guess
% 
% 
%                             gaumd1 = @(p, x)...
%                                      (p(1).* exp(-(((x-p(2)).^2)/(2*p(3)^2)))+miny)+ ...
%                                      (p(4).* exp(-(((x-p(5)).^2)/(2*p(6)^2)))+miny);
% 
%                             p = [p1 p2 p3 p4 p5 p6];
% 
%                          case 3  % three model
% 
%                             p1 = y(abs(y)==max(abs(y))); % inital guess height 
%                             p2 = min(x)+rand(1)*length(x);
%                             p3 = std(y); % inital guess
%                             miny = min(y); % y offset
%                             
%                             [yval, yloc] = max(y(:));
%                             mu =min(x)+yloc;
%                                                        
%                             
%                             
%                             p4 = y(abs(y)==max(abs(y))); % inital guess height 
%                             p5 = min(x)+rand(1)*length(x);
%                             p6 = std(y); % inital guess
% 
%                             p7 = y(abs(y)==max(abs(y))); % inital guess height 
%                             p8 = min(x)+rand(1)*length(x);
%                             p9 = std(y); % inital guess
% 
% 
%                             gaumd1 = @(p, x)...
%                                      (p(1).* exp(-(((x-p(2)).^2)/(2*p(3)^2)))+miny) + ...
%                                      (p(4).* exp(-(((x-p(5)).^2)/(2*p(6)^2)))+miny) + ...
%                                      (p(7).* exp(-(((x-p(8)).^2)/(2*p(9)^2)))+miny);
% 
%                             p = [p1 p2 p3 p4 p5 p6 p7 p8 p9];
% 
%                     end % switch






    
    
    



% function [beta, yFit] = segGaussFit(p, x, y)
% 
% %     p(1) = height of Gaussian
% %     p(2) = center
% %     p(3) = SD
% %     p(4) = offset
% %
% 
% 
%     miny = min(y);
%     strMiny = num2str(miny);
%         
%     mystr = strcat('(p(1) * exp(-(((x-p(2)).^2)/(2*p(3)^2)))) + ', strMiny);
%     
%        
%     myf = inline(mystr, 'p', 'x');
%     opts = statset('MaxIter',600);
% 
%     fitpar = [p(1) p(2) p(3)];
% 
%       beta = nlinfit(x, y, myf, fitpar, opts );
%     %p=nlinfit(x, y, myf, [y(abs(y)==max(abs(y))) mean(x) + mean(y) std(y) min(y)], opts);
% 
%     yFit=myf(beta,x);
%     
%   
%         
% end
%         
