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

To setup the infrastructure run the Terraform configuration `main.tf`

```
terraform plan
terraform apply
```

More info on how to setup Azure connectivity here: [Authenticating using a Service Principal](https://www.terraform.io/docs/providers/azurerm/guides/service_principal_client_secret.html)

## Sources

[Azure Functions Python developer guide](https://docs.microsoft.com/en-us/azure/azure-functions/functions-reference-python) (must read)

[azure-keyvault-keys](https://pypi.org/project/azure-keyvault-keys/)

[azure-identity](https://github.com/Azure/azure-sdk-for-python/tree/master/sdk/identity/azure-identity)
