%This function works after running the Python socket program
function pymat(str)
    t = tcpip('localhost', 50007); % Must be same port as
                                   % echoserver.py
    fopen(t);
    fwrite(t, str); % If str is really long, may need to
                    %break up with for loop
    pause(.01);     % Pause between read and write
    bytes = fread(t, [1, t.BytesAvailable]);
    char(bytes)     % Display what was written
    pause(.01);     % Closing prematurely causes an error
    fclose(t);      % fclose closes the python echoserver
end