from web3 import Web3  # pip3 install web3
import solcx  # pip3 install py-solc-x
import os
import sys

web3 = Web3(Web3.HTTPProvider('http://127.0.0.1:4001'))

compiledContract = solcx.compile_files('incrementer.sol')
abi = compiledContract['incrementer.sol:Incrementer']['abi']
bytecode = compiledContract['incrementer.sol:Incrementer']['bin']

keystoreDir = '../data1/keystore/'
keystoreFiles = os.listdir(keystoreDir)
keystoreFiles = [f for f in keystoreFiles if os.path.isfile(keystoreDir + f)]

with open(keystoreDir + keystoreFiles[0]) as keyfile:
    privateKey = web3.eth.account.decrypt(keyfile.read(), 'fakepassword')
account_from = {
    'private_key': privateKey,
    'address': web3.eth.account.from_key(privateKey).address,
}

print(f'Attempting to deploy from account: {account_from["address"]}')
Incrementer = web3.eth.contract(abi=abi, bytecode=bytecode)
construct_txn = Incrementer.constructor(5).buildTransaction(
    {
        'from': account_from['address'],
        'nonce': web3.eth.get_transaction_count(account_from['address']),
    }
)
tx_create = web3.eth.account.sign_transaction(construct_txn, account_from['private_key'])
tx_hash = web3.eth.send_raw_transaction(tx_create.rawTransaction)
tx_receipt = web3.eth.wait_for_transaction_receipt(tx_hash)

print(f'Contract deployed at address: {tx_receipt.contractAddress}')

Incrementer = web3.eth.contract(address=tx_receipt.contractAddress, abi=abi)
number = Incrementer.functions.number().call()
print(f'Number value: {number}')

increment_tx = Incrementer.functions.increment(12).buildTransaction(
    {
        'from': account_from['address'],
        'nonce': web3.eth.get_transaction_count(account_from['address']),
    }
)
tx_create = web3.eth.account.sign_transaction(increment_tx, account_from['private_key'])
tx_hash = web3.eth.send_raw_transaction(tx_create.rawTransaction)
tx_receipt = web3.eth.wait_for_transaction_receipt(tx_hash)
print(f'Sent increment in tx: {web3.toHex(tx_receipt.transactionHash)} status: {tx_receipt.status}')

number = Incrementer.functions.number().call()
print(f'Number value: {number}')

if number != 5+12:
    print(f'Unexpected value returned by the deployed contract: {number}', file=sys.stderr)
    exit(9)
