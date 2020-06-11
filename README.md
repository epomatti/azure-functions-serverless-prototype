# mb-prototype

A sample app with serverless functions, NoSQL database, cloud encryption and infrastructure-as-code.

## Local develompent

_Required:_ [Azure Functions Core Tools](https://github.com/Azure/azure-functions-core-tools) and [Infrastructure](#Infrastructure) setup

Start here

```sh
. init.sh
```

Set environment variables in the `local.settings.json`

Start Functions locally

```sh
func host start
```

Load questions

```sh
curl localhost:7071/api/LoadQuestions
```

Post answers

```sh
curl --data "@shared_code/answers.json" http://localhost:7071/api/PostAnswers
```

Get answers

```sh
curl http://localhost:7071/api/GetAnswers?id=participant@mail.com
```

## Infrastructure

Create the infrastructure with `main.tf`. More info on how to setup Azure connectivity here: [Authenticating using a Service Principal](https://www.terraform.io/docs/providers/azurerm/guides/service_principal_client_secret.html)

```
terraform plan
terraform apply
```

### Local Development 


To setup the local environment an Application Registration is **required to be created manually**. (I didn't have the time yet to do it by scripts)

Procedure:

1. Go to Azure AD and create an Application Registration
2. Create a `Client Secret` for that app
3. Add the app credentials to the `local.settings.json` file
4. Go to the Key Vault and add an `Access Policy` for that application with KEY opertions `Get`, `Decrypt` and `Encrypt`

Keep in ming that this will not be tracked by Terraform and it will need to be recreated if `main.tf` is applied to the infrastructure (it will remove the app).

Terraform is declarative, meaning that "if else" is not an option so I'm leaving it manual for now.

## Sources

[Azure Functions Python developer guide](https://docs.microsoft.com/en-us/azure/azure-functions/functions-reference-python) (must read)

[azure-keyvault-keys](https://pypi.org/project/azure-keyvault-keys/)

[azure-identity](https://github.com/Azure/azure-sdk-for-python/tree/master/sdk/identity/azure-identity)
