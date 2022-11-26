The backend is made up of two contracts. First, the NFT contract. This allows a user to mint an NFT, among other functions, and is used by us to create an NFT that we can use in our auction contract.

### Deploying and Testing in Remix

First we deploy our nft.sol contract. On deployment of this contract we go into the contract and mint an NFT. We choose our address, in this case the first address in our Remix list of addresses, and input a NFT ID, in this case we choose 42 (we can choose any number).

![Deploying our NFT contract]()

Second, we deploy our Auction.sol contract. Within the constructor of our auction contract there are a few parameters we need to input.
In the address field we enter the address of the nft.sol contract which can be copied at the right of the deployed nft contract. We enter the ID of the NFT that we entered earlier (42).
We enter a startingBid which essentially acts as a minimum bid that must be exceeded by subsequent bidders. The startingBid is denominated in wei.
Finally, we enter a "biddingTime" which is the duration, in seconds, of our auction.
Hit transact and our auction contract is deployed.

![Deploying our Auction Contract]()

Our auction contract will take ownership of the NFT we will be selling. As such, we the owner of the NFT need to approve this transfer. Back in the deployed nft.sol, we go to the Approve function, copy the address of the auction.sol contract and paste it into the address field, and enter the NFT ID (42).
Our contract is now approved to take ownership of the NFT.

![Approving Transfer of the NFT to our Auction Contract]()

Now we can begin. We start the auction by clicking the "startAuction" function. The address used when starting the auction must be the same one used when deploying the contract - in other words, the seller must start the auction.

![Start the Auction]()

Users are now able to bid. First, choose the second address in our address list as the owner of the auction contract cannot make bids. Put a value in the "Value" field. Ensure it is higher than the startingBid we set when we deployed the contract. Click "Bid" to make the bid.

Choose another address and repeat the process with yet a higher bid.

![User Makes a Bid]()

---

We can now check some of the variables in our contract.

At the bottom of our function list, we fist click "started". This function checks if the contract has started, and as of course it has, the value returned is the boolean "true".

The "seller" function returns the address of the seller. We can see that it matches the first address in our list, the address used to deploy the contracts.

The "nftId" function returns the id we entered when deploying our nft contract and auction contract. In this case it is "42".

The "nft" function returns the address of our nft.sol contract, the original owner of the nft.

The highestBidder shows the address of the highest bidder. The highestBid shows the value of the highest bid.

We can also check the bids based on an entered address. We copy the address from our list and the function returns the highest value bid of that user.

![Checking Contract Variables]()

Finally, provided the duration of the auction has expired, we can click on the endAuction function. This function will transfer ownership of the nft to the highest bidder, and transfer the highestBid to the owner of the auction.

We can check the current owner of the nft by returning to the nft.sol contract, and at the ownerOf function, enter the nftId, and return the address of the owner. This will display the new owner which we can compare with our address list.

![New NFT Owner Address]()

The unsuccessful bidders can now withdraw their ether. Set the address to the address of the bidder and click the withdraw function.

Our auction has ended. Ownership of the NFT has been transferred to the highest bidder. The seller has received the value in wei of the highest bid. Unsuccessful bidders have withdrawn their ether.
