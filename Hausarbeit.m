clear;
close all;
clc;

a = Tone(1, 1000, -pi/2, 1, 11025);

processingAmpVec   = [0.0,  1.0,  0.9,  0.7,  0.0];
processingTimeVec  = [0.0,  0.1,  0.3,  0.9,  1.0]; 

sweifb = WindowFunction(processingAmpVec, processingTimeVec);

sweifb.relAmpVec(2) = 0.4;

yVec = sweifb.funcGeneratePiecewiseLin(length(a.ampVector));




