#-*- coding: utf8 -*-

# Copyright (C) 2013  Eren Türkay <turkay.eren@gmail.com>

# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
# 02110-1301, USA.

import socket
import os
import threading
import sys

def __control_arguments():
    if (len(sys.argv) <= 2):
        print 'ERROR: Please provide a socket to bind to and a nickname. Example: \
%s /tmp/mysocket mynick' % sys.argv[0]
        sys.exit(1)

class Client(object):
    """A basic client"""

    def __init__(self, socket_file, nick):
        self.socket = socket_file
        self.nick = nick

        self.client = None
        
    def run(self):
        self.client = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM, 0)
        self.client.connect(self.socket)

        self.send('name: %s' % self.nick)

        while True:
            # FIXME: handle the command from the server in different
            # function
            line = self.read()

            print line

    def send(self, data):
        """Write the data with newline character"""

        self.client.send('%s\n' % data)

    def read(self):
        return self.client.recv(1024)
                

def main():
    __control_arguments()

    socket_file = sys.argv[1]
    nick = sys.argv[2]
    # FIXME: control if the socket is writable

    client = Client(socket_file, nick)

    t = threading.Thread(target=client.run)
    t.setDaemon(True)
    t.start()

    while True:
        s = raw_input('')

        client.send(s)

if __name__ == '__main__':
    main()
