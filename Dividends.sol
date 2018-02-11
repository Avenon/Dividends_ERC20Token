pragma solidity ^0.4.11;


import './Ownable.sol';

// Интерфейс токена
interface MyTokenDividends {
    function payDividends() returns (bool);
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

    function pay() public periodDividendsIsOn onlyOwner {
        token.payDividends();
    }
}
