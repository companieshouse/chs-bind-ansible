def bind_reverse_zone(ip):
    octets = ip.split(".")

    if len(octets) != 4:
        raise ValueError(f"Invalid IPv4 address: {ip}")

    return f"{octets[2]}.{octets[1]}.{octets[0]}.in-addr.arpa"


class FilterModule(object):
    def filters(self):
        return {
            "bind_reverse_zone": bind_reverse_zone,
        }
