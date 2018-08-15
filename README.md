# Azure CLI Scripts and Getting Started Info

This repo contains Getting Started info on the Azure CLI, focusing on the [Azure Cloud Shell](https://shell.azure.com/) and some simple Bash scripting therein.

When it comes to automating Azure you have quite a few choices, but the _simplest_ way to do cross-platform Azure scripting [seems to be to use Azure CLI 2.0](https://stackoverflow.com/questions/45585000/azure-cli-vs-powershell) and Bash. That's the approach we take in this repo.

And we'll also focus on the simplest possible method of executing Bash scripts against the Azure CLI, namely the [browser-based Azure Cloud Shell](https://docs.microsoft.com/en-us/azure/cloud-shell/features).

## Initial Setup

The first time that you [launch the Azure Cloud Shell](https://docs.microsoft.com/en-us/azure/cloud-shell/overview) you'll be asked to configure a few things.

<details><summary>Details</summary>

- First, you'll choose the shell environment that you wish to use. We'll use **Bash** for the examples in this repo.

  ![Example Shell Selection Prompt](/images/cloudshell-001-welcome-set-shell.png)

- Next you will need to configure your storage account for persisting shell files.

  ![Example Shell Storage Setup](/images/cloudshell-002-storage.png)

- Once those two mandatory items are out of the way, you'll be welcomed to the Cloud Shell and presented with the command prompt. The next thing you should do is configure some shell environment options, so enter the command:

  ```bash
  az configure
  ```

  - The main recommendation is to set the default output format to `[3] table - Human-readable`. Here's an example:

    ![Example az configure command](/images/cloudshell-004-config.png)

</details>
