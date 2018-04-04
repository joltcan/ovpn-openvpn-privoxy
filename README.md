# ![OVPN logo](https://www.ovpn.com/images/logos/logo.svg)

# Privoxy via OVPN OpenVPN connection
An Alpine Linux container running Privoxy and OpenVPN via OVPN.(se|com)

Protect your browsing activities through an encrypted and anonymized VPN proxy!

You will need a [OVPN](https://www.ovpn.se) account. 

## Attribution
[Act28](https://github.com/act28) created the [repo](https://github.com/act28/pia-openvpn-proxy) from which I copied, then modified the code to work with [OVPN](https://ovpn.se).

I also added a Makefile to build the docker stuff, which I learnt from Pierre Larsson when I was at Verisure.

## Starting the VPN Proxy

```Shell
docker run -d \
--cap-add=NET_ADMIN \
--device=/dev/net/tun \
--name=ovpn-openvpn-privoxy \
--dns=1.1.1.1 \ 
--restart=always \
-e "REGION=<region>" \
-e "USERNAME=<ovpn_username>" \
-e "PASSWORD=<ovpn_password>" \
-e "LOCAL_NETWORK=192.168.1.0/24" \
-v /etc/localtime:/etc/localtime:ro \
-p 8118:8118 \
jolt/ovpn-openvpn-privoxy 
```

### Environment Variables
`REGION` is optional. The default region is set to `se `, which is any Sweden-based server. `REGION` should match the location part in app/openvpn.

`USERNAME` / `PASSWORD` - Credentials to connect to OVPN

`LOCAL_NETWORK` - The CIDR mask of the local IP addresses (e.g. 192.168.1.0/24, 10.1.1.0/24) which will be acessing the proxy. This is so the response to a request can be returned to the client (i.e. your browser).

Substitute the environment variables for `REGION`, `USERNAME`, `PASSWORD`, `LOCAL_NETWORK` as indicated.

# Compose

A `docker-compose-dist.yml` file has also been provided. Copy this file to `docker-compose.yml` and substitute the environment variables are indicated.

Then start the VPN Proxy via:

```Shell
docker-compose up -d
```

## Connecting to the VPN Proxy

To connect to the VPN Proxy, set your browser proxy to 0.0.0.0:8118.

If you're using Chrome, you may want to use [ProxySwitchyOmega](https://chrome.google.com/webstore/detail/proxy-switchyomega/padekgcemlokbadohgkifijomclgjgif)

If you're using Firefox, you may want to use [ProxySwitcher](https://addons.mozilla.org/en-US/firefox/addon/proxy-switcher/)
