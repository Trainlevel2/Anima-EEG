clear all
close all
clc

inputfile1 = 'EricData1hrv1.mat';
inputfile2 = 'EricData1hrv2.mat';
outputfile = 'EricData2hr.mat';

load(inputfile1);
inputs = cat(1, calm, left, right)';
calmtarget = repmat([0,1,0],size(calm,1), 1);
lefttarget = repmat([1,0,0],size(left,1), 1);
righttarget = repmat([0,0,1],size(right,1), 1);
targets = cat(1, calmtarget, lefttarget, righttarget)';

x1 = inputs;
t1 = targets;

load(inputfile2);
inputs = cat(1, calm, left, right)';
calmtarget = repmat([0,1,0],size(calm,1), 1);
lefttarget = repmat([1,0,0],size(left,1), 1);
righttarget = repmat([0,0,1],size(right,1), 1);
targets = cat(1, calmtarget, lefttarget, righttarget)';

x2 = inputs;
t2 = targets;

if isequal(x1,x2)
    fprintf('ERROR: loaded same dataset twice!\n');
else
    x = cat(2,x1,x2);
    t = cat(2,t1,t2);
    save(outputfile, 'x', 't');
end
