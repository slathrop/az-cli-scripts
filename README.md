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

## Reference Materials

[Here](https://docs.microsoft.com/en-us/azure/cloud-shell/troubleshooting) is a very helpful article with details on making the most of Azure CLI and Cloud Shell.

## Scripting Ideas, Working With Others

You'll often want to write Azure CLI scripts that can be executed easily within either your _own_ Azure account or within the accounts of others (clients, partners, etc.).

If you're working with others, first have them:

- Login to their account on https://portal.azure.com and then

- Click on the `>_` icon in the upper-right

- If necessary for first-time setup, go through the steps listed above under [Initial Setup](#initial-setup)

- Finally, make sure that they have the Azure Cloud Shell open with the Bash environment selected (not PowerShell: see left side of Cloud Shell toolbar) and have them confirm their subscription:

  - `az account list`, and then if necessary, to set default subscription:

    ```bash
    az account set -s aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee
    ```

So with those preliminaries out of the way, you want to be able to essentially **copy-and-paste pre-scripted commands** into _Azure Cloud Shell_. How?

### Practical Copy-and-Paste

> Note that on Windows, **pasting** into Azure Cloud Shell uses a non-standard key sequence: `SHIFT+INSERT`. Other OSs can use the standard `CTRL+V`.

> If you have multiple commands for pasting, you'll find that embedded line feeds or carriage returns in your to-be-pasted text can be a problem. Solution below.

So a great way to do this **copy-and-paste thing** is to:

- Place all of your commands in a **Bash script** and

- Host your script somewhere on the Internet

- Use the `curl` command to pull down the script and stream it into the Bash command interpreter in the Azure Cloud Shell:

  ```bash
  # Run a script (without any command-line arguments) in Azure Cloud Shell
  bash <(curl -sL https://SOME-SCRIPT-LOCATION)
  ```

- You can make your script generic and remove customer details from it by accepting command-line arguments like this:

  ```bash
  # The bash "-s" option is necessary to tell bash to look at the piped stream from curl
  curl -sL https://SOME-SCRIPT-LOCATION | bash -s <YourCustomerDetails>
  ```

You can even cleanup a long URL for your script location (`https://SOME-SCRIPT-LOCATION`) by using a shortener service. For example, if your script is in GitHub a common shortening option is `git.io`, which you would use by running something like this:

```bash
curl -i https://git.io -F "url=https://SOME-SCRIPT-LOCATION" -F "code=your-short-path"
```

Which results in the ability to paste a command like this into the Azure Cloud Shell:

```bash
bash <(curl -sL https://git.io/your-short-path)
```
