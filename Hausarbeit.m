clear;
close all;
clc;

a = Tone(1, 1000, -pi/2, 1, 11025);
b = Tone(2, 1, -pi/2, 5, 8000);

b = a.repeat(5);

plot(b.timeVector, b.ampVector);



