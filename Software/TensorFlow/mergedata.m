clear all
close all
clc

inputfile1 = '18minData.mat';
inputfile2 = 'EricData1hrv3.mat';
outputfile = '36minData.mat';

load(inputfile1);
calm1 = calm;
left1 = left;
right1 = right;

load(inputfile2);
calm2 = calm;
left2 = left;
right2 = right;

if isequal(calm1,calm2)
    fprintf('ERROR: loaded same dataset twice!\n');
else
    calm = cat(1, calm1, calm2);
    left = cat(1, left1, left2);
    right = cat(1, right1, right2);
    save(outputfile, 'calm', 'left', 'right');
end
