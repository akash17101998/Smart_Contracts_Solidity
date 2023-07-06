// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

struct Member{
    address addr;
    uint256 voteCount;
}

contract Mapping{

   
    Member[] public memberList;
    address public owner;
    bool public isVoting;
    mapping(address=>bool) public hasVoted;
    mapping(address=>bool) public hasRegistered;
    event VoteCasted(address voter,string s);
    event Registered(address member);

    constructor(){
        owner = msg.sender;
    } 

    
    function castVoteForMember(address _member) public {

        require(isVoting, "Voting has not started");
        bool found;
        
        for(uint256 i=0; i<memberList.length; i++){
            
            if(memberList[i].addr == _member){
                require(!hasVoted[msg.sender], "already voted");
                hasVoted[msg.sender] = true;
                memberList[i].voteCount += 1;
                found = true;
                break;
            }

        }
        require(found, "Member not found");
        emit VoteCasted(msg.sender, "Voting complete");
        
    }

    function setVotingTo(bool _isVoting) public {
        require(msg.sender == owner, "Unauthorised");
        isVoting = _isVoting;
    }

    function register(address _member) public{
        require(msg.sender == owner, "Unauthorised");
        require(!hasRegistered[_member],"Already registered");
        hasRegistered[_member] = true;
        memberList.push(Member(_member,0));
        emit Registered(_member);
    }

    function getRegistrationList() public view returns(Member[] memory){
        return memberList;
    }

    
    function Winner() public view returns(address, uint256) {
        uint256 val;
        address val1;
        require(isVoting == false, "Election not ended yet");
        for(uint i=0; i < memberList.length; i++){
            if(val < memberList[i].voteCount){
                val = memberList[i].voteCount;
                val1 = memberList[i].addr;
            }
        }
        return (val1, val);
    }

    function deRegister(address _deReg) public {
        require(msg.sender == owner, "Unauthorised");
        for(uint256 i=0; i<memberList.length; i++){
            if(memberList[i].addr == _deReg){
            delete memberList[i];
            hasRegistered[_deReg] = false;
            }
        }
    } 
}
