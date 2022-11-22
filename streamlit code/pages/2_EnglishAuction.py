import os
import json
from web3 import Web3
from pathlib import Path
from dotenv import load_dotenv
import streamlit as st


load_dotenv()

# Define and connect a new Web3 provider
w3 = Web3(Web3.HTTPProvider(os.getenv("WEB3_PROVIDER_URI")))

################################################################################
# Load_Contract Function
################################################################################


@st.cache(allow_output_mutation=True)
def load_contract():

    # Load the contract ABI
    with open(Path("./contracts/compiled/englishAuction_abi.json")) as f:
        contract_abi = json.load(f)

    # Set the contract address (this is the address of the deployed contract)
    contract_address = os.getenv("ENGLISH_AUCTION_CONTRACT_ADDRESS")

    # Get the contract
    contract = w3.eth.contract(
        address=contract_address,
        abi=contract_abi
    )

    return contract


# Load the contract
contract = load_contract()



    
    
st.markdown("---")

st.markdown("## Choose an account to start an auction")
accounts = w3.eth.accounts
nft_owneraddress = st.selectbox("Select Account", options=accounts)

st.markdown("## Start")
if st.button("Start the Auction"):

    contract.functions.start().transact({"from":nft_owneraddress})


st.markdown("---")

st.write("Choose an account to bid")

address = st.selectbox("Select Account to BID", options=accounts)
if st.button("Bid"):
    contract.functions.bid().transact({"from":address})


st.markdown("---")


st.markdown("## Current highestBid")
if st.button("highestBid"):
    highest_bid = contract.events.Bid().createFilter(fromBlock=0)
    reports = highest_bid.get_all_entries()
    for report in reports:
        report_dictionary = dict(report)
        amount = report_dictionary["args"]['amount']

            
        st.markdown(
            f"Bids : "
            f"{amount}")