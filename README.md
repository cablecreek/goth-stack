# GoTH Stack - AWS Lambda Starter

## Intro
Deploy a **G**o + **T**ailwind + **H**TMX (GoTH) Stack to AWS Lambda. 

This repo is intended to be used as a starter project. It aims to provide a foundation to quickly create UIs with the familiarity of Go, web-frameworks, and minimal JS.

The project is a batteries included webapp:
1. Go `echo` webframework
2. Templating with `templ`
3. hot reload with `air`
4. convinant commands for local `dev`, `build`, `deploy` commands

Use cases:
- Rapid Prototyping and POCs
- Short-lived apps
- Server-Side Dynamic (SSD) Apps

## Quickstart
```bash
# clone this repo 
git clone https://github.com/cablecreek/goth-stack.git
# or 
git clone git@github.com:cablecreek/goth-stack.git

cd ./goth-stack

# init the environment
task init

# run locally at http://localhost:3000
task dev

# build
task build

# deploy
task deploy

```

## Requirements:
- Go
- Terraform
- AWS CLI
- Node.js + npm (for Tailwind download and bundling)
- podman or docker cli
- Task (go-task) installed and on your `PATH` 
- Unix-like system (paths are Unix-style)
- Ensure you are logged in with the aws cli `aws sso login`

## Usage
### setup the environment 
```bash

# list all available tasks
task

# once: install tooling (air, templ, tailwind, terraform init)
task init

```
### default values
check the `vars` in the `Taskfile.yaml`   are as expected

```yaml
# Edit these!
vars:
  APP_NAME: my-app 
  AWS_REGION: us-east-1
  PROFILE: default # aws soo profile
  CONTAINER_TOOL: podman # podman or docker

```
### run the dev server

```bash
task dev
```
- live reload on `http://localhost:3000`
- air watches for files for changes and rebuilds and refreshed the browser
- the app is also on `http://localhost:8080` if you don't want the browser refresh

### build and run
```bash
task build
task run
```
- running at `http://localhost:8080`

### Deploy to AWS
Infrastructure lives in `infra/` and is managed with Terraform.

```bash
# deploy to AWS (Lambda + API Gateway + ECR)
task deploy

# destroy
task destroy

```

7. ensure you keep your terraform state files safe!
  - if you want to keep them as part of your repo, modify the gitignore

## Extending the codebase
Generally the pattern is:
  1. handler
  2. view/template (w/htmx & tailwind)
  3. endpoint 
  4. render (helpers and render wrappers)

## Reading
Read about the technoligies found in the stack
- [htmx](https://htmx.org/)
- [tailwind](https://tailwindcss.com/)
- [templ](https://github.com/a-h/templ)
- [echo](https://github.com/labstack/echo)
- [air](https://github.com/air-verse/air)


## Limitations
- High Freq of Request: HTMX calls the server (AWS Lambda) with every request, it is therefore not intended for apps with high request rates. 

## Considerations / TODO
- [ ] air builds also for hot reload. consolidate or seperation of concerns
- [ ] locality of behviour, could the handlers and views occupy the same space?
- [ ] favicon.ico 404 with `task dev`
- [ ] layer and package cacheing
