# Setup VSCode

- Create a python virtual environnement at root (./backend)
```bash
python3 -m venv venv3.xx #Replace xx with the minor version og python
```
- Let's say this repository is placed in /home/brushed-charts/
- At the root of this repository, create a vscode folder named `.vscode`.
- Edit the file `settings.json`
    - Add the line `"python.pythonPath": "venv3.10/bin/python"`. (Update if needed)
- Add a .env file in .vscode folder (/home/brushed-charts/.vscode/.env)
    - In this .env file copy lines from `<REPOSITORY_ROOT>/template/vscode.env_secretpart.template` and fill these information
    - Copy the content of every files in `<REPOSITORY_ROOT>/env`folder except the file with `prod` or `test` in the name 
    - At this step your `.vscode/.env` file should be full of line and ready to go
- Copy the file `<REPOSITORY_ROOT>/template/launch.json` to `<REPOSITORY_ROOT>/.vscode/` folder. If needed change URL of the files


