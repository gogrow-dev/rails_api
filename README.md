# Rails API Base

## How to use

1. Clone this repo
1. Install PostgreSQL in case you don't have it
1. `rspec` and make sure all tests pass
1. `rails s`
1. You can now try your REST services!

## Optional configuration

- Set your [FRONTEND_URL env](https://github.com/cyu/rack-cors#origin)
- Set your mail sender in `config/initializers/devise.rb`
- Config your timezone accordingly in `application.rb`.

---

# CI

This base uses Github Actions by default as the CI tool.

## Github Actions Setup

There's no need to setup anything, just push your code and it will run the tests.

## CircleCI Setup

### Prerequisites

- Create a new project in CircleCI

### Setup

- run: `mv .circleci/config.yml.bak .circleci/config.yml`

---

# Deployment

## Deploy to AWS using Kamal

Kamal is a tool that helps you to deploy in any bare server, like the ones provided by aws, gcp, digital ocean, etc.
It uses docker + traefik + letsencrypt to provide a secure and easy to use environment.

### Prerequisites

#### Setup VM

```bash
# update linux
sudo apt update
sudo apt upgrade -y
# install and setup docker
sudo apt install -y docker.io curl git
sudo usermod -a -G docker ubuntu # change `ubuntu` to the username provided by your cloud provider

# Create directories + files necessary for traefik + letsencrypt management
sudo mkdir /letsencrypt
sudo touch /letsencrypt/acme.json
sudo chmod 600 /letsencrypt/acme.json
```

**important**: Make sure **http** and **https** ports are open.

#### Setup DNS

You need to have a domain name and point it to your server IP.
The server IP must be configured in `/config/deploy.yml` and `/config/deploy.staging.yml`.
So, access to your DNS manager, and create an A record pointing to your server IP.

#### Setup SSL

There's no need to setup SSL certificates, traefik will do it for you.

#### Setup the container registry

You need to have a container registry to push your images.
You can use [AWS ECR](https://aws.amazon.com/ecr/).

#### Setup AWS secrets

You need to setup the secret manager in AWS, and add the following secrets:
There are 2 secret groups, one for `staging` and one for `production`.
The secrets are the same, but the values are different.
By default the secret groups names are:

- `staging/RailsApi`
- `production/RailsApi`

If you want to use different names, you can change them in [`.env.erb`](.env.erb) and [`.env.staging.erb`](.env.staging.erb).

The secrets are:

- `SERVER_HOST` (the server IP to deploy to)
- `JWT_SECRET` (the secret used to sign JWT tokens)
  - You can generate one with `bin/rails runner "puts SecureRandom.hex(32)"`
- `FRONTEND_URL` (the frontend url)
- `MAILER_SENDER` (the email sender, e.g. `info@rails-api.com`)
- `DATABASE_URL` (the database url, e.g. `postgresql://user:password@somehost:5432/dbname`)
- `REDIS_URL` (the redis url, e.g. `redis://user:password@somehost:6379/0`)
- `S3_ACCESS_KEY_ID` (the s3 access key id)
- `S3_ACCESS_KEY` (the s3 access key)
- `S3_REGION` (the s3 region)
- `S3_BUCKET` (the s3 bucket)
- `SIDEKIQ_PASSWORD` (the sidekiq password)
- `SIDEKIQ_REDIS_URL` (the sidekiq redis url. This can be the same as the `REDIS_URL`)

#### \[OPTIONAL\] Create a VM for remote docker image building

Create a new VM in your cloud provider, and run:

```bash
sudo apt update
sudo apt upgrade -y
# install and setup docker
sudo apt install -y docker.io curl git
sudo usermod -a -G docker ubuntu # change `ubuntu` to the username provided by your cloud provider
```

Then change `config/deploy.yml` and `config/deploy.staging.yml` to [build in that VM IP](https://kamal-deploy.org/docs/configuration).

### Setup local environment for deploying from your machine

#### Install necessary tools

```bash
gem install kamal
brew install docker
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /
```

#### Log in to awscli

```bash
aws configure # enter your credentials
```

#### Setup SSH keys

```bash
ssh-add /path/to/your/key.pem
```

#### Add necessary env variables

Add to your `.env` file

```bash
AWS_ACCOUNT_ID=your_account_id
AWS_REGION=your_region
```

### Deploy

#### Deploy to `staging`

```bash
kamal envify -d staging
kamal deploy -d staging
```

#### Deploy to `production`

```bash
kamal envify
kamal deploy
```

## Deploy to Heroku

The repository is already configured to deploy to Heroku.

The cost of deploying this to heroku is **18 USD/month**.

### Heroku configuration files

- [app.json](app.json) with the following configuration:

  - The app name: `rails-api`
  - The app description: `A minimal ruby on rails api`
  - Add-ons:
    - Heroku Postgres **(mini, 5 USD/month)**
    - Heroku Redis **(mini, 3 USD/month)**
    - Papertrail **(choklad, 0 USD/month)**
  - Dynos:
    - web
      - command: `bin/rails s -p $PORT:-3000 -e $RAILS_ENV:-development`
      - size: `Basic` **(5 USD/month)**
    - worker
      - command: `bin/sidekiq -e $RAILS_ENV:-development`
      - size: `Basic` **(5 USD/month)**
  - Buildpacks:
    - Apt (uses the file `Aptfile` to install native packages)
    - heroku/ruby (ruby)

- [Procfile](Procfile) with the following configuration:

  - web: `bin/rails s -p ${PORT:-3000} -e ${RAILS_ENV:-development}`
  - worker: `bin/sidekiq -e ${RAILS_ENV:-development}`
  - release: [release.sh](release.sh)

- [Aptfile](Aptfile) (used by apt buildpack) with the following packages:
  - libvips-dev
  - libvips-tools
  - libvips42
  - libglib2.0-0
  - libglib2.0-dev
  - libjpeg-turbo8-dev
  - libpng-dev
  - libtiff-dev
  - giflib-tools
  - libwebp-dev
  - libpoppler-dev

# CD

## CD to AWS using Kamal

Because of stability issues, continuous deployment with kamal when merging a PR is not recommended.

There's a Github Actions workflow which is triggered by [Manual Dispatch](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#workflow_dispatch) and it will deploy to [staging](.github/workflows/deploy-staging.yml)/[production](.github/workflows/deploy-production.yml) with the selected branch.

## Setup secrets

Head over to repository -> actions -> secrets and add the following secrets:

### Staging secrets

- `DOCKER_REMOTE_BUILDER_IP` (only if you have a remote docker image builder)
- `DOCKER_REMOTE_BUILDER_PRIVATE_KEY` (only if you have a remote docker image builder)
- `SSH_STAGING_PRIVATE_KEY` (the private key to connect to your staging server)
- `AWS_ACCESS_KEY_ID` (the aws access key id to connect to your staging server)
- `AWS_SECRET_ACCESS_KEY` (the aws secret access key to connect to your staging server)
- `AWS_REGION` (the aws region to connect to your staging server)

### Production secrets

- `DOCKER_REMOTE_BUILDER_IP` (only if you have a remote docker image builder)
- `DOCKER_REMOTE_BUILDER_PRIVATE_KEY` (only if you have a remote docker image builder)
- `SSH_PRODUCTION_PRIVATE_KEY` (the private key to connect to your production server)
- `AWS_ACCESS_KEY_ID` (the aws access key id to connect to your production server)
- `AWS_SECRET_ACCESS_KEY` (the aws secret access key to connect to your production server)
- `AWS_REGION` (the aws region to connect to your production server)

### Notes

The Github Action to deploy with kamal is flaky, if you see an error that SSH was blocked, try re-running the workflow a couple of times until it passes.

## CD to Heroku

Go to Heroku and setup the app to auto-deploy from the `main` branch, and make sure to enable the option `Wait for CI to pass before deploy`.
