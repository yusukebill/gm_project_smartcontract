pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal{
    uint totalWaves;
    // adding totalWavs variable here. 
    
    uint private seed;

    struct Wave{
        string message; // the message the user sent
        address waver; // the addrres of the user who waved
        uint timestamp; // the timestamp when the user waved
    }
    Wave [] waves;

    event NewWave(address indexed from, uint timestamp, string message);

    // this is an address=> uint mapping, meaning I can associate an address with an number. 
    // In this case, I will be storing the address w/ the last time the user waved at us. 
    mapping(address => uint) public lastWavedAt;


    constructor() payable {
        console.log("Yo yo. We have been constructed!");
    }

    function wave( string memory _message) public {
        require(lastWavedAt[msg.sender]+ 30 seconds < block.timestamp, "Must wait 30 seconds before waving again");
        lastWavedAt[msg.sender] =block.timestamp;

        totalWaves += 1;
        console.log("%s waved w/ message %s",msg.sender, _message);
        console.log("Got message: %s", _message);

        // this is where I actually store the wave data in the array.
        waves.push(Wave(_message,msg.sender,block.timestamp));

        uint randomNumber = (block.difficulty +block.timestamp +seed)% 100;
        console.log("Random # generated: %s", randomNumber);

        seed = randomNumber;

        if (randomNumber < 50){
            console.log("%s won!", msg.sender);
            //the same code we had to send the prize. 
        // former code therefore crossed
        
            uint prizeAmount = 0.0001 ether;
        //On the line above, I just initiate a prize amount. Solidity actually lets us use the keyword ether so we can easily represent monetary amounts. 

            require(prizeAmount <= address(this).balance, "Trying to withdraw more money than the contract has");
        
        //this line below is the magic line where we send money.
            (bool success,) = (msg.sender).call{value: prizeAmount}("");
            require(success,"Failed to withdraw money from contract");
            }
        emit NewWave(msg.sender, block.timestamp, _message);
    
        /*
        Use some magic here with msg.sender. 
        This is the wallet address of the person who called the function. This is awesome! 
        It’s like built in authentication. We know exactly who called the function 
        because in order to even call a smart contract function, you need to be connected with a valid wallet!
        */
        }
    
    function getAllWaves() view public returns (Wave[] memory) {
        return waves;
    }

    function getTotalWaves() view public returns (uint){
        return totalWaves;
    }

}
