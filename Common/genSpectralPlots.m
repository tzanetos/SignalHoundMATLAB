function [ output_args ] = genSpectralPlots( outp ,sourceDir)
%GENSPECTRALPLOTS Summary of this function goes here
%   Detailed explanation goes here


frequencyMargin = 0.10;


%% Exact input frequency ranges for analysis
range.f1.actual=[1,863e6,902e6,2.5e9,5e9,5.725e9];
range.f2.actual = [2.5e9,870e6,928e6,6e9,6e9,5.875];

range.f1.displayRange = range.f1.actual *(1-frequencyMargin);
range.f2.displayRange = range.f2.actual *(1+frequencyMargin);



%%
for i=1:length(range.f1.actual)
    fStart = range.f1.actual(i);
    fStop = range.f2.actual(i);
    
    find(outp.freq>fStart,1)
    
end


figure
h=surf(outp.freq,outp.time,outp.maxTrace');
set(h,'LineStyle','none');
% plot(outp.freq,outp.maxTrace(:,1))


end
