%{
Theodore Tzanetos
https://github.com/tzanetos


Usage

outp = helper_readParseCast(A, numBytes, castTo, resetByteIndex)

-A:Array of bytes from which to read
-numBytes: Number of bytes to read. Reading will start at byteIndex, which 
will keep track of the relative offset for reading. Initialized to 1. Note
that byteIndex is a property of this helper funtion and not of each
individual array that this helper function is called on. When switching
source arrays, you should reset the byte index/offset by passing true as
the 4th argument.
-castTo: Datatype that numBytes-bytes should be casted to
-resetByteIndex: Resets the relative reading offset to 1. Optional boolean
argument. Leave exempt or false to continue natural offseting, or pass in
true to reset to 1.



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


function [ outp ] = helper_readParseCast( A, numBytes, castTo, resetByteIndex)
    persistent byteIndex;   %Persistent in order to simplify consecutive calls to this function
    
    
    if(isempty(byteIndex) || (exist('resetByteIndex','var') && resetByteIndex==true))
        byteIndex=1;
    end    
    stopRead = byteIndex+numBytes-1;    
    outp=typecast(A(byteIndex:stopRead),castTo);    
    byteIndex=byteIndex+numBytes;
end