% FaceRot3DMap.m
% Based on gasussian model fitting


clear all;
%%

cd /Users/tancy/fMRIData_RIKEN/AnalyData/Chisato_130215_01/modFit/

Filename1 = 'Chisato_critData2fit_r2_008.mat'; % 
load(Filename1)

Filename2 = 'Chisato_volMdData008_1_4s.mat'; % 
load(Filename2)



%% plot 3D images

ModelType = 'GaussAnal'; %'GaussAnal'
Coord=[];
r2=[];

RotPref=[];
Amp=[];

jitter = 0.025;

switch ModelType

    case 'CorAnal' 
        
        for  i = 1: length(critData)
            Coord = cat(2,Coord, critData{i}.coord);
            RotPref = cat(2,RotPref,critData{i}.ph);
            %r2 = cat(2,r2,critData{i}.r2);

        end

    case 'GaussAnal'

        for  i = 1: length(volMdDataSum)
            if volMdDataSum{i}.md==1
                Coord = cat(2,Coord, critData{i}.coord);
                RotPref = cat(2,RotPref,volMdDataSum{i}.mu);
                Amp = cat(2,Amp,volMdDataSum{i}.yFitPeak);
            
            % if fit model more than 2, we choice the peakest one    
%             elseif volMdDataSum{i}.md>=2
%                 Coord = cat(2,Coord, critData{i}.coord);
%                 yFitPeak = volMdDataSum{i}.yFitPeak;
%                 peakIndx = find(yFitPeak==max(yFitPeak));
%                 RotPref = cat(2,RotPref,volMdDataSum{i}.mu(peakIndx));
%                 Amp = cat(2,Amp,yFitPeak(peakIndx));
%                 
           elseif volMdDataSum{i}.md==2
                
               Coord = cat(2,Coord, critData{i}.coord);
               Coord = cat(2,Coord, critData{i}.coord+jitter); 
                
                yFitPeak = volMdDataSum{i}.yFitPeak;
                RotPref = cat(2,RotPref,volMdDataSum{i}.mu);
                Amp = cat(2,Amp,volMdDataSum{i}.yFitPeak);
                
           elseif volMdDataSum{i}.md==3
                
               Coord = cat(2,Coord, critData{i}.coord);
               Coord = cat(2,Coord, critData{i}.coord+jitter); 
               Coord = cat(2,Coord, critData{i}.coord-jitter); 
               
                yFitPeak = volMdDataSum{i}.yFitPeak;
                RotPref = cat(2,RotPref,volMdDataSum{i}.mu);
                Amp = cat(2,Amp,volMdDataSum{i}.yFitPeak);
           
                
                
            % No prefer Gaussian
            else
                
               Coord = cat(2,Coord, [NaN NaN NaN]');
               RotPref = cat(2,RotPref,NaN);
               Amp = cat(2,Amp,NaN);
            end
            
        end

end

%RotPref=RotPref./9;

for k = 1:length(Amp)
    if Amp(k) <=0
       Amp(k) = 0.01; 
    end
end

% x y z 
scatter3(Coord(1,:),Coord(2,:),Coord(3,:),Amp*100,RotPref,'filled');
%hold on;

%scatter3(Coord(1,:),Coord(2,:),Coord(3,:),'LineWidth',2);
%hold off;



colormap(jet)
colorbar






