# Outbid (working title)

## Developers

- Duc Long
- Matthew Chen
- Edafe Ogaga
- Malcolm Miller

---
## Demo 

![demo](/streamlit%20code/Images/demo.gif)

---
## Extra code inside modifiedAuction.sol added.
```
    function getNFTId() public view returns(uint256){
        return nftId;
    }

    function balanceOf() public view returns(uint) {
        return address(this).balance;
    }
```
---
## Key inputs and Steps (as shown in Demo)

1. Compile both `nftRegistry.sol` and `modifiedAuction.sol` contracts in Remix.

2. Deploy `nftRegistry.sol` contract.

3. update smart_contract_address in `.env`

4. streamlit run `nft.py`.

5. Owner of minted NFT itself must be the one of deploying the **auction** contact. (NFT owner and Auction Contract Seller must be the same).
6. When deploying `auction.sol` auction contract, both `minted token_ID` and `Smart Contract` address are required. (One auction contract for one NFT_ID sale)

7. update auction_contract_address in `.env`

8. Before auction contract ready, the owner of NFT must click `approve` to approve **its NFT_ID** together with **auction contract address** inside Remix Solidity `Smart Contract`.

9. Fresh re-start streamlit run `nft.py`

10. From front end, when auction contract is realy, Only onwer of NFT can `start` the auction, and time is counting down.
11. Any address can `close` the auction ONLY after auction time ended.
12. ...