cp local.settings.development.json local.settings.json
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt