function output = classifier(input,errorMargin)
    sum = input(1); count1 = 0;
    sum2 = 0; count2 = 0;
    x=1;
    while(x<input.length)
       if(abs((sum/(x-1))-input(x))<errorMargin*abs(input(x)))
            sum = sum + input(x); count1 = count1 + 1;
       else
           sum2 = sum2 + input(x); count2 = count2 + 1;
       end
       x=x+1;
    end
    output = sum/count1;
    if(sum2/count2 > output)
        output = 0;
    else
        output = 1;
    end
end
