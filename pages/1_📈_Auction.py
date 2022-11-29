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
# Load Contract Function
################################################################################


@st.cache(allow_output_mutation=True)
def load_contract():

    # Load the contract ABI
    with open(Path('./backend/compiled/modifiedAuction_abi.json')) as f:
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

################################################################################
# Auction Information
################################################################################


# if st.button("Check Auction Time"):
timestamp = contract.functions.getEndTime().call()
dt_object = datetime.fromtimestamp(timestamp)
now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
st.write(f"Auction will end at:  {dt_object}")
#st.write(f"Current Time: {now}")
#min_bid = contract.functions.minimumBidAmount().call()
#st.write(f"Auction minimum bid amount:  {min_bid} WEI")

################################################################################
# Initiate bidding reportss
################################################################################
bidding = contract.events.Bid().createFilter(fromBlock=0)
bid_reports = bidding.get_all_entries()


################################################################################
# Auction Status
################################################################################
st.markdown("## Auction Status")

# this is a mock-up code only:
# call the 'ended' (boolean) function from contract
# if ended = True, then write auction ended, return wining address and winning bid price
# id ended = False, then write 'auction ends in {end time - now}. the highest bid is {highestBid}'


if st.button("Auction status"):
    # ended = contract.functions.withdraw().call()
    # ended = datetime.now() - timestamp
    import time
    ended = timestamp - int(time.time())

    if ended < 0:
        # highestBidder_address = bid_reports[-1]["args"]["sender"]
        st.error(
            f"Auction ended.") # Winning Bidder Address: {highestBidder_address}")
    else:
        highest_bid = bid_reports[-1]["args"]["amount"]
        st.write(
            f"Auction ends in **{ended}** seconds. The current highest bid is {highest_bid} Wei.")



    # display current contract eth balance 
    balance = contract.functions.balanceOf().call()
    st.metric("Auction Contract Balance (Wei)", f'{balance}')

################################################################################
# Bid History
################################################################################

st.markdown("---")

col1, col2 = st.columns(2)

with col1:

    st.markdown("## Bid History ")

    bidding = contract.events.Bid().createFilter(fromBlock=0)
    bid_reports = bidding.get_all_entries()
    for report in bid_reports:
        report_dictionary = dict(report)
        amount = report_dictionary["args"]['amount']
        bidder = report_dictionary["args"]['sender']
        st.markdown(
            f"{bidder[:5]}.....{bidder[-5:]} : {amount} Wei")

################################################################################
# Withdrawal History
################################################################################

with col2:

    st.markdown("## Withdrawal History")
    withdrawals = contract.events.Withdraw().createFilter(fromBlock=0)
    withdraw_reports = withdrawals.get_all_entries()

    for report in withdraw_reports:
        report_dictionary = dict(report)
        bidder = report_dictionary["args"]["bidder"]
        amount = report_dictionary["args"]["amount"]
        st.markdown(
            f"{bidder[:5]}.....{bidder[-5:]} : {amount} Wei")


################################################################################
# Start Auction
################################################################################
accounts = w3.eth.accounts

st.sidebar.markdown("## Start Auction")

seller_address = st.sidebar.selectbox(
    "Only NFT owner can start an auction:", options=accounts)

# msg.sender call startAuction() to start auction

nft_id = contract.functions.getNFTId().call()

if st.sidebar.button("Start"):
    contract.functions.startAuction().transact({'from': seller_address})
    st.sidebar.success(f"Auction has started fro NFT ID {nft_id}!", icon="✅")

st.sidebar.markdown("---")


################################################################################
# Bidding function
################################################################################

# st.markdown("---")

st.sidebar.markdown("## Select Account and Bid Amount")
st.sidebar.write("Choose an account to bid")

address = st.sidebar.selectbox("Select Account to BID:", options=accounts)
bid_amount = st.sidebar.number_input("Bid Amount (Wei):", value=100, step=1)

if st.sidebar.button("Bid"):
    contract.functions.bid().transact({'from': address, 'value': int(bid_amount)})
    st.sidebar.success(f"Your bid was: {bid_amount} Wei.", icon="✅")

st.sidebar.markdown("---")

################################################################################
# Withdraw function
################################################################################

st.sidebar.markdown("## Withdraw unsucessful bids")

withdraw_address = st.sidebar.selectbox(
    "Select Account to withdraw:", options=accounts)


if st.sidebar.button("Withdraw"):
    contract.functions.withdraw().transact({'from': withdraw_address})

    st.sidebar.success(
        f'You have succefully withdrawn {amount} Wei!', icon="✅")


st.sidebar.markdown("---")

################################################################################
# Contract End - collect NFT function
################################################################################

# highestBidder get NFT, at the same time,
# seller get highest bid amount.

st.sidebar.markdown("## Close Aucntion after End Time")
st.sidebar.markdown("### note: any address can close auction")

if st.sidebar.button("Close Auction"):
    # because "any address" can call closeAuction() function. "withdraw_address" is applied.
    contract.functions.closeAuction().transact({'from': withdraw_address})
    
    # get nftId
    nft_id = contract.functions.getNFTId().call()

    # get highest bidder address
    highestBidder_address = contract.functions.getHighestBidder().call()

    st.sidebar.success(
        f'{highestBidder_address} have succefully collected NFT ID: {nft_id}!', icon="✅")
    
    
    #if withdraw_address == highestBidder_address:
    #    contract.functions.withdraw().transact({'from': withdraw_address})

    #else:
    #    st.sidebar.error(
    #        'You are not the highest bidder', icon="❌")

st.sidebar.markdown("---")



################################################################################
# Highest bidder
################################################################################

st.markdown("---")
st.markdown("## Highest Bidder")

if st.button("Click"):
    highestBidder_address = contract.functions.getHighestBidder().call()

    highest_bid = bid_reports[-1]
    highest_amount = highest_bid["args"]["amount"]

    second_highest_bid = bid_reports[-2]
    second_highest_amount = second_highest_bid["args"]["amount"]

    incremental = highest_amount - second_highest_amount

    st.metric(f"{highestBidder_address}",
              f"{highest_amount}", f"{incremental}")


st.markdown("---")


