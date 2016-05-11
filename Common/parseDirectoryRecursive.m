function [ output_args ] = parseDirectoryRecursive( varargin )
%parseDirectoryRecursive Summary of this function goes here
%   Detailed explanation goes here


if(nargin == 0)
   sourcePath = uigetdir();    
   if(~isa(sourcePath,'char'))
       error('sourcePath not a char, uigetdir failed')
   end
elseif (nargin == 1)
    inpPath = varargin{1};
    if(isempty(inpPath) || exist(inpPath)~=7 )
        sourcePath = uigetdir(); 
    else
        sourcePath = inpPath;
    end
else
    error('Too many arguements, exiting. Please either provide noarg or just the path to be scanned for .bbr files')
end

if(~isa(sourcePath,'char'))
    error('sourcePath not a char')
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
    ffN=fullfile(sourcePath,file.name);
    [sourceDir,sourceFileName,ext]=fileparts(ffN);
    if(file.isdir==0)        
        if(strcmp(ext,'.bbr'))
            sprintf('Parsing %s',ffN)
            funcParseBBR(ffN);
        end
    elseif(~strcmp(file.name,'.') && ~strcmp(file.name,'..'))
        parseDirectoryRecursive(ffN);
    end
end

end

