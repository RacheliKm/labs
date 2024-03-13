/*storage
pragma solidity >=0.7.0 <0.9.0;
// @title Storage
// @dev Store & retrieve value in a variable
contract Storage{
    uint256 number;
    // @dev Store value in variable
    //@param num value to store
    function store(uint256 num) public {
        number=num;
    }
    //@dev return value 
    //@return value of 'number'
    function retrieve() public  view  returns (uint256){
        return number;
    }
}
\
/*owner
// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;
//@title Owner
//@dev Set & change owner
contract Owner{
    address private  owner;
//wwhat is EVM?
event OwnerSet(address indexed  oldOwner, address indexed neOwner);
//cheacking if the caller was the owner
modifier isOwner(){
    //cheacking if the function called correctly 
    //If the first argument of 'require' evaluates to 'false',the secend argument is returned 
    require(msg.sender == owner,"caller is not owner");
    _;
}
constructor(){
    owner = msg.sender;
    emit OwnerSet(address(0), owner);
}
//@dev Change owner
// @param newOwner address of new owner
function changeOwner(address newOwner) public  isOwner{
    emit OwnerSet(owner, newOwner);
    owner = newOwner;
}
// @dev Return owner address
  // @return address of owner
  function getOwner() external  view returns (address){
    return owner;
  }
}
/*ballot
// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;
   //@title Ballot
    //@dev Implements voting process along with vote delegation
    contract Ballot {
        struct Voter {
            uint weight;
            bool voted;
            address delegate;
            uint vote;
        }
        struct Proposal {
            bytes32 name;
            uint voteCount;
        }
        address public chairperson;
        mapping(address => Voter) public voters;
        Proposal[] public proposals ;
       // @dev Create a new ballot to choose one of 'proposalNames'
       //@param proposalNames names of proposals
       constructor(bytes32[] memory proposalName) {
           chairperson = msg.sender ;
           voters[chairperson].weight = 1;
           for (uint i = 0; i < proposalName.length; i++) {
             //the pus is to the end of the 'proposals'
                proposals.push(Proposal({
                    name: proposalName[i] ,
                    voteCount: 0 
                    }));
           }
       }
       //@dev Give 'voter' the right to vote on this ballot. May only be called by 'chairperson'.
       //@param voter address of voter
function giveRifhtToVote(address voter) public {
    require(
        msg.sender == chairperson, "Only chairperson can give right to vote" );
        require(voters[voter].weight == 0);
        voters[voter].weight = 1;
}
function delegate(address to) public  {
    Voter storage sender = voters[msg.sender];
    require(!sender.voted, "You already voted" );
    require(to != msg.sender, "Self-delegation is disallowed");
    while (voters[to].delegate != address(0)) 
    {
        to = voters[to].delegate;
        require(to != msg.sender, "Found loop in delegation" );
    }
    sender.voted = true ;
    sender.delegate = to ;
    Voter storage delegate_ = voters[to];
    if(delegate_.voted) {
    // If the delegate already voted,
    // directly add to the number of votes
    proposals[delegate_.vote].voteCount += sender.weight;
    }
    else{
         // If the delegate did not vote yet,adding it to her weight
         delegate_.weight += sender.weight;
    }
}
// @dev Give your vote to proposal 'proposals[proposal].name'.
// @param proposal index of proposal in the proposals array
function vote(uint proposal ) public {
     Voter storage sender = voters[msg.sender];
     require(sender.weight !=0, "Has NO right to vote");
     require(!sender.voted, "Already voted");
     sender.voted = true;
     sender.vote = proposal;
     proposals[proposal].voteCount += sender.weight;
}
 //@dev cheacking the winning proposal -taking all previous votes into account.
     //@return winningProposal_ index of winning proposal in the proposals arra
     function winningProposal() public view returns (uint winningProposal_)
     {
        uint winningVoteCount = 0;
        for (uint p = 0;p < proposals.length; p++ ) 
        {
            if(proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
                winningProposal_ = p;
            }
        }
     }
        // @dev Calls winningProposal() function to get the index of the winner contained in the proposals array and then
        // @return winnerName_ the name of the winner
     function winnerName() public view returns (bytes32 winnerName_)
     {
        winnerName_ = proposals[winningProposal()].name;
     }
    }
