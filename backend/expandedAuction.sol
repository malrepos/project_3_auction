// SPDX-License-Identifier: MIT
pragma solidity >=0.8.10;

// import safeMath
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

interface IERC721 {
    function transferFrom(
        address from,
        address to,
        uint256 nftId
    ) external;
}

contract Auction {

    // use safeMath for our uint256 operations
    using SafeMath for uint256;

    event StartAuction();
    event Bid(address indexed sender, uint256 amount);
    event Withdraw(address indexed bidder, uint256 amount);
    event CloseAuction(address highestBidder, uint256 highestBid);

    //we're storing the NFT contract in our contract
    IERC721 public immutable nft;
    //this is the ID of the NFT
    uint256 public immutable nftId;

    constructor(
        address _nft,
        uint256 _nftId,
        uint256 _startingBid,
        uint256 _biddingTime
    ) {
        nft = IERC721(_nft);
        nftId = _nftId;
        //cast the msg.sender address as payable
        seller = payable(msg.sender);
        // set the current highet bid as the minimumBid to begin with
        // this is address(0)
        highestBid = _startingBid;

        auctionEndTime = block.timestamp + _biddingTime;
    }

    address payable public immutable seller;
    // we use a smaller uint to store a timestamp of the auction end time
    //uint32 public endAt;

    // we will store the state of the auction
    // started set to true when the auction starts
    bool public started;
    //ended set to true when the auction ends
    bool public ended;

    address public highestBidder;
    uint256 public highestBid;
    mapping(address => uint256) public bids;

    // we can set how long the auction lasts for
    uint256 public auctionEndTime;

    //the function to start the auction
    function startAuction() external {
        require(msg.sender == seller, "You are not the seller.");
        // we want to make sure this function can only be called once
        require(!started, "The auction has already been started.");
        started = true;
        //block.timestamp is uint256, so we need to cast it as uint32
        //endAt = uint32(block.timestamp + );

        // we want this contract to own the nft
        nft.transferFrom(seller, address(this), nftId);

        emit StartAuction();
    }

    function bid() external payable onlyNotOwner onlyBeforeEndTime {
        require(started, "The auction has not started.");
        //require(block.timestamp < endAt, "The auction has ended.");
        require(
            msg.value > highestBid,
            "This bid is lower than the current highest bid."
        );

        if (highestBidder != address(0)) {
        // using safeMath here to update our highestBidder value
            bids[highestBidder] = bids[highestBidder].add(highestBid);
        }

        highestBid = msg.value;
        highestBidder = msg.sender;

        emit Bid(msg.sender, msg.value);
    }

    function withdraw() external {
        // get the balance for the user who called the function
        uint256 bal = bids[msg.sender];
        //set the balance to 0 before sending any ether (to prevent reentrancy hack)
        bids[msg.sender] = 0;
        // transfer the ether to the user
        payable(msg.sender).transfer(bal);

        emit Withdraw(msg.sender, bal);
    }

    // anyone can end the auction when the timestamp has surpassed endAt
    // to transfer ownership of the NFT to the highest bidder
    // to transfer the highestBid to the seller
    function closeAuction() external payable onlyAfterEndTime {
        require(started, "The auction is not started yet");
        require(!ended);

        //set ended to true to ensure this function can only be called once
        ended = true;
        // if someone bid on the NFT
        // then transfer ownership of the nft to the highest bidder
        //and transfer the ether to the seller
        if (highestBidder != address(0)) {
            nft.transferFrom(address(this), highestBidder, nftId);
            seller.transfer(highestBid);
        } else {
            //if no one bid on the nft
            // transfer ownership of the NFT back to the seller
            nft.transferFrom(address(this), seller, nftId);

            emit CloseAuction(highestBidder, highestBid);
        }
    }

    // a modifier to prevent the owner from bidding on their own auction
    modifier onlyNotOwner() {
        require(
            msg.sender != seller,
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

    // a modifier to ensure a function is called only after the auction has ended
    modifier onlyAfterEndTime() {
        require(
            block.timestamp > auctionEndTime,
            "You cannot withdraw your bid until the auction has ended"
        );
        _;
    }

    function getEndTime() public view returns (uint256) {
        return auctionEndTime;
    }

    function getHighestBidder() public view returns (address) {
        return highestBidder;
    }
    
    function getNFTId() public view returns(uint256){
        return nftId;
    }

    function balanceOf() public view returns(uint) {
        return address(this).balance;
    }

    // function minimumBidAmount() view public returns(uint){
    //     return _startingBid;
    // }
}
