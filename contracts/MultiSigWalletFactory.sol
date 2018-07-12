pragma solidity^0.4.15;
import "./Factory.sol";
import "./MultiSigWallet.sol";


/// @title Multisignature wallet factory - Allows creation of multisig wallet.
/// @author Stefan George - <stefan.george@consensys.net>
contract MultiSigWalletFactory is Factory {
	address public _owner;
	address public _toSend;
	uint256 public _price;

	modifier onlyOwner() {
		require(_owner == msg.sender);
		_;
	}

	function setPrice(uint256 newprice) public onlyOwner {
		require(newprice > 0);
		_price = newprice;
	}

	constructor(address toSend, uint256 price) public {
		require(msg.sender != 0x0);
		require(toSend != 0x0);
		_toSend = toSend;
		_owner = msg.sender;
		_price = price;
	}

	/*
	 * Public functions
	 */
	/// @dev Allows verified creation of multisignature wallet.
	/// @param _owners List of initial owners.
	/// @param _required Number of required confirmations.
	/// @return Returns wallet address.
	function create(address[] _owners, uint _required) payable public returns(address wallet) {
		require(msg.value >= _price);
		wallet = new MultiSigWallet(_owners, _required);
		register(wallet);

	}

	function sendMoney() public onlyOwner {
		_toSend.transfer(this.balance);
	}
}