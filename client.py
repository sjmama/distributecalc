import os
import socket
import pickle
import struct
import io
host='210.110.39.82'
port=8888
csocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
csocket.connect((host, port))

while True:
    blen=0
    tot_data=b''
    lenb = csocket.recv(4)
    mlen=struct.unpack('!I', lenb)[0]
    print(mlen)
    while (mlen-blen>0):
        data = csocket.recv(mlen)
        blen+=len(data)
        tot_data+=data
    result = tot_data.decode()
    print(result)
    # msg = input('msg:')
    msg = 'Memmory:\n'
    msg=msg+os.popen('free -h').read()
    msg=msg+'\n'
    msg=msg+'Storage:\n'
    msg=msg+os.popen('df -h').read()
    csocket.sendall(struct.pack('!I', len(msg)))
    csocket.sendall(msg.encode())