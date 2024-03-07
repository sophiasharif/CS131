import asyncio
import sys

def get_port(name):
    return {
        'Bailey': 10000,
        'Bona': 10001,
        'Campbell': 10002,
        'Clark': 10003,
        'Jaquez': 10004
    }[name]


class Server:

    def __init__(self, name):
        self.name = name
        self.port = get_port(name)
    
    async def start(self):
        print(f'Starting server {self.name}...')
        server = await asyncio.start_server(self.handle_client, 'localhost', self.port)
        await server.serve_forever()
    
    async def handle_client(self, reader, writer):
        print('New client connected')
        data = await reader.read(100) # read up to 100 bytes
        message = data.decode() # decode from bytes to string (utf-8 by default)
        addr = writer.get_extra_info('peername')
        print(f"Received {message!r} from {addr!r}")


async def main():
    server = Server(sys.argv[1])
    await server.start()

# top-level entry point; blocking call until main() completes (which is never)
asyncio.run(main())
