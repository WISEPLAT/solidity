pragma solidity ^0.4.11;

import "./Ownable.sol";

/** 
 * @title Contracts that should not own Wise
 * @author Remco Bloemen <remco@2π.com>
 * @dev This tries to block incoming wise to prevent accidental loss of Wise. Should Wise end up
 * in the contract, it will allow the owner to reclaim this wise.
 * @notice Wise can still be send to this contract by:
 * calling functions labeled `payable`
 * `selfdestruct(contract_address)`
 * mining directly to the contract address
*/
contract HasNoWise is Ownable {

  /**
  * @dev Constructor that rejects incoming Wise
  * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we 
  * leave out payable, then Solidity will allow inheriting contracts to implement a payable 
  * constructor. By doing it this way we prevent a payable constructor from working. Alternatively 
  * we could use assembly to access msg.value.
  */
  function HasNoWise() payable {
    if(msg.value > 0) {
      throw;
    }
  }

  /**
   * @dev Disallows direct send by settings a default function without the `payable` flag.
   */
  function() external {
  }

  /**
   * @dev Transfer all Wise held by the contract to the owner.
   */
  function reclaimWise() external onlyOwner {
    if(!owner.send(this.balance)) {
      throw;
    }
  }
}
