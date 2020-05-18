#!/usr/bin/python
import time
import socket
import flask

app = flask.Flask(__name__)

START = time.time()

BIND_PARAMETERS = {
    'HOST': "0.0.0.0",
    'PORT': 5000
}


def elapsed():
    running = time.time() - START
    minutes, seconds = divmod(running, 60)
    hours, minutes = divmod(minutes, 60)
    return "%d:%02d:%02d" % (hours, minutes, seconds)


@app.route('/')
def root():
    request_headers = "".join(["<tr><td class='header-key'>{}</td><td class='header-value'>{}</td></tr>".format(
        header_name, header_value) for (header_name, header_value) in flask.request.headers.items()])
    host = "[HOST: {}] (uptime: {})]".format(socket.gethostname(), elapsed())
    response_body = "Hello Universe"
    style = """
    body {
        width: 800px;
        margin: 0 auto;
        font-family: Roboto,sans-serif;
        margin-top: 40px;
        background: #1b1b1b;
        color: #FFF;
    }
    .header-key {
        background:#424242;
        padding:6px;
    }
    .header-value {
        background:#6d6d6d;
        padding:6px;
    }
    #response {
        font-size:20px;
        border: 1px solid #d4d3d9;
        padding: 20px;
    }
    """
    response = "<title>Hello Universe</title><style>{}</style><body><h3>Request Headers</h3><table>{}</table><hr/><h3>Response from {} </h3><div id='response'>{}</div></body>".format(
        style.replace("\n", " "), request_headers, host, response_body)
    return response


if __name__ == "__main__":
    app.run(
        debug=True, host=BIND_PARAMETERS['HOST'], port=BIND_PARAMETERS['PORT'])
