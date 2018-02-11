pragma solidity ^0.4.11;


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

    uint public sharesPercent;

    // Переменная для хранения токена
    MyTokenDividends public token;

    function Dividends(MyTokenDividends _token) {
        token = _token;

        durationDividends = 18;
        sharesPercent = 10;
        dateCloseICO = 1518264000;
        startPayPeriodDividends = dateCloseICO + (1 years + 1 years / 2);
    }

    modifier periodDividendsIsOn() {
        require(now > startPayPeriodDividends);
        _;
    }

    function getActualCountTokens() public periodDividendsIsOn returns (bool){
        token.getTokenBalance();
        return true;
    }



}
