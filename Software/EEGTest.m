clear all
close all
clc

% initialize the java engine
import java.awt.*;
import java.awt.event.*;
% initialize robot for mouse pointing
rob=Robot;
mx=960;
my=540;
timeBetweenMessages = 1;

%%% Start of program

fprintf('Welcome to the Anima test program\n');
pause(timeBetweenMessages);
% fprintf('Please take 30 seconds to relax and allow your brain waves to stabilize\n');
% pause(timeBetweenMessages);
% fprintf('Begin relaxation\n');
% pause(timeBetweenMessages);
% for i = 1:30
%     fprintf('%d\n', 30-i);
%     % pause(1);
% end

fprintf('End relaxation...\n');
pause(timeBetweenMessages);

fprintf('Begin testing\n');
pause (timeBetweenMessages);

endTime = 3600;

% test (removed from function)
fprintf('Begin\n');
pause(timeBetweenMessages);

%%% Configuration Data
serialPort = 'COM3';            % define COM port #
baudRate = 115200;
lsensitivity = 6;
rsensitivity = 4;

priorPorts = instrfind; % finds any existing Serial Ports in MATLAB
delete(priorPorts); % and deletes them
% User Defined Properties
s = serial(serialPort,'BaudRate', baudRate);
s.InputBufferSize = 20000;
fopen(s);

%figure
AlphaRatio1 = zeros(1,endTime);
AlphaRatio2 = zeros(1,endTime);
AlphaMinArr1 = zeros(1,endTime);
AlphaMinArr2 = zeros(1,endTime);

for i = 1:endTime
    sampleArray = fscanf(s, '%c');

    br1 = find(sampleArray=='{',1,'first') + 1;
    br2 = find(sampleArray=='}',1,'first') - 1;

    totalArray = str2num(sampleArray(br1:br2));

    %signals from eeg
    signal1 = totalArray(1:3:end);
    signal2 = totalArray(2:3:end);
    signal3 = totalArray(3:3:end);

    fs = length(signal1);

    signal11 = signal1;
    signal22 = signal2;

    signal1 = signal1 - signal3;
    signal2 = signal2 - signal3;

    % Filters
    wo = 60/(fs/2);  bw = wo/35;
    [b1,a1] = iirnotch(wo,bw);              %Notch filter

    wo = 15/(fs/2);  bw = wo/35;
    [b1,a1] = iirpeak(wo,bw);               %Peak filter

    signal1 = filter(b1,a1,signal1);
    [b1,a1] = butter(4,50/(fs/2));          %Low pass filter

    % FFT
    trans1 = fft(signal1);
    l1 = length(trans1);
    P21 = abs(trans1/l1);
    P11 = P21(1:floor(l1/2+1));
    P11(2:end-1) = 4*P11(2:end-1);

    trans2 = fft(signal2);
    l2 = length(trans2);
    P22 = abs(trans2/l2);
    P12 = P22(1:floor(l2/2+1));
    P12(2:end-1) = 4*P12(2:end-1);

    f = (fs)*(0:(l1/2))/l1;
    x = 0:(1000/fs):1000;
    x = x(1:(end-1));

    % Alpha values
    AlphaRatio1 = circshift(AlphaRatio1,-1);
    AlphaRatio2 = circshift(AlphaRatio2,-1);

    AlphaMinArr1 = circshift(AlphaMinArr1,-1);
    AlphaMinArr2 = circshift(AlphaMinArr2,-1);

    AlphaAvr1 = sum(P11(9:14))/6;               % average over alpha range over one time step
    AlphaMin1 = min(P11(9:14));                 % minimum over alpha range over one time step
    AlphaAvr2 = sum(P12(9:14))/6;
    AlphaMin2 = min(P12(9:14));

    AlphaRatio1(end) = AlphaAvr1/AlphaMin1;    % ratio
    AlphaMinArr1(end) = AlphaMin1;
    AlphaRatio2(end) = AlphaAvr2/AlphaMin2;
    AlphaMinArr2(end) = AlphaRatio1/AlphaRatio2;

    moveLeft = (AlphaAvr1/AlphaMin1 > lsensitivity);
    moveRight = (AlphaAvr2/AlphaMin2 > rsensitivity);

    ymaxaxis = 15;

    % Plotting
    subplot(2,1,1)
    plot(AlphaRatio1);
    hold on
    plot(ones(1,endTime)*lsensitivity);
    plot(ones(1,endTime)*5);
    plot(ones(1,endTime)*10);
    title('Left Mu Values (Average/Minimum Ratio)')
    xlabel('Time (s)') % x-axis label
    ylabel('Ratio') % y-axis label
    hold off
    axis([0 inf 0 ymaxaxis])
    subplot(2,1,2)
    plot(AlphaRatio2);
    hold on
    plot(ones(1,endTime)*rsensitivity);
    plot(ones(1,endTime)*5);
    plot(ones(1,endTime)*10);
    hold off
    title('Right Mu Values (Average/Minimum Ratio)')
    xlabel('Time (s)') % x-axis label
    ylabel('Ratio') % y-axis label
    txt = {strcat('right: ' , num2str(moveRight)), strcat('left: ' , num2str(moveLeft))};
    text(length(AlphaMinArr2),ymaxaxis * .8, txt, 'HorizontalAlignment', 'right');
    axis([0 inf 0 ymaxaxis])

    drawnow

    nnInput = [AlphaRatio1(end), AlphaRatio2(end), AlphaAvr1, AlphaAvr2, AlphaMin1, AlphaMin2, P11(1), P11(5:50), P12(1), P12(5:50)];
    nnInput = nnInput';
    nnOutput = nnFunction0504(nnInput);
    nnOutput(1) = nnOutput(1);
    nnOutput(2) = nnOutput(2);
    nnOutput(3) = nnOutput(3) + .049;
    nnOutput

    nnOutputMax = max(nnOutput);
    if(nnOutputMax == nnOutput(1))     %move left
        [mx,my] = movemouse(rob,mx,my,-3,-0,1);     %Move left
    elseif(nnOutputMax == nnOutput(2)) %calm
        % don't do anything...
    elseif(nnOutputMax == nnOutput(3)) %move right
        [mx,my] = movemouse(rob,mx,my,3,-0,1);      %Move right
    else
        fprintf('lol error here\n');
    end
end

fprintf('End\n');
pause(timeBetweenMessages);
