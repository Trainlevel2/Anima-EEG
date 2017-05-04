clear all
close all
clc

load('NNResults100x100.mat');

surf(avrGood)
title('2 Hidden Layer Neural Network Nodes vs. Classification Overall Performance');
xlabel('1st layer nodes');
ylabel('2nd layer nodes');
zlabel('classification performance');

avrGood1 = mean(avrGood, 1);
avrGood2 = mean(avrGood, 2);

figure
plot(avrGood1);
title('2 Hidden Layer Neural Network, 1st layer average performance');
xlabel('1st layer nodes');
ylabel('classification average overall performance');

figure
plot(avrGood2);
title('2 Hidden Layer Neural Network, 2nd layer average performance');
xlabel('2nd layer nodes');
ylabel('classification average overall performance');