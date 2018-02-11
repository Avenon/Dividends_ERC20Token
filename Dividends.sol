pragma solidity ^0.4.11;


import './Ownable.sol';

// Интерфейс токена
interface MyTokenDividends {
    function getTokenBalance() returns (bool);
    function transfer(address _receiver, uint256 _amount);
}

contract Dividends {

    uint public dateCloseICO;
    // Период, через который будет осуществляться выплата
    uint public durationDividends;

    // Дата начала выплат дивидендов
    uint public startPayPeriodDividends;
    // Переменная для хранения токена
    MyTokenDividends public token;

    function Dividends(MyTokenDividends _token) {
        token = _token;
        durationDividends = 18;
        dateCloseICO = 1518264000;
        startPayPeriodDividends = dateCloseICO + (1 years + 1 years / 2);
    }

    modifier periodDividendsIsOn() {
        require(now > startPayPeriodDividends);
        _;
    }

    function getActualCountTokens() public periodDividendsIsOn onlyOwner {
        token.getTokenBalance();
        return true;
    }

    function payDividends() public returns (bool) {
        for(uint i = 0; i < token.shareholders.length; i++) {
            uint currentBalance = token.shareholders[i].amount;

            if (currentBalance > 0) {
                uint dividends = currentBalance.mul(sharesPercent).div(100);
                token.transfer(token.shareholders[i].account, dividends);
            }
        }
        return true;
    }
}
