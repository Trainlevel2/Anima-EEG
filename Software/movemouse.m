function [mx,my] = movemouse(rob,mx,my,dx,dy,speed)
    tempmy=my; tempmx=mx;
    dx = dx*10; dy = dy*10; speed = speed*4;
    targetx = round(round(dx/speed)/3)*3; targety = round(round(dy/speed)/3)*3;
    minidx=speed; minidy=speed;
    startx = 0; starty=0;
    dsx=1; dsy=1;
    if(dx<0)
        minidx=-speed;
        dsx=-1;
    end
    if(dy<0)
        minidy=-speed;
        dsy=-1;
    end
    while(abs(targetx)>abs(startx)||abs(targety)>abs(starty))
         pause(.05/speed);
         rob.mouseMove(mx,my);
         if(abs(targetx)>abs(startx))
             mx=mx+minidx;
             startx=startx+dsx;
         end
         if(abs(targety)>abs(starty))
             my=my+minidy;
             starty=starty+dsy;
         end
    end
    %my=tempmy+floor(dy/speed);
    %mx=tempmx+floor(dx/speed);
    %rob.mouseMove(mx,my);
end