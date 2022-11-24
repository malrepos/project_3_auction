# Outbid (working title)

## Developers

- Duc Long
- Matthew Chen
- Edafe Ogaga
- Malcolm Miller

## AUCTION 

![alt=""](images/Auction.png)

An auction is a sales event wherein potential buyers place competitive bids on assets or services either in an open or closed format. Auctions are popular because buyers and sellers believe they will get a good deal buying or selling assets. It usually involves the process of buying and selling goods or services by offering them up for bids, taking bids, and then selling the item to the highest bidder or buying the item from the lowest bidder.

When we hear of an auction our thoughts naturally gravitate to a lot of people in one room being engaged by the auctioneer. This still occurs till today for certain commodities. However, there are also quite a number of auctions conducted online via various platforms.

Pros of Auctions
- Seller controls process
- You can find rare items 
- Buy at a discount if allowed 
- Seller can maximize bargaining power 

Cons of Auctions
- Competitive process can deter some buyers
- Competitive bidding process can drive up price


![alt=""](images/traditional_auction.png)

Our project focuses on developing an online auction market where NFT's can be bought and sold.
This was created with various paramaters which allows for a trustworthy environment for users.

#### BACKEND
A smart contract was written in solidity to handle the auctions and the NFT's will be ERC tokens which contained steps -
- We defined the Pragma and contract
- We state the variables involved 
- Set up the Constructor 
- Create the Bid function (E.g Set a block to prevent the owner from bidding, block $0 value bids )
- Adding a withdrawal pattern (we opted for manual withdrawal rather than automatic as this proved the safest)
- Added a function to prevent bids from being withdrawn until the end of the auction


![alt=""](images/bid.png)


#### FRONTEND

Display relevant box, selection, buttons. For example 
- Input NFT address
- Input NFT ID
- Input bid Price
- Call current highestBid
- Call current hightestBidder
- St.write end time









### EVALUATION RESULTS 




![alt=""](images/sold.png)