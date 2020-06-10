# mb-prototype


## Local develompent
Required: [Azure Functions Core Tools](https://github.com/Azure/azure-functions-core-tools)

Start the functions locally

```sh
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt

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

Get anwers

```sh
curl http://localhost:7071/api/GetAnswers?id=participant@mail.com
```

## Infrastructure

To setup the infrastructure run the Terraform configuration `main.tf`

```
terraform plan
terraform apply
```

More info at [Authenticating using a Service Principal](https://www.terraform.io/docs/providers/azurerm/guides/service_principal_client_secret.html)

## Sources

[Azure Functions Python developer guide](https://docs.microsoft.com/en-us/azure/azure-functions/functions-reference-python)

[azure-keyvault-keys](https://pypi.org/project/azure-keyvault-keys/)

[azure-identity](https://github.com/Azure/azure-sdk-for-python/tree/master/sdk/identity/azure-identity)
