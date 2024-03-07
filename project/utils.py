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


async def fetch(url):
    async with aiohttp.ClientSession() as session:  # Create a session.
        async with session.get(url) as response:  # Make a GET request.
            return await response.text()  # Return the text of the response.


async def get_places(location, radius, limit):
    lat, long = separate_lat_long(location)
    radius_in_m = int(radius) * 1000
    command = f"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location={lat},{long}&radius={radius_in_m}&type=restaurant&key={API_KEY}"      
    # TODO : add limit manually
    return await fetch(command)


def separate_lat_long(iso6709):
    
    if not iso6709 or len(iso6709) < 3:
        raise ValueError("Invalid ISO 6709 notation: too short.")

    if iso6709[0] not in '+-':
        raise ValueError("Invalid ISO 6709 notation: does not start with + or -.")

    for i in range(1, len(iso6709)):
        if iso6709[i] in '+-':
            lat = iso6709[:i]
            long = iso6709[i:]
            return lat, long
    
    raise ValueError("Invalid ISO 6709 format")