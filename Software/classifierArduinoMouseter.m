clear all
close all
clc

% create a fig + pushbutton
     fh=figure;
     fp=get(fh,'position');
     ss=get(0,'screensize');
     uh=uicontrol;
     set(uh,'style','pushbutton');
     set(uh,'callback','disp(''click clock, time to talk!'');');
     set(uh,'units','normalized');
     set(uh,'position',[0,0,1,1]);
     set(uh,'string','Mind your mind...');
     shg();
% initialize the java engine
     import java.awt.*;
     import java.awt.event.*;
% ...create a robot
     rob=Robot;
% ...and let her do the work for you
     mx=fp(1)+fix(fp(3)/2);
     my=ss(4)-fp(2)-fix(fp(4)/2);

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
    
    signal1 = signal1 - signal3;
    signal2 = signal2 - signal3;

%     totalArray = medfilt1(totalArray, 3);
    wo = 60/(fs/2);  bw = wo/35;
    [b1,a1] = iirnotch(wo,bw);              %Notch filter
    
%     totalArray = filter(b1,a1,totalArray);
%     totalArray = filter(b1,a1,totalArray);
    
    wo = 10/(fs/2);  bw = wo/35;
    [b1,a1] = iirpeak(wo,bw);
    
%     totalArray = filter(b1,a1,totalArray);
    
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


    %Alpha values
    
%     AlphaAvr = sum(P1(5:7))/3;
%     time(k) = k;
%     AlphaAvrArr(k) = AlphaAvr;

%     totalArray = totalArray - P1(1);
%    subplot(2,1,1)
%    plot(x,signal1);
%    hold on
%    plot(x,signal2);
%    hold off
%    axis([0 inf -inf inf])
%    xlabel('Time (ms)');
%    ylabel('Amplitude (v)');
%    title('Time Domain Signal');
    
%    subplot(2,1,2)
%    plot(f,P11);
%    hold on
%    plot(f,P12);
%    hold off
%    axis([0 inf 0 inf])
%    xlabel('Frequency (Hz)');
%    ylabel('Amplitude (v)');
%    title('Frequency Analysis');
array = ??
marginoferror = ??

%Mouse Movement Code
%t=1;
     [mx,my] = movemouse(rob,mx,my,-20*classifier(array,marginoferror),-20*classifier(array2,marginoferror),4);
     [mx,my] = movemouse(rob,mx,my,20*classifier(array,marginoferror),20*classifier(array2,marginoferror),4);
%     t=t+1;
%     pause(.2);
%     rob.mousePress(InputEvent.BUTTON1_MASK);
%     rob.mouseRelease(InputEvent.BUTTON1_MASK);
%     set(uh,'string','DONE...'); 


%    drawnow
    
    k=k+1;
end