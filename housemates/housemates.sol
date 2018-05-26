pragma solidity ^0.4.23;

// ----------------------------------------------------------------------------
// ShareHouse DApp Project
//
// https://github.com/apguerrera/ShareHouse
//
// Appropriated from
// https://github.com/bokkypoobah/ClubEth
// (c) BokkyPooBah / Bok Consulting Pty Ltd
//
// (c) Adrian Guerrera / www.adrianguerrera.com and
// the ShareHouse DApp Project - 2018. The MIT Licence.
// ----------------------------------------------------------------------------


// ----------------------------------------------------------------------------
// Safe maths
// ----------------------------------------------------------------------------
library SafeMath {
    function add(uint a, uint b) internal pure returns (uint c) {
        c = a + b;
        require(c >= a);
    }
    function sub(uint a, uint b) internal pure returns (uint c) {
        require(b <= a);
        c = a - b;
    }
    function mul(uint a, uint b) internal pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }
    function div(uint a, uint b) internal pure returns (uint c) {
        require(b > 0);
        c = a / b;
    }
}


// ----------------------------------------------------------------------------
// Owned contract
// ----------------------------------------------------------------------------
contract Owned {
    address public owner;
    address public newOwner;

    event OwnershipTransferred(address indexed _from, address indexed _to);

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    constructor() public {
        owner = msg.sender;
    }
    function transferOwnership(address _newOwner) public onlyOwner {
        newOwner = _newOwner;
    }
    function acceptOwnership() public {
        require(msg.sender == newOwner);
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
        newOwner = address(0);
    }
    function transferOwnershipImmediately(address _newOwner) public onlyOwner {
        emit OwnershipTransferred(owner, _newOwner);
        owner = _newOwner;
    }
}




// rough layout
// contract ClubToken is ClubTokenInterface, Owned {}

contract owned {}

library Housemates {}
library Proposals {}

// ----------------------------------------------------------------------------
// House
// ----------------------------------------------------------------------------

contract House {
  using SafeMath for uint;
  using HouseMates for HouseMates.Data;
  using Proposals for Proposals.Data;

  HouseMates.Data housemates;

  // uint public quorum = 80;
  // uint public quorumDecayPerWeek = 10;
  // uint public requiredMajority = 70;
  bool public initialised;

  // Must be copied here to be added to the ABI
  event HouseMateAdded(address indexed houseMateAddress, string name, uint totalAfter);
  event HouseMateRemoved(address indexed houseMateAddress, string name, uint totalAfter);
  event HouseMateNameUpdated(address indexed houseMateAddress, string oldName, string newName);
  event EtherDeposited(address indexed sender, uint amount);
  event EtherSent(address indexed sender, uint amount);


  modifier onlyHouseMate {
      require(housemates.isMember(msg.sender));
      _;
  }

  constructor() public {
    housemates.init();
  }

  function addHouseMate  (address houseMateAddress) onlyHouseMate {
    houseMates[] = houseMateAddress;
  }
  function setRent (address _houseMateAddress uint _rent) onlyHouseMate {
    HouseMate[_houseMateAddress].rent = _rent;
  }
  function removeHouseMate (address houseMateAddress) onlyHouseMate {
    delete houseMates[houseMateAddress] ;
  }
  function payBond {}
  function claimBond (address houseMateAddress) {
    bondClaimApproved[houseMateAddress] == true;
    returnBond();
    hasBond[houseMateAddress] = false;
  }
  function loseBond (address houseMateAddress) onlyHouseMate {
    hasBond[houseMateAddress] = false;
  }
  function numberOfHouseMates() public view returns (uint) {
      return housemates.length();
  }
  function etherTransfer(address houseMateAddress) onlyHouseMate {
    emit EtherSent(houseMateAddress, msg.value);
  }

  // let the contract hold extra funds
  function () public payable {
      emit EtherDeposited(msg.sender, msg.value);
  }

}

// ----------------------------------------------------------------------------
// House Factory
// ----------------------------------------------------------------------------

contract HouseFactory is Owned {

}
