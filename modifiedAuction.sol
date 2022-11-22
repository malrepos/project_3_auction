// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract Auction {
    // the address of the auction winner
    address payable public beneficiary;
    // a limit on the auction period
    // can we display the end time as a date/time???
    uint256 public auctionEndTime;

    // owner can set a minimum bid
    uint256 public minimumBid;

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

    event Withdraw(address indexed bidder, uint256 amount);

    event Winner(address winner, uint256 amount);

    constructor(
        uint256 _biddingTime,
        address payable _beneficiary,
        uint256 _minimumBid
    ) {
        //why is the beneficiary set in the contructor????
        beneficiary = _beneficiary;
        // auction period is from the time the contract is deployed + a time period in seconds
        auctionEndTime = block.timestamp + _biddingTime;
        // owner sets the bid increment
        //bidIncrement = _bidIncrement;
        // owner sets the minimum bid amount
        minimumBid = _minimumBid;
        // the hash of ipfs storage of the NFT and metadata
    }

    // a modifier to prevent the owner from bidding on their own auction
    modifier onlyNotOwner() {
        require(
            msg.sender != beneficiary,
            "The owner cannot bid on their own Auction."
        );
        _;
    }

    // a modifier to prevent someone from bidding on a closed auction
    modifier onlyBeforeEndTime() {
        require(
            block.timestamp < auctionEndTime,
            "You are too late. The auction is over."
        );
        _;
    }

    modifier onlyAfterEndTime() {
        require(
            block.timestamp > auctionEndTime,
            "You cannot withdraw your bid until the auction has ended"
        );
        _;
    }

    function bid() public payable onlyNotOwner onlyBeforeEndTime {
        // Do not allow 0 value bids.
        require(msg.value > 0, "You must make a valid bid.");
        // ensure each bid is higher than the minimum bid set by owner.
        require(
            msg.value >= minimumBid,
            "You bid must be equal to or higher than the the minimum bid."
        );
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

    // function withdraw() public payable returns(bool) {
    //     require(ended, "You cannot withdraw your bid until the auction has ended");
    //     uint amount = pendingReturns[msg.sender];
    //     if(amount > 0) {
    //         pendingReturns[msg.sender] = 0;
    //     }
    //     // what is !payable??
    //     if(!payable(msg.sender).send(amount)){
    //         pendingReturns[msg.sender] = amount;
    //         return false;

    //     }
    //     else
    //     return true;
    // }
    function withdraw() external onlyAfterEndTime {
        uint256 bal = pendingReturns[msg.sender];
        pendingReturns[msg.sender] = 0;
        payable(msg.sender).transfer(bal);

        emit Withdraw(msg.sender, bal);
        emit Winner(highestBidder, highestBid);
    }

    function getEndTime() public view returns (uint256) {
        return auctionEndTime;
    }

    function getHighestBidder() public view returns (address) {
        return highestBidder;
    }

    function minimumBidAmount() public view returns (uint256) {
        return minimumBid;
    }
}
