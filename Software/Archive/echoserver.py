# Echo server program
import socket
HOST = ''                 # Symbolic name meaning all available interfaces
PORT = 50007              # Arbitrary non-privileged port
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind((HOST, PORT))
s.listen(1)
conn, addr = s.accept()
print('Connected by', addr) # Display what is connected to the socket
while 1:					# Loop waiting for data to be sent across socket
    data = conn.recv(1024)
    if not data: break
    print('The truth is ',data,'\n')	# Print out message from MATLAB unformatted for Python
    conn.sendall(data)
conn.close()				# Close the connection when no data is sent (AKA port is closed)