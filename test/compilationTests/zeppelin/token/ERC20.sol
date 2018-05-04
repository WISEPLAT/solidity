pragma solidity ^0.4.11;


import './ERC20Basic.sol';


/**
 * @title ERC20 interface
 * @dev see https://github.com/wiseplat/EIPs/issues/20
 */
contract ERC20 is ERC20Basic {
  function allowance(address owner, address spender) constant returns (uint256);
  function transferFrom(address from, address to, uint256 value);
  function approve(address spender, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}