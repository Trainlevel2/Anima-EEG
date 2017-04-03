% create a fig + pushbutton
     fh=figure;
     fp=get(fh,'position');
     ss=get(0,'screensize');
     uh=uicontrol;
     set(uh,'style','pushbutton');
     set(uh,'callback','disp(''click clock, time to talk!'');');
     set(uh,'units','normalized');
     set(uh,'position',[0,0,1,1]);
     set(uh,'string','wait for autopress...');
     shg();
% initialize the java engine
     import java.awt.*;
     import java.awt.event.*;
% ...create a robot
     rob=Robot;
% ...and let her do the work for you
     mx=fp(1)+fix(fp(3)/2);
     my=ss(4)-fp(2)-fix(fp(4)/2);

t=1;
    while(t<4)
     [mx,my] = movemouse(rob,mx,my,-20,-20,4);
     [mx,my] = movemouse(rob,mx,my, 0,40,4);
     [mx,my] = movemouse(rob,mx,my,40,0,4);
     [mx,my] = movemouse(rob,mx,my,0,-40,4);
     [mx,my] = movemouse(rob,mx,my,-20,20,4);
     t=t+1;
    end
     pause(.2);
     rob.mousePress(InputEvent.BUTTON1_MASK);
     rob.mouseRelease(InputEvent.BUTTON1_MASK);
     set(uh,'string','DONE...'); 
