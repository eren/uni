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

import sys
import socket
import threading

from Tkinter import *

class Client(object):
    """
    Scribble client that receives the data from server and process
    them.
    
    A seperate thread is created for the client so that TK
    mainloop can run. After each data has been received, the gui is
    updated.
    
    """

    def __init__(self, host, port, tk_canvas):
        self.client = None

        self.tk_canvas = tk_canvas
        self.host = host
        self.port = port

    def run(self):
        self.client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.client.connect((self.host, self.port))

        print '[+] Client connected'

        while True:
            line = self.read()
            line.replace('\n', '')

            try:
                x, y, newx, newy = line.split(' ')
                self.tk_canvas.create_line(((x, y), (newx, newy)))
            except:
                pass

    def send(self, data):
        """Write the data with newline character"""

        self.client.send('%s\n' % data)

    def read(self):
        return self.client.recv(1024)

    def close(self):
        self.send('quit:')
        sys.exit(0)

class Scribble(object):
    """Scribble client"""

    def __init__(self, host, port):
        self.x = None
        self.y = None
        self.client = None

        self.host = host
        self.port = port

    def run(self):
        self.tk_root = Tk()
        self.tk_canvas = Canvas(self.tk_root)
        self.tk_canvas.bind("<B1-Motion>", self.drag_handler)
        self.tk_canvas.bind("<ButtonRelease-1>", self.drag_end_handler)
        self.tk_canvas.pack()

        b = Button(self.tk_root, text="Quit")
        b.pack()
        b.bind("<Button-1>", self.quit_handler)

        self.client = Client(self.host, self.port, self.tk_canvas)
        t = threading.Thread(target=self.client.run)
        t.setDaemon(True)
        t.start()

        self.tk_root.mainloop()

    def quit_handler(self, event):
        self.client.close()
        sys.exit(0)

    def drag_handler(self, event):
        newx, newy = event.x, event.y

        if self.x is None:
            self.x, self.y = newx, newy
            return

        self.client.send('broadcast: %s %s %s %s' % \
                (self.x, self.y, newx, newy))

        self.tk_canvas.create_line(((self.x, self.y), (newx, newy)))
        self.x, self.y = newx, newy

    def drag_end_handler(self, event):
        self.x, self.y = None, None
    
def __control_arguments():
    if (len(sys.argv) <= 2):
        print 'ERROR: Please provide a host and port to connect. \
\
\nExample: %s localhost 9999' % sys.argv[0]
        sys.exit(1)

if __name__ == '__main__':
    __control_arguments()

    host = sys.argv[1]
    port = sys.argv[2]

    scribble = Scribble(host, int(port))
    scribble.run()
