# Setup VSCode

- Create a python virtual environnement at root (./backend)
```bash
python3 -m venv .venv
```
- In .vscode folder edit settings.json file. replace `"python.pythonPath"` value by `.venv/bin/python3`
- Add `"program": "${fileDirname}/main.py"` to allow execution of `main.py` file from 
