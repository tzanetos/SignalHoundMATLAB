# SignalHoundMATLAB
Matlab-based post data parser for the SignalHound BB60C spectrum analyzer .bbr files.


I am developing a simple open source set of scripts for parsing the BBR files in Matlab/Octave. My script takes the path to a .bbr file and produces a struct containing the header object, maxTrace, minTrace, time, and frequency.

I also recommend checking out several of the pre-existing Github repos for SignalHound, many of which are much more advanced than mine. I am simply writing a script to parse the binary data into an easily readable form. The rest is up to you.

Usage:

result=funcParseBBR('PATH TO BBR FILE');

result = 

      header: [1x1 struct]
        freq: [nFBinsx1 double]
    minTrace: [nFBinsxnTBins double]
    maxTrace: [nFBinsxnTBins double]
        time: [nTBinsx1 double]



nFBins = Number of frequency bins

nTBins= Number of time bins
