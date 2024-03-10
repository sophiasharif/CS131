import json
import aiohttp

API_KEY = "AIzaSyA83pvRMs3tb_6pz6xm9aoj7wTBFJ04oU0"

def get_port(name):
    return {
        'Bailey': 10000,
        'Bona': 10001,
        'Campbell': 10002,
        'Clark': 10003,
        'Jaquez': 10004
    }[name]

def get_buddy_ports(port):
    return {
        10000: [10001, 10002],
        10001: [10000, 10002, 10003],
        10002: [10000, 10001, 10004],
        10003: [10001, 10004],
        10004: [10002, 10003]
    }[port]

def serialize_ports(ports):
    unique_ports =list(set(ports))
    return ';'.join([str(port) for port in unique_ports])

def deserialize_ports(ports):
    return [int(port) for port in ports.split(';')]

async def fetch(url):
    async with aiohttp.ClientSession() as session:  # Create a session.
        async with session.get(url) as response:  # Make a GET request.
            return await response.text()  # Return the text of the response.


async def get_places(location, radius, limit):
    lat, long = separate_lat_long(location)
    radius_in_m = min(int(radius) * 1000, 50000) # limit to 50km
    limit = min(int(limit), 20) # limit to 20 results
    command = f"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location={lat},{long}&radius={radius_in_m}&key={API_KEY}"      
    response = await fetch(command)
    response = json.loads(response)
    response['results'] = response['results'][:int(limit)]
    return json.dumps(response, indent=4)


def separate_lat_long(iso6709):
    
    if not iso6709 or len(iso6709) < 3:
        raise ValueError("Invalid ISO 6709 notation: too short.")

    if iso6709[0] not in '+-':
        raise ValueError("Invalid ISO 6709 notation: does not start with + or -.")

    for i in range(1, len(iso6709)):
        if iso6709[i] in '+-':
            lat = iso6709[:i]
            long = iso6709[i:]
            if lat[0] == '+':
                lat = lat[1:]
            if long[0] == '+':
                long = long[1:]
            return lat, long
    
    raise ValueError("Invalid ISO 6709 format")