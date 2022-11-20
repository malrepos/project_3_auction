pragma solidity >=0.7.0 <0.9.0;

contract Auction {
    // the address of the auction winner
    address payable public beneficiary;
    // a limit on the auction period
    // can we display the end time as a date/time???
    uint256 public auctionEndTime;

    // current state of the auction
    address public highestBidder;
    uint256 public highestBid;
    bool ended;

    // mapping the addresses to their bids
    mapping(address => uint256) pendingReturns;

    // event fired when the highest bid increases
    event highestBidIncreased(address bidder, uint256 amount);
    // event fired detailing the auction winner and bid amount
    event auctionEnded(address winner, uint256 amount);

    //should a new auction be deployed by a function, and not the deployment of a new contract???

    constructor(uint256 _biddingTime, address payable _beneficiary) {
        //why is the beneficiary set in the contructor????
        beneficiary = _beneficiary;
        // auction period is from the time the contract is deployed + a time period in seconds
        auctionEndTime = block.timestamp + _biddingTime;
    }

    // function for bidding

    function bid() public payable {
        require(block.timestamp < auctionEndTime, "This auction has ended.");
        // check if the new bid is higher than the highest bid
        if (msg.value > highestBid) {
            // check if the bidder has already made a bid
            if (pendingReturns[msg.sender] > 0) {
                uint256 amount = pendingReturns[msg.sender];
                //transfer back the previous bid amount to the msg.sender
                payable(msg.sender).transfer(amount);
            }
            pendingReturns[msg.sender] = msg.value;
            highestBidder = msg.sender;
            highestBid = msg.value;
            emit highestBidIncreased(msg.sender, msg.value);
        } else {
            revert("Your bid is not high enough. Try again.");
        }
    }

    // function to withdraw funds to the owners
    // user calls the function???????
    function withdraw() public payable returns (bool) {
        require(
            ended,
            "You cannot withdraw your bid until the auction has ended"
        );
        uint256 amount = pendingReturns[msg.sender];
        if (amount > 0) {
            pendingReturns[msg.sender] = 0;
        }
        // what is !payable??
        if (!payable(msg.sender).send(amount)) {
            pendingReturns[msg.sender] = amount;
            return false;
        } else return true;
    }

    // why is this a function? Why would a user call this??
    function auctionEnd() public {
        require(
            block.timestamp > auctionEndTime,
            "This auction has not ended."
        );
        if (ended) revert("This auction has ended.");

        ended = true;
        emit auctionEnded(highestBidder, highestBid);
        beneficiary.transfer(highestBid);
    }
}
// This contract is modified from the following tutorial:
//https://coinsbench.com/solidity-for-developers-decentralized-auctions-abb1be8fe72
