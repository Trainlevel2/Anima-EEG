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
s.InputBufferSize = 20000;
fopen(s);
%figure
pause(1)
AlphaAvrArr1 = zeros(1,30);
AlphaAvrArr2 = zeros(1,30);
AlphaMinArr1 = zeros(1,30);
AlphaMinArr2 = zeros(1,30);
k = 1;
while 1
    %totalArray = zeros(1,2048);
    prev = 0;
    sampleArray = fscanf(s, '%c');
    
    br1 = find(sampleArray=='{',1,'first') + 1;
    br2 = find(sampleArray=='}',1,'first') - 1;
    
    totalArray = str2num(sampleArray(br1:br2));
    
    
    signal1 = totalArray(1:3:end);
    signal2 = totalArray(2:3:end);
    signal3 = totalArray(3:3:end);
    
    fs = length(signal1);
    
    signal11 = signal1;
    signal22 = signal2;
    
    signal1 = signal1 - signal3;
    signal2 = signal2 - signal3;

%     totalArray = medfilt1(totalArray, 3);
    wo = 60/(fs/2);  bw = wo/35;
    [b1,a1] = iirnotch(wo,bw);              %Notch filter
    
%     totalArray = filter(b1,a1,totalArray);
%     totalArray = filter(b1,a1,totalArray);
    
    wo = 15/(fs/2);  bw = wo/35;
    [b1,a1] = iirpeak(wo,bw);
    
     signal1 = filter(b1,a1,signal1);
    
%     totalArray = detrend(totalArray);
    
    [b1,a1] = butter(4,50/(fs/2));          %Low pass filter
%     totalArray = filter(b1,a1,totalArray);
    
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


%     %Alpha values
    
    AlphaAvrArr1 = circshift(AlphaAvrArr1,-1);
    AlphaAvrArr2 = circshift(AlphaAvrArr2,-1);
    
    AlphaMinArr1 = circshift(AlphaMinArr1,-1);
    AlphaMinArr2 = circshift(AlphaMinArr2,-1);

    
    AlphaAvr1 = sum(P11(9:14))/6;
    AlphaMin1 = min(P11(9:14));
    AlphaAvrArr1(30) = AlphaAvr1;
    AlphaMinArr1(30) = AlphaMin1;
    AlphaAvr2 = sum(P12(9:14))/6;
    AlphaMin2 = min(P12(9:14));
    AlphaAvrArr2(30) = AlphaAvr2;
    AlphaMinArr2(30) = AlphaMin2;
    
    subplot(2,1,1)
    plot(AlphaAvrArr1);
    hold on
    plot(AlphaAvrArr2);
    title('Minimum Mu Values')
    xlabel('Time (s)') % x-axis label
    ylabel('Magnitude (V)') % y-axis label
    hold off
    axis([0 inf 0 0.02])
    subplot(2,1,2)
    plot(AlphaMinArr1);
    hold on
    plot(AlphaMinArr2);
    title('Average Mu Values')
    xlabel('Time (s)') % x-axis label
    ylabel('Magnitude (V)') % y-axis label
    hold off
    axis([0 inf 0 0.02])
    
    drawnow


%     subplot(2,1,1)
%     plot(x,signal1);
%     hold on
%     plot(x,signal2);
%     hold off
%     axis([0 inf -inf inf])
%     xlabel('Time (ms)');
%     ylabel('Amplitude (v)');
%     title('Time Domain Signal');
%     
%     subplot(2,1,2)
%     plot(f,P11);
%     hold on
%     plot(f,P12);
%     hold off
%     axis([0 30 0 0.01])
%     xlabel('Frequency (Hz)');
%     ylabel('Amplitude (v)');
%     title('Frequency Analysis');
%     
%     drawnow
    
%     if k==10
%         k=0;
%     else
%         k=k+1;
%     end
end