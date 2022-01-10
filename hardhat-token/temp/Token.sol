pragma solidity^0.8.0;

// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "@openzeppelin/contracts/utils/math/SafeMath.sol";


 contract ERC20 is IERC20 {
 
  using SafeMath for uint256;


  mapping (address => uint256)private _balances;



  mapping (address => mapping (address => uint256))private _allowances;
  uint256 private _totalSupply;


  function totalSupply() public view override returns (uint256) {
    return _totalSupply;
  }

  function balanceOf (address account) public view override returns (uint256){
    return _balances[account];
  }
  function allowance(address owner,address spender) public view override returns (uint256){
    return _allowances[owner][spender];
  }


  function transfer(address recipient ,uint256 amout) public override returns(bool){
    _transfer(msg.sender,recipient,amout);
    return true;
  }
  function _transfer(address sender,address recipient,uint256 amount) internal {
    require(sender != address(0), "ERC20:transfer from the zero address");
    require(recipient != address(0),"ERC20:teansfer to the zero address");
    _balances[sender] = _balances[sender].sub(amount);
    _balances[recipient] = _balances[recipient].add(amount);
    emit Transfer(sender,recipient,amount);
  }


  function approve(address spender,uint256 value)public override returns (bool){
    _approve(msg.sender,spender,value);
    return true;
  }
  function _approve(address owner,address spender,uint256 value) internal {
    require(owner != address(0),"ERC20: approve from the zero address");
    require(spender != address(0), "ERC20:aprove to the zero address");
    _allowances[owner][spender] = value;
    emit Approval(owner,spender,value);
  }

  function transferFrom(address sender,address recipient,uint256 amount)public override returns(bool) {
    _transfer(sender,recipient,amount);
    _approve(sender,msg.sender,_allowances[sender][msg.sender].sub(amount));
    return true;
  }

  function _mint(address account,uint256 amount) internal {
    require(account != address(0),"ERC20:mint to the zero address");
    _totalSupply = _totalSupply.add(amount);
    _balances[account] = _balances[account].add(amount);
    emit Transfer(address(0),account,amount);
  }
}



contract ERC20Detailed {
  string private _name;
  string private _symbol;
  uint8 private _decimals;
  constructor (string memory name,string memory symbol,uint8 decimals) {
    _name =name;
    _symbol = symbol;
    _decimals = decimals;
  }
  function name() public view returns (string memory){
    return _name;
  }
  function symbol() public view returns (string memory){
    return _symbol;
  }
  function decimals() public view returns (uint8 ){
    return _decimals;
  }
}


contract Token is ERC20,ERC20Detailed("We Token","WT",18){
  constructor() public {
    _mint(msg.sender,12000000000*10**18);
  }
}