clear;
close all;
clc;

a = Tone([1, 1], [2, 1], [-pi/2, -pi/2], 1, 11025);
b = Tone([1, 1], [3, 1], [-pi/2, -pi/2], 1, 11025);


a.interferSounds(b);
