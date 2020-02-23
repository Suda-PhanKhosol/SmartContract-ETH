pragma solidity >=0.4.22 <0.6.0;

contract KurokoCharacter {
    
    struct KuroCharacter{
        uint id;
        string name;
        uint256 priceTag;
        address owner;
        string imagePath;
        bool haveOwner;
    }
    
    uint K_ID = 0;
    
    uint[] collectionCharaterId;
    mapping (uint => KuroCharacter) kCharacter;
    event PurchaseCharacterErrorLog(address indexed buyer,string reason);
    event SoldCharacter(address indexed buyer,uint id);

    
    function addCharacter(string memory name,uint256 priceTag ,string memory imagePath) public returns(uint id){
        uint Id = K_ID++;
        
        kCharacter[Id] = KuroCharacter(Id,name, priceTag, address(0x0000000000000000000000000000000000000000), imagePath,false);
        collectionCharaterId.push(Id);
        
        return Id;
    }
    
    function sellCharacter(uint id) public payable returns(bool){
        if(msg.value != kCharacter[id].priceTag){
            emit PurchaseCharacterErrorLog(msg.sender,"Error, invalid value !!");
            msg.sender.transfer(msg.value);
            return false;
        }
        
        if(kCharacter[id].haveOwner){
            emit PurchaseCharacterErrorLog(msg.sender,"Error, this character is have owner!!");
            msg.sender.transfer(msg.value);
            return false;
        }
        
        kCharacter[id].owner = msg.sender;
        kCharacter[id].haveOwner = true;
        emit SoldCharacter(msg.sender,id);
        
        return true;
    }
    
    function getChracterById(uint Id) public view returns(uint,string memory,uint256,address,string memory,bool){
        return (kCharacter[Id].id,kCharacter[Id].name,kCharacter[Id].priceTag,kCharacter[Id].owner,kCharacter[Id].imagePath,kCharacter[Id].haveOwner);
    }
    
    function getAllCharacter() public view returns(uint[] memory){
        return collectionCharaterId;
    }
    
    function getNextValId() public view returns(uint){
        return K_ID;
    }
    
}






