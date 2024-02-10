# X-RAY demo

## Requirements

Dependencies:

- python3.11
- poetry
- terraform
- docker
- aws cli

Other:

- aws account, aws cli with credentials configured and profile

## Deployment

```sh
./deploy.sh AWS_PROFLE TAG
```

After you finish, remember to clean up after yourself!

```sh
./cleanup.sh AWS_PROFILE
```

## Commands

```sh
flask --app hello run -p 5001
```
