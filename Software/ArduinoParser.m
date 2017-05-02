clear all
close all
clc

%%% Configuration Data
serialPort = 'COM3';            % define COM port #
baudRate = 115200;


priorPorts = instrfind; % finds any existing Serial Ports in MATLAB
delete(priorPorts); % and deletes them
% User Defined Properties 
s = serial(serialPort,'BaudRate', baudRate);
s.InputBufferSize = 10000;
fopen(s);
%figure
pause(1)
k = 1;
while 1
    %totalArray = zeros(1,2048);
    %Read from serial
    prev = 0;
    sampleArray = fscanf(s, '%c');
    
    %Get info between { and } and convert it to number
    % array totalArray
    br1 = find(sampleArray=='{',1,'first') + 1;
    br2 = find(sampleArray=='}',1,'first') - 1;
    
    sampleArray = sampleArray(br1:br2);
    
    totalArray = str2num(sampleArray);
    fs = length(totalArray);
%     totalArray = medfilt1(totalArray, 3);
    wo = 60/(fs/2);  bw = wo/35;
    [b1,a1] = iirnotch(wo,bw);              %Notch filter
    
%      totalArray = filter(b1,a1,totalArray);
%      totalArray = filter(b1,a1,totalArray);
    
    wo = 12/(fs/2);  bw = wo/35;
    [b1,a1] = iirpeak(wo,bw);
    
%       totalArray = filter(b1,a1,totalArray);
    
%     totalArray = detrend(totalArray);
    
    [b1,a1] = butter(4,50/(fs/2));          %Low pass filter
%     totalArray = filter(b1,a1,totalArray);
    
    y = fft(totalArray);
    l = length(y);
    P2 = abs(y/l);
    P1 = P2(1:floor(l/2+1));
    P1(2:end-1) = 2*P1(2:end-1);
    f = (fs)*(0:(l/2))/l;
    x = 0:(1000/fs):1000;
    x = x(1:(end-1));
    
    %Alpha values
    
%     AlphaAvr = sum(P1(5:7))/3;
%     time(k) = k;
%     AlphaAvrArr(k) = AlphaAvr;

    totalArray = totalArray - P1(1);
    subplot(2,1,1)
    plot(x,totalArray);
    axis([0 inf -2.5 2.5])
    xlabel('Time (ms)');
    ylabel('Amplitude (v)');
    title('Time Domain Signal');
    
    subplot(2,1,2)
    plot(f,P1);
    axis([0 100 0 inf])
    xlabel('Frequency (Hz)');
    ylabel('Amplitude (v)');
    title('Frequency Analysis');
    axis([0 40 0 0.1])
    
    drawnow
    
    k=k+1;
end
