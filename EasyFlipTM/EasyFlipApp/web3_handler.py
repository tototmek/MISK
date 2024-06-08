# properties/web3_handler.py
from web3 import Web3

# Connect to local Ethereum node
web3 = Web3(Web3.HTTPProvider("http://127.0.0.1:8545"))

# Check if connected
if not web3.isConnected():
    raise Exception("Failed to connect to Ethereum node")

# Load contract ABI and address
contract_address = "YOUR_CONTRACT_ADDRESS"
contract_abi = "YOUR_CONTRACT_ABI"

property_manager = web3.eth.contract(address=contract_address, abi=contract_abi)
