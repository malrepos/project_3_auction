import os
import json
from web3 import Web3
from pathlib import Path
from dotenv import load_dotenv
import streamlit as st
from datetime import datetime


load_dotenv()

# Define and connect a new Web3 provider
w3 = Web3(Web3.HTTPProvider(os.getenv("WEB3_PROVIDER_URI")))

################################################################################
# Load_Contract Function
################################################################################


@st.cache(allow_output_mutation=True)
def load_contract():

    # Load the contract ABI
    with open(Path('./contracts/compiled/auction_abi.json')) as f:
        contract_abi = json.load(f)

    # Set the contract address (this is the address of the deployed contract)
    contract_address = os.getenv("AUCTION_CONTRACT_ADDRESS")

     # Get the contract
    contract = w3.eth.contract(
        address=contract_address,
        abi=contract_abi
    )

    return contract


# Load the contract
contract = load_contract()



    

st.markdown("---")
st.markdown("## Current Highest Bid")
if st.button("Check Bidding History"):
    highest_bid = contract.events.highestBidIncreased().createFilter(fromBlock=0)
    reports = highest_bid.get_all_entries()
    for report in reports:
        report_dictionary = dict(report)
        amount = report_dictionary["args"]['amount']

            
        st.markdown(f"Bids :{amount}")

st.markdown("---")

st.markdown("## Select Account and Bid Amount")
st.write("Choose an account to bid")
accounts = w3.eth.accounts
address = st.selectbox("Select Account to BID", options=accounts)
bid_amount = st.number_input("Bid Amount", value=100, step=1)

if st.button("Bid"):
    contract.functions.bid().transact({'from':address, 'value':bid_amount})
    st.write(f"Your bid was: {bid_amount} WEI.")
st.markdown("---")



st.markdown("## Auction End Time")
if st.button("Check Auction Time"):
    timestamp = contract.functions.getEndTime().call()
    dt_object = datetime.fromtimestamp(timestamp)
    now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    
    st.write(f"Auction End :  {dt_object}")
    st.write(f"Current Time: {now}")

st.markdown("---")
st.markdown("## Highest Bidder")

if st.button("Check Highest Bidder Address"):
    highestBidder_address = contract.functions.getHighestBidder().call()

    st.write(f"Highest Bidder Address: {highestBidder_address}")


st.markdown("---")
st.markdown("## Winner Bid")
# Events to be do by backend.
#if st.button("Check Winner Address"):
#    winner = contract.events.auctionEnded().createFilter(fromBlock=0)
#    reports = winner.get_all_entries()
    #for report in reports:
    #    report_dictionary = dict(report)
    #    amount = report_dictionary["args"]['amount']

            
#    st.markdown(f"Bids :{reports}")
