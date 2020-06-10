# mb-prototype
Prototyping a modern serverless, segure and schemeless application.

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

Must read: [Azure Functions Python developer guide](https://docs.microsoft.com/en-us/azure/azure-functions/functions-reference-python)