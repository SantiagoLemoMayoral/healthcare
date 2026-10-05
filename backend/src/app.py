from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
import os
import pyroscope


# --------------------------------
# Pyroscope profiling
# --------------------------------

pyroscope.configure(
    application_name="healthcare",
    server_address=os.getenv(
        "PYROSCOPE_SERVER_ADDRESS",
        "http://pyroscope.observability.svc.cluster.local:4040",
    ),
)

def expensive_work():
    total = 0

    for i in range(5000000):
        total += i * i

    return total


def cheap_work():
    return "OK"


class Handler(BaseHTTPRequestHandler):

    def do_GET(self):

        if self.path == "/health":

            result = cheap_work()

            self.send_response(200)
            self.send_header("Content-Type", "text/plain")
            self.end_headers()

            self.wfile.write(result.encode())


        elif self.path == "/cpu-test":

            expensive_work()

            self.send_response(200)
            self.send_header("Content-Type", "text/plain")
            self.end_headers()

            self.wfile.write(b"CPU work completed")


        else:

            self.send_response(404)
            self.end_headers()



server = ThreadingHTTPServer(
    ("0.0.0.0", 8000),
    Handler
)

print("Healthcare running on :8000")

server.serve_forever()