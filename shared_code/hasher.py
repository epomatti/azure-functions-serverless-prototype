import hashlib

def digest(plaintext: str) -> str:
    encoded = plaintext.encode()
    hash_object = hashlib.sha256(encoded)
    return hash_object.hexdigest()