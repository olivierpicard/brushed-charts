# Terraform backend choice

## Abstract
This document describes the reflexion behind the choose of Terraform backend

## Choice
There is two main choice for Terraform backend:
- Terraform cloud
- Google Cloud Storage

## Terraform cloud
It's simply the best and easy choice.<br/> 
But it presents some major flaws and manual steps:
- Can't use files to authentificate (eg. private_key_path; /etc/xxx/yyy.pem)
- By default plan is executed remotly on the cloud
    - So there is no access to local data
- Cloud can act as a state storage but:
    - There is no way to change "execution mode" to local in the YAML file
    - You should create and configure the workspace before launching the plan locally



## Google Cloud Storage (or AWS S3)
This choice is less obvious. But GCS can be use as a backend.
The major advantages is: 
- You can use it by default as a state storage. (It will not execute you plan)
- No need to configure, storage or workspace before using it
- Everything could be done directly in the YAML config file
But it as also some flaws:
- It could not be use as a backend executor.
    - So env variables can not be centralized in GCS
- Ask for an other env variables, to use it as backend