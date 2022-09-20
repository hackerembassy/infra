Example deploy-rs infra
====

## Nodes

### example-node
 - Does really nothing
 - Stores nothing
 - Exposes do-nothing VM
 
## Hacking info

| directory   | function                                                                                                           |
|-------------|--------------------------------------------------------------------------------------------------------------------|
| ./nodes     | Node configurations, automatically mapped over and deployed.                                                       |
| ./terraform | Terraform files, yes.                                                                                              |
| ./common    | Contains common configuration across all the nodes in this repo                                                    |
| ./secrets   | Per-node secrets, secrets/%hostname%/* send them via `./scripts/send-secrets.sh` or `make send-secrets/%hostname%` |
|             |                                                                                                                    |
|             |                                                                                                                    |
