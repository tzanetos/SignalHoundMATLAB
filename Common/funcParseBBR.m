%{
Theodore Tzanetos
https://github.com/tzanetos


Usage

result=funcParseBBR('<PATH to.bbr>');

A .mat file will be saved in the source directory which contains the output
struct containing the parsed data. This .mat file will be named similar to
the source file with the addition of the _DATA.mat suffix added to it.





The MIT License (MIT)
Copyright (c) <2016> <Theodore Tzanetos>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and 
associated documentation files (the "Software"), to deal in the Software without restriction, including 
without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the 
following conditions:

The above copyright notice and this permission notice shall be included in all copies 
or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE 
FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, 
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


%}




function [outp]=funcParseBBR( inpPath )
%clearvars -except inpPath
%close all


%% Filepath partsing
[sourceDir,sourceFileName,ext]=fileparts(inpPath);

sourcePath=fullfile(sourceDir,[sourceFileName ext]);

fileID = fopen(sourcePath,'r');


%% Header Reference 
%{ 

Signal Hound BBR Format
https://github.com/SignalHound/BBApp/blob/master/BBApp/src/model/playback_toolbar.cpp
https://github.com/SignalHound/BBApp/blob/master/BBApp/src/model/playback_toolbar.h


struct playback_header {
    unsigned short signature;                           2 bytes
    unsigned short version;

    int sweep_count;

    ushort title[MAX_TITLE_LEN + 1];            //const int MAX_TITLE_LEN = 127;
    double center_freq; // Sweep settings
    double span;
    double rbw;
    double vbw;
    double ref_level;
    double div;
    int atten;
    int gain;
    int detector;

    int trace_len;
    double trace_start_freq;
    double bin_size;
};
%}

headerSize=344; %Sum of all the bytes in the above C struct

%% Header Parsing
A = fread(fileID,headerSize,'uint8=>uint8');

header.signature = helper_readParseCast(A,2,'uint16',true);
header.version = helper_readParseCast(A,2,'uint16');
header.sweep_count = helper_readParseCast(A,4,'int32');
header.title = helper_readParseCast(A,128*2,'uint16');

header.center_freq = helper_readParseCast(A,8,'double');
header.span = helper_readParseCast(A,8,'double');
header.rbw = helper_readParseCast(A,8,'double');
header.vbw = helper_readParseCast(A,8,'double');
header.ref_level = helper_readParseCast(A,8,'double');
header.div = helper_readParseCast(A,8,'double');
header.atten = helper_readParseCast(A,4,'int32');
header.gain = helper_readParseCast(A,4,'int32');
header.detector = helper_readParseCast(A,4,'int32');

header.trace_len = helper_readParseCast(A,4,'int32');
header.trace_start_freq = helper_readParseCast(A,8,'double');
header.bin_size = helper_readParseCast(A,8,'double');

% disp(header);

%% Data/Body parsing
%8 bytes are the 64 bit integer, (standard ms from epoch time, when the sweep was captured)
%header.trace_len * 4 bytes(1 float) representing the min trace
%header.trace_len * 4 bytes(1 float) representing the max trace

capLen=8+header.trace_len*4*2;
i = 1;
time = zeros(header.sweep_count,1);
minTrace = zeros(header.trace_len,header.sweep_count);
maxTrace = zeros(header.trace_len,header.sweep_count);


[B,count] = fread(fileID,capLen,'uint8=>uint8');
while(count == capLen)
%     disp(sprintf('Parsing sweep %d of %d', i,header.sweep_count));
%     completion=round(100*i/double(header.sweep_count));
%     fprintf('%d%% Complete\n',completion);
    time(i) = helper_readParseCast(B,8,'uint64',true)/1000;
    minTrace(:,i) = helper_readParseCast(B,header.trace_len*4,'single');
    maxTrace(:,i) = helper_readParseCast(B,header.trace_len*4,'single');
    
    i=i+1;
    [B,count] = fread(fileID,capLen,'uint8=>uint8'); 
    
end
time=time-time(1);
i=i-1;
fclose(fileID);


%% Output Struct
outp.header=header;
outp.freq = [header.trace_start_freq:header.bin_size:header.trace_start_freq+header.span-header.bin_size]';
outp.minTrace = minTrace;
outp.maxTrace = maxTrace;
outp.time = time;


%% OFF BY ONE HACK IN FREQ LENGTH
freqTraceLenDiff = length(outp.maxTrace)-length(outp.freq);
if(freqTraceLenDiff==0)
%     disp('No Length Mismatch')
elseif(freqTraceLenDiff == 1);
    disp('maxTrace longer that freq by 1');
    tailEnd = outp.freq(end);
    outp.freq =[outp.freq;tailEnd+header.bin_size];
elseif(freqTraceLenDiff == -1)
    disp('freq longer than maxTrace by 1');
    tailLen = length(outp.freq);
    outp.freq =outp.freq(1:tailLen-1);
else
    error(sprintf('freqTraceLenDiff = %d',freqTraceLenDiff));
end

%% Saving

disp('Saving in source path...')
save(fullfile(sourceDir,strcat(sourceFileName,'_DATA')),'outp','-v7.3');
disp('Saving Done!')


%% Generate Plots
genSpectralPlots(outp,sourceDir);

%% 
%disp(outp)

end

