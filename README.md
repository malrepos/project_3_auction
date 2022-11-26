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