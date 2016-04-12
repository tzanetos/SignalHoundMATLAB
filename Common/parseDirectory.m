function [ output_args ] = parseDirectory( inpPath )
%PARSEDIRECTORY Summary of this function goes here
%   Detailed explanation goes here


if(isempty(inpPath) || exists(inpPath)~=7 )
   sourcePath = uigetdir();    
else
   sourcePath = inpPath;
end

if (sourcePath(end)~=filesep)
   sourcePath = [sourcePath filesep]; 
end

% [sourceDir,sourceFileName,ext]=fileparts(sourcePath);
% 
% sourcePath=fullfile(sourceDir,[sourceFileName ext]);
% 
% fileID = fopen(sourcePath,'r');
% 


files = dir(sourcePath);
for file = files'
    if(file.isdir==0)
        ffN=fullfile(sourcePath,file.name);
        [sourceDir,sourceFileName,ext]=fileparts(ffN);
        if(strcmp(ext,'.bbr'))
            funcParseBBR(ffN)
        end
    end
end

end

