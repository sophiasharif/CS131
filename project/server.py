import asyncio
import socket
import time
import sys
from utils import *

# set up logging

class Location:
    def __init__(self, server, location, timestamp):
        self.server = server
        self.location = location
        self.timestamp = timestamp
    
    def __repr__(self):
        return f'Location({self.server}, {self.location}, {self.timestamp})'

class Server:

    def __init__(self, name):
        self.name = name
        self.port = get_port(name)
        self.client_locations = {}

        sys.stdout = open(f'{name}.log', 'w')
    

    async def start(self):
        server = await asyncio.start_server(self.handle_client, port=self.port, family=socket.AF_INET)

        print(f'Initialized server {self.name} on port {self.port}', flush=True)
        await server.serve_forever()
    

    async def handle_client(self, reader, writer):

        # read message from client
        data = await reader.read(1000) # read up to 100 bytes
        message = data.decode() # decode from bytes to string (utf-8 by default)
        client_ip, client_port = writer.get_extra_info('peername')
        print(f"[handle_client] RECEIVED MESSAGE from {client_port} with IP {client_ip}: {message!r}", flush=True)

        # handle message
        response = f"? {message}"
        if message.startswith('IAMAT'):
            response = await self.handle_IAMAT(message)
        elif message.startswith('WHATSAT'):
            response = await self.handle_WHATSAT(message)
        elif message.startswith('UPDATE'):
            await self.handle_UPDATE(message)
            print(f'[handle_client] LOCATION UPDATE for {message.split()[2]}', flush=True)
            await writer.drain()
            return


        # send response back to client
        print(f"[handle_client] SEND: {response!r}", flush=True)
        writer.write(response.encode())
        await writer.drain()

        # close the connection
        writer.close()


    async def handle_IAMAT(self, message):
        try:
            _, client_id, location, timestamp = message.split()

            # update client location
            loc = Location(self.name, location, timestamp)
            self.client_locations[client_id] = loc
            print(f'[handle_IAMAT] LOCATION UPDATE for {client_id}: {loc}', flush=True)

            # propagate message to other servers
            print('[handle_IAMAT] UPDATING OTHER SERVERS', flush=True)
            update_message = f'UPDATE {self.name} {client_id} {location} {timestamp} {serialize_ports(get_buddy_ports(self.port) + [self.port])} {self.port}'
            for port in get_buddy_ports(self.port):
                await self.send_message_to_server(port, update_message)


            # check location is valid
            return f'AT {self.name} {time.time() - float(timestamp)} {client_id} {location} {timestamp}'
        
        except Exception as e:
            print(f"Exception in handle_IAMAT: {e}", flush=True)
            return f'? {message}'


    async def handle_WHATSAT(self, message):
        try:
            _, client, radius, limit = message.split()
            loc = self.client_locations[client]
            api_response = await get_places(loc.location, radius, limit)

            print(f'[handle_IAMAT] GENERATING API RESPONSE', flush=True)

            return f"AT {loc.server} {time.time() - float(loc.timestamp)} {client} {loc.location} {loc.timestamp}\n{api_response}"
        except Exception as e:
            print(f"Exception in handle_WHATSAT: {e}", flush=True)
            return f'? {message}'
        
    
    async def handle_UPDATE(self, message):
        try:
            _, server, client_id, location, timestamp, updated_ports_seriralized, source_port = message.split()
            updated_ports = deserialize_ports(updated_ports_seriralized)
            print(f'[handle_UPDATE] RECEIVED an update from {source_port}: ', message, flush=True)


            # don't do anything if already updated
            if client_id in self.client_locations and float(self.client_locations[client_id].timestamp) >= float(timestamp):
                print(f'[handle_UPDATE] Location already updated, returning...', flush=True)
                return
            
            # update client location
            loc = Location(server, location, timestamp)
            self.client_locations[client_id] = loc
            
            # dispatch message to other servers
            print(f'[handle_UPDATE] UPDATING other servers', flush=True)
            buddy_ports = get_buddy_ports(self.port)
            new_message = f'UPDATE {server} {client_id} {location} {timestamp} {serialize_ports(updated_ports + buddy_ports + [self.port])} {self.port}'
            print(f'    message: {new_message}', flush=True)
            for buddy_port in buddy_ports:
                if buddy_port in updated_ports: # don't send duplicate messages
                    continue
                print(f'    [handle_UPDATE] Sending update to {buddy_port}', flush=True)
                await self.send_message_to_server(buddy_port, new_message)
            
        except Exception as e:
            print(f"Exception in handle_UPDATE: {e}", flush=True)
            return f'? {message}'
        

    async def send_message_to_server(self, port, message):
        try:
            reader, writer = await asyncio.open_connection(port=port, family=socket.AF_INET)
            print(f'[send_message_to_server] Sending to {port}: {message}', flush=True)

            writer.write(message.encode())
            await writer.drain()  # Ensure the message is sent
            writer.close()  # Close the connection
            await writer.wait_closed()  # Wait for the connection to close
        except ConnectionRefusedError as e:
            print(f"Connection refused to {port}. Server may be down.", flush=True)
        except Exception as e:
            print(f"Exception in send_message_to_server: {e}", flush=True)
            return f'? {message}'


    

async def main():
    server = Server(sys.argv[1])
    await server.start()


# top-level entry point; blocking call until main() completes (which is never)
asyncio.run(main())
    
