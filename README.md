# SignalHoundMATLAB
Matlab-based post data parser for the SignalHound BB60C spectrum analyzer .bbr files.

TODO:
-Add general min/max auto plotting plot scripts


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
 
  
   


The MIT License (MIT)
Copyright (c) 2016 Theodore Tzanetos

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
