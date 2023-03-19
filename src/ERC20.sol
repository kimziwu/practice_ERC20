//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./EIP712.sol";

contract ERC20 is EIP712("DREAM","PLUS") {
    
    // default 0
    address private _owner;
    string private  _name;
    string private _symbol;
    uint256 private _totalSupply;
    bool private _pause=false;
    bytes32 _structHash=keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
    
    mapping(address=>uint256) private _balances;
    mapping(address=>uint) private _nonces;
    mapping(address=>mapping(address=>uint256)) private _allowance;

    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint256 value);
    
    constructor(string memory name, string memory version) {
        _owner=msg.sender;
        _name=name;
        _symbol=version;
    }

    modifier onlyOwner(){
        require(msg.sender==_owner,"Only owner");
        _;
    }

    //ERC20
    function name() public view virtual returns (string memory){
        return _name;
    }

    function symbol() public view virtual returns (string memory){
        return _symbol;
    }

    function decimals() public view virtual returns (uint8){
        return 18;
    }

    function totalSupply() public view virtual returns (uint256){
        return _totalSupply;
    }

    function balanceOf(address account) public view virtual returns (uint256){
        return _balances[account];
    }

    function transfer(address to, uint256 value) public virtual {
        _balances[to]+=value;
    }

    function transferFrom(address, address, uint256) public virtual returns (bool) {}

    function pause() public {
        require(_pause);
    }

    function approve(address spender, uint value) public virtual returns (bool) {
        _approve(msg.sender, spender, value);
        return true;
    }

    function _approve(address owner, address spender, uint value) internal virtual {
        _allowance[owner][spender]=value;
        emit Approval(owner, spender, value);

    }
    
    function nonces(address to) public returns (uint256) {
        return _nonces[to];
    }
    function allowance(address to, address from) public returns (uint256) {
        return _allowance[to][from];
    }

    function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) public {
        require(block.timestamp<=deadline); 

        bytes32 structHash=keccak256(abi.encode(_structHash, owner, spender, value, _nonces[owner], deadline));
        bytes32 digest=_toTypedDataHash(structHash); // digest
        address testOwner=ecrecover(digest,v,r,s);

        _nonces[owner]+=1;
        
        require(testOwner==owner,"INVALID_SIGNER");
        _approve(owner, spender, value);
      
        require(_balances[owner]>=value);
    }
    
}
