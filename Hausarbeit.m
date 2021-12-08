clear;
close all;
clc;

a = Tone(1, 10, -pi/2, 1, 11025);
b = Tone(0.5, 5, -pi/2, 5, 11025);
d = Tone(1, 1, -pi/2, 3, 11025);


c = a.concatTone([b, d]);
newC = c.repeat(4);


plot(newC.timeVector, newC.ampVector);




