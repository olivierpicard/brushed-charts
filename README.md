# backend

- Create a python virtual environnement at root (./backend)
```bash
python3 -m venv .venv
```
- In .vscode folder edit settings.json file. replace `"python.pythonPath"` value by `.venv/bin/python3`

## Push to registry

To deploy services to registry, use the script `bin/push_to_registry.sh <dev|test|prod>` it will push to the registry writed in the field image of the `docker-compose.yml`

## Start services

In dev mode services will be deployed locally using docker-compose. But for test and prod profil the services will be deployed in swarm mode using `docker stack`. Advantage to use deploy as stack is that the profil test and prod can operate on the same node without override each other

