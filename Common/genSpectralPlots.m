function [ output_args ] = genSpectralPlots( outp ,sourceDir,sourceTitle)
%GENSPECTRALPLOTS Summary of this function goes here
%   Detailed explanation goes here



%% Create the output directory
if (sourceDir(end)~=filesep)
   sourceDir = [sourceDir filesep]; 
end
outputDir = [sourceDir,sourceTitle,'_PLOTS'];
if ~exist(outputDir, 'dir')
  mkdir(outputDir);
end
if (outputDir(end)~=filesep)
   outputDir = [outputDir filesep]; 
end


frequencyMargin = 0.00;


%% Exact input frequency ranges for analysis. Make sure these ranges are not near the
%boundaries of the bbr start/stop frequencies
range.f1.actual=[100,863e6,902e6,2.55e9,5e9,5.725e9];
range.f2.actual = [2.45e9,870e6,928e6,5.95e9,5.95e9,5.875e9];
range.subtitle={'Low Band','SRD Band','ISM Band','High Band','5-6GHz','5.8GHz'};


% range.f1.actual=[3e9];
% range.f2.actual = [3.5e9];
% range.subtitle=['Test'];

range.f1.displayRange = range.f1.actual *(1-frequencyMargin);
range.f2.displayRange = range.f2.actual *(1+frequencyMargin);



%%
for i=1:length(range.f1.actual)
    start.freq = range.f1.actual(i);
    stop.freq = range.f2.actual(i);
    
    
%     if(start.freq <outp.freq(1))
%         continue
%     end
%     if(
%     
%     
%     start.index=find(outp.freq>start.freq,1);
%     stop.index=find(outp.freq>stop.freq,1);


%     if(outp.header.center_freq
    
    if(stop.freq< outp.freq(1))%The entire range is before the plot
        continue
    end
    
    if(start.freq > outp.freq(end))%The entire range is after the plot
        continue
    end
    
    
    start.index=find(outp.freq>start.freq,1);
    stop.index=find(outp.freq>stop.freq,1);
    
    if((isempty(start.index)) || (isempty(stop.index)) || (start.index==stop.index))
        continue;
    end
        
    
    
    h=figure('units','normalized','outerposition',[0 0 1 1]);
    sh=surf(outp.freq(start.index:stop.index),outp.time,outp.maxTrace(start.index:stop.index,:)','LineStyle','none');
    %set(h,'LineStyle','none');


    xlabel('Frequency (Hz)')
    ylabel('Time (s)');
    zlabel('Received Power (dBm)');
    plotText = sprintf('RBW=%d\nRef. Level=%d',outp.header.rbw,outp.header.ref_level);
    text((range.f2.displayRange(i)-range.f1.displayRange(i))*0.90+range.f1.displayRange(i),0,0,plotText,'HorizontalAlignment','right');
    title(sprintf('%s\nPlot:%s',sourceTitle,char(range.subtitle(i))));
    xlim([range.f1.displayRange(i), range.f2.displayRange(i)])
    zlim([-110 -20]);
    view(-22,40)
    colorbar;
%     drawnow; 

    saveas(h,[outputDir,char(range.subtitle(i)),'.jpg'])
    close(h)
        
end

end
