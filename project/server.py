import asyncio
import aiohttp
import time
import sys

def get_port(name):
    return {
        'Bailey': 10000,
        'Bona': 10001,
        'Campbell': 10002,
        'Clark': 10003,
        'Jaquez': 10004
    }[name]

API_KEY = "AIzaSyA83pvRMs3tb_6pz6xm9aoj7wTBFJ04oU0"

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
            time_diff = time.time() # TODO: get time difference
            return f"handeled {message}"
        except:
            return f'? {message}'




# async def main():
#     server = Server(sys.argv[1])
#     await server.start()
        
async def fetch(url):
    async with aiohttp.ClientSession() as session:  # Create a session.
        async with session.get(url) as response:  # Make a GET request.
            return await response.text()  # Return the text of the response.

async def get_places(lat, long, radius, limit):
    # radius in km
    command = f"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location={lat},{long}&radius={radius*1000}&type=restaurant&key={API_KEY}"      
    # TODO : add limit manually
    return await fetch(command)

        

async def main():
    print(await get_places("+34.068930","-118.445127", 10, 5))
    



# top-level entry point; blocking call until main() completes (which is never)
asyncio.run(main())
    
