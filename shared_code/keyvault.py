from azure.identity import DefaultAzureCredential
from azure.keyvault.keys import KeyClient
from azure.keyvault.keys.crypto import CryptographyClient, EncryptionAlgorithm
import os

def encrypt(text):
    uri = os.environ['KEYVAULT_URI']
    credential = DefaultAzureCredential()
    key_client = KeyClient(vault_url=uri, credential=credential)

    key = key_client.get_key("generated-key")
    crypto_client = CryptographyClient(key, credential=credential)
    plaintext = text.encode()

    result = crypto_client.encrypt(EncryptionAlgorithm.rsa_oaep, plaintext)
    return result.ciphertext