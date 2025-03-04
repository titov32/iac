from flask import Flask, request
import socket

app = Flask(__name__)

@app.route('/')
def get_info():
    hostname = socket.gethostname()
    ip_address = request.remote_addr
    return {
        "hostname": hostname,
        "ip_address": ip_address
    }

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
