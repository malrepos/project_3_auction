const auction = artifacts.require('auction.sol');

contract('auction', () => {
    it('Should deploy auction contract', async () => {
        const storage = await auction.new('0x1e68Dbbb300C73c0eDC0C735eD2855968cc1c65A', 42, 100, 120);
        //await storage.mint('0x5B38Da6a701c568545dCfcB03FcB875f56beddC4', 42);
        //const data = await storage.ownerOf(42);
    });
});