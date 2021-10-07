pragma solidity ^0.6.2;
//import "diamonds.sol";

contract DiamondTracker {
    
    
    //  Create a setter for the id and a getter so that we can retrieve the id once it is set
    string id;
    
    function setId(string _serial) public {
        id = _serial;
    }
    
    function getId() public constant returns (string) {
        return id;
    }
    
    // create a data structure which can store the details about the diamond
    struct Diamond {
        string name;
        string cut;
        string miner;
        bool initialisedl; // needed to make sure that once initialised an item can't be created again
        
    }
    
    
    // we create a mapping to store diamond properties and retrieve them and 
    // we create a mappung which shows the relation between the diamon and the wallet 
    // based on the diamond's uuid -- universally unique identifier
    mapping(string => Diamond) private diamondStore;
    
    diamondStore[uuid] = Diamond(name, cut, miner, true);
    
    //This is used to make an assignment of a diamond to a specific wallet
    mapping(address => mapping(string => bool)) private walletStore;
    
    walletStore[msg.sender][uuid] = true;
    
    
    // We need to declare the different actions possible for a diamond in the supply chain
    // They can be mined ie created, they can be transfered and there have to be events which
    // prevent these from happening if something is fishy. 
    
    event DiamondCreate(address account, string uuid, string miner);
    event RejectCreate(address account, string uuid, string message);
    event DiamondTransfer(address from, address to, string uuid);
    event RejectTransfer(address from, address to, string uuid, string message);
    
    
    // We need to write the first function now; start with the create diamond function
    // use public function convention of _name for the parameter names
    // you can fix that later once it compiles.
    function CreateDiamond(string name, string cut, string uuid, string miner) {
        // check whether the diamond already exists
        
        if(diamondStore[uuid].initialised) {
            RejectCreate(msg.sender, uuid, "Diamond with this UUID already exists.");
            return;
        }
        diamondStore[uuid] = Diamond(name, cut, miner, true);
        walletStore[msg.sender][uuid] = true;
        DiamondCreate(msg.sender, uuid, miner);
        
    }


    //write the transfer function 
    function transferDiamond(address to, string uuid) {
     
        if(!diamondStore[uuid].initialised) {
            RejectTransfer(msg.sender, to, uuid, "No diamond with this UUID exists");
            return;
        }
     
        if(!walletStore[msg.sender][uuid]) {
            RejectTransfer(msg.sender, to, uuid, "Sender does not own this diamond.");
            return;
        }
     
        walletStore[msg.sender][uuid] = false;
        walletStore[to][uuid] = true;
        DiamondTransfer(msg.sender, to, uuid);
    }
    
    // By passing this function we can return the detials of any Diamond
    function getDiamondByUUID(string uuid) constant returns (string, string, string) {
 
    return (diamondStore[uuid].name, diamondStore[uuid].cut, diamondStore[uuid].miner);
}

    // By need to prove the ownership of an asset without looking at the transaction looking
    // this can be done with a helper function 
    
    function isOwnerOfDiamond(address owner, string uuid) constant returns (bool) {
        
        if(walletStore[owner][uuid]) {
            return true;
        }
        // else
        return false;
    }

    
    
    
    
}