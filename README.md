# Call of Duty 1 Docker Server
Run a streamlined Call of Duty 1 server within a Docker container, allowing you the flexibility to choose the desired version.

# Setup the server
From the project root:
1. Clone or download this repository on your host machine.
1. Run **`./install.sh <version>`** to download the game files for your desired version (e.g., **`1.1`**, **`1.2`**, **`1.3`**, **`1.4`** or **`1.5`**).
   - e.g **`./install.sh 1.5`**
1. Edit the config file located in **`codserver/main/config.cfg`** to suit your needs
   - Modify the file as you like, remember to change server_name, slots, etc.
1. (Optional) You can modify `docker-compose.yml` in order to change some parameters.
   - in the **`ports`** directive, you can change the port of the server. (e.g, **`20010:28960/tcp`** means that the port will be **`20010`**)
   - in the **`command`** directive you can modify the execution parameters.
1. (Optional) If you need to activate punkbuster:
   1. a

# Launch the server
From the project root:
``` bash
docker-compose up -d
```

# Server interactions
From the project root you can:
- Restart server:
``` bash
docker-compose restart
```

- Tail the server logs:
``` bash
docker-compose logs cod1server # being cod1server the name of the container
```

- Stop server completely
``` bash
docker-compose down
```

# Troubleshooting

```
server_1  | Sys_Error: Couldn't load default_mp.cfg.  Make sure Call of Duty is run from the correct folder.
```
**Make sure you have files in your main folder. `default_mp.cfg` is usually inside `localized_*` files.**
