# Static-websites-with-Hugo

Creating a new website with Hugo with some hints

## What do we want to achieve?

> "I want to add or modify a page on a website. It should then be built automatically and published to my website."

## What do we need? (aka. )pre-requisites)

- local Docker installation
- GitHub account
- VisualStudio Code
   - Extensions: 

### GitHub repository

The GitHub repository contains everything we need for the static website. Most importantly the "code" for the individual pages. Markdown files will be used together with a theme to generate the final web pages. This process is done automatically by a GitHub action.

For local developing - or writing a web page - a Docker container is used to create the Hugo environment for building the website.

### Azure Static Web App

Hosting your website can be done on an Azure Static Web App.

> App Service Static Web Apps is a streamlined, highly efficient solution to take your static web app from source code to global high availability.
Static Web Apps serve pre-rendered files from a global footprint with no web servers required. Static Web Apps development is simple and versatile, designed with React, Angular, Vue, and more in mind. You can even include integrated serverless APIs from Azure Functions.

A connection to GitHub can be created automatically and a custom domain can be used.

## Let's get started

1. Create a GitHub Repository
2. Create an Azure Static Web App and connect it to the GitHub Repository
3. Clone the Repository locally
4. Add devcontainer configuration
5. pick a theme to start with
6. start the container and create the website

### add devcontainer configuration

From [Hugo Devconteiner](https://github.com/microsoft/vscode-dev-containers/blob/main/containers/hugo/README.md) add the ```.devcontainer```and ```.vscode``` folders and make some adjustments.

*Args will be passed in from the devcontainer file.*

<details>
<summary>Dockerfile</summary>

```Dockerfile
# Update the NODE_VERSION arg in docker-compose.yml to pick a Node version: 18, 16, 14
ARG NODE_VERSION=20
FROM mcr.microsoft.com/devcontainers/javascript-node:${NODE_VERSION}

# VARIANT can be either 'hugo' for the standard version or 'hugo_extended' for the extended version.
ARG VARIANT=hugo_extended
# VERSION can be either 'latest' or a specific version number
ARG VERSION

# Hugo dev server port
EXPOSE 1313

# [Optional] Uncomment this section to install additional OS packages you may want.
#
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends golang ca-certificates openssl git curl

# Install Hugo
RUN rm -rf /var/lib/apt/lists/* && \
    case ${VERSION} in \
    latest) \
    export VERSION=$(curl -s https://api.github.com/repos/gohugoio/hugo/releases/latest | grep "tag_name" | awk '{print substr($2, 3, length($2)-4)}') ;;\
    esac && \
    echo ${VERSION} && \
    wget -O hugo_extended_${VERSION}_linux-amd64.deb https://github.com/gohugoio/hugo/releases/download/v${VERSION}/hugo_extended_${VERSION}_linux-amd64.deb && \
    dpkg -i hugo_extended_${VERSION}_linux-amd64.deb

# [Optional] Uncomment if you want to install more global node packages
# RUN sudo -u node npm install -g <your-package-list-here>
```

</details>

<details>
<summary>devcontainer.json</summary>

```json
{
	"name": "Hugo (Community)",
	"build": {
		"dockerfile": "Dockerfile",
		"args": {
			// Update VARIANT to pick hugo variant.
			// Example variants: hugo, hugo_extended
			// Rebuild the container if it already exists to update.
			"VARIANT": "hugo_extended",
			// Update VERSION to pick a specific hugo version.
			// Example versions: latest, 0.73.0, 0,71.1
			// Rebuild the container if it already exists to update.
			"VERSION": "latest",
			// Update NODE_VERSION to pick the Node.js version: 12, 14
			"NODE_VERSION": "20"
		}
	},

	// Configure tool-specific properties.
	"customizations": {
		// Configure properties specific to VS Code.
		"vscode": {
			// Set *default* container specific settings.json values on container create.
			"settings": { 
				"html.format.templating": true
			},
			
			// Add the IDs of extensions you want installed when the container is created.
			"extensions": [
				"bungcip.better-toml",
				"davidanson.vscode-markdownlint"
			]
		}
	},

	// Use 'forwardPorts' to make a list of ports inside the container available locally.
	"forwardPorts": [
		1313
	],

	// Use 'postCreateCommand' to run commands after the container is created.
	// "postCreateCommand": "uname -a",

	// Set `remoteUser` to `root` to connect as root instead. More info: https://aka.ms/vscode-remote/containers/non-root.
	"remoteUser": "node"
}
```

</details>

### pick a theme

Well, this is probably the hardest part of the whole creation process. Fortunately the template can be changed easily later on. [Hugo Themes](https://themes.gohugo.io/) is a starting point for picking the theme/design you want to use.

Once you have decided for the theme ([HUGO RELEARN THEME](https://mcshelby.github.io/hugo-theme-relearn/index.html) in my case), grab the GitHub URL to continue with.

### create the website

Once the devcontainer has started, everything needed to work with Hugo is available.

[Create a site](https://gohugo.io/getting-started/quick-start/) will give you more information on how to create a site.

```bash
node ➜ /workspaces/Static-websites-with-Hugo/hugo-demo.hezser.de $ hugo server
Error: Unable to locate config file or config directory. Perhaps you need to create a new site.
       Run `hugo help new` for details.
```

That is correct. The Site needs to be created. My site will be created like this:

```bash
hugo new site "hugo-demo.hezser.de"
git submodule add https://github.com/McShelby/hugo-theme-relearn hugo-demo.hezser.de/themes/relearn
cd hugo-demo.hezser.de
echo "theme = 'relearn'" >> hugo.toml
```

That's it. Your new site has been created. Check it with ```hugo server``` from the devcontainer terminal.

## Links

- [Hugo DevContainer](https://github.com/microsoft/vscode-dev-containers/blob/main/containers/hugo/README.md)
