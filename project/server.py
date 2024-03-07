import asyncio
import aiohttp
import time
import sys
from utils import *

class Server:

    def __init__(self, name):
        self.name = name
        self.port = get_port(name)
    

    async def start(self):
        print(f'Starting server {self.name}...')
        server = await asyncio.start_server(self.handle_client, 'localhost', self.port)
        await server.serve_forever()
    

    async def handle_client(self, reader, writer):

        # read message from client
        print('New client connected')
        data = await reader.read(100) # read up to 100 bytes
        message = data.decode() # decode from bytes to string (utf-8 by default)
        addr = writer.get_extra_info('peername')
        print(f"Received {message!r} from {addr!r}")

        # handle message
        response = f"? {message}"
        if message.startswith('IAMAT'):
            response = await self.handle_IAMAT(message)
        elif message.startswith('WHATSAT'):
            response = await self.handle_WHATSAT(message)

        # send response back to client
        print(f"Send: {response!r}")
        writer.write(response.encode())
        await writer.drain()


    async def handle_IAMAT(self, message):
        try:
            _, client_id, location, timestamp = message.split()

            # check location is valid
            return f'AT {self.name} {time.time() - float(timestamp)} {client_id} {location} {timestamp}'
        
            # make a request to google maps api
        
        except:
            return f'? {message}'


    async def handle_WHATSAT(self, message):
        try:
            _, client, radius, limit = message.split()
            # TODO: get time difference
            api_response = await get_places(await self.get_client_location(client), radius, limit)

            # TODO: fix response header
            return f"handeled {message}\n{api_response}"
        except:
            return f'? {message}'
    
    
    async def get_client_location(self, client):
        # TODO: make a request to client server
        return "+34.068930-118.445127"
    

async def main():
    server = Server(sys.argv[1])
    await server.start()


# top-level entry point; blocking call until main() completes (which is never)
asyncio.run(main())
    
