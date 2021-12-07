clear;
close all;
clc;

a = Tone(1, 1, -pi/2, 1, 11025);
b = Tone(2, 1, -pi/2, 5, 8000);


[timeVec, ampVec] = a.concatTone(b);

plot(timeVec, ampVec);



