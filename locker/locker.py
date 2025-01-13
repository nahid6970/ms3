import argparse
import os
from Cryptodome.Cipher import AES
from Cryptodome.Util.Padding import pad, unpad
from Cryptodome.Protocol.KDF import PBKDF2
from Cryptodome.Random import get_random_bytes
import getpass

# Function to derive a key from the password and salt
def derive_key(password, salt, key_length=32):
    kdf = PBKDF2(password.encode(), salt, dkLen=key_length)
    return kdf[:key_length]

# Function to encrypt files
def encrypt_file(input_file, password):
    try:
        with open(input_file, 'rb') as file:
            plaintext = file.read()
            salt = get_random_bytes(16)
            key = derive_key(password, salt)
            cipher = AES.new(key, AES.MODE_EAX)
            ciphertext, tag = cipher.encrypt_and_digest(plaintext)

        encrypted_file_path = input_file + ".enc"
        with open(encrypted_file_path, 'wb') as enc_file:
            enc_file.write(salt)
            enc_file.write(tag)
            enc_file.write(cipher.nonce)
            enc_file.write(ciphertext)

        print(f"File encrypted successfully: {encrypted_file_path}")
    except Exception as e:
        print(f"Error: {str(e)}")

# Function to decrypt files
def decrypt_file(input_file, password):
    try:
        with open(input_file, 'rb') as enc_file:
            salt = enc_file.read(16)
            tag = enc_file.read(16)
            nonce = enc_file.read(16)
            ciphertext = enc_file.read()

            key = derive_key(password, salt)
            cipher = AES.new(key, AES.MODE_EAX, nonce=nonce)
            plaintext = cipher.decrypt_and_verify(ciphertext, tag)

        decrypted_file_path = os.path.splitext(input_file)[0]
        with open(decrypted_file_path, 'wb') as dec_file:
            dec_file.write(plaintext)

        print(f"File decrypted successfully: {decrypted_file_path}")
    except Exception as e:
        print(f"Error: {str(e)}")

# Main function
def main():
    parser = argparse.ArgumentParser(description="File Encryptor/Decryptor")
    parser.add_argument("--encrypt", help="Path to the file to encrypt", type=str)
    parser.add_argument("--decrypt", help="Path to the file to decrypt", type=str)

    args = parser.parse_args()

    if args.encrypt:
        password = getpass.getpass("Enter password: ")
        encrypt_file(args.encrypt, password)
    elif args.decrypt:
        password = getpass.getpass("Enter password: ")
        decrypt_file(args.decrypt, password)
    else:
        print("Error: Specify --encrypt or --decrypt followed by the file path")

if __name__ == "__main__":
    main()
