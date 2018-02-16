pragma solidity ^0.4.11;
import './SafeMath.sol';

// Интерфейс токена
interface MyToken {
    function transfer(address _receiver, uint256 _amount);
    function balanceOf(address _receiver) returns (uint);
}

// Интерфейс ICO токена
interface MyTokenICO {
    function getTokenHoldersAddress(uint8 _x) public returns (address);
    function getTokenHoldersCount() public returns (uint);
    function start() returns (uint);
    function period() returns (uint);
}

contract Dividends {
    using SafeMath for uint;

    uint public dateCloseICO;
    // Период, через который будет осуществляться выплата
    uint public durationDividends;

    // Дата начала выплат дивидендов
    uint public startPayPeriodDividends;

    uint public sharesPercent;

    // Переменная для хранения токена
    MyToken public token;

    MyTokenICO public tokenICO;

    uint public tokenHoldersCount;

    // После окончания ICO, в данную структуру запишем фактический баланс держателей
    struct Shareholders {
        address account;
        uint amount;
    }

    // Объявляем массив с типом Shareholders
    Shareholders[] public shareholder;

    // При деплои передается два адресе, адрес ERC20 токена и адрес контракта ICO
    function Dividends(MyToken _token, MyTokenICO _tokenICO) {
        token = _token;
        tokenICO = _tokenICO;
        durationDividends = 18;
        sharesPercent = 10;
        dateCloseICO = tokenICO.start() + tokenICO.period() * 1 days;
        startPayPeriodDividends = dateCloseICO + (1 years + 1 years / 2);
        tokenHoldersCount = tokenICO.getTokenHoldersCount();
    }

    // проверяем, что с момента окончания ICO прошло 18 месяцев
    modifier periodDividendsIsOn() {
        require(now > startPayPeriodDividends);
        _;
    }

    // Сначала получим всех наших токенодержателей, т.к. кортеж нельзя вернуть из функции
    // то берем по каждому и записываем в нашу структуру
    function getAllTokenHoldersWithBalance() public periodDividendsIsOn returns (bool) {
        for(uint i = 0; i < tokenHoldersCount; i++) {
            uint tokensValue = token.balanceOf(tokenICO.getTokenHoldersAddress(uint8(i)));
            shareholder.push(Shareholders({account: tokenICO.getTokenHoldersAddress(uint8(i)), amount: tokensValue}));

        }
        return true;
    }

    // Выплачиваем дивидендов
    function payDividends() public periodDividendsIsOn returns (bool) {
        for(uint i = 0; i < shareholder.length; i++) {
            uint currentBalance = shareholder[i].amount;

            if (currentBalance > 0) {
                uint dividends = currentBalance.mul(sharesPercent).div(100);
                token.transfer(shareholder[i].account, dividends);
            }
        }

        startPayPeriodDividends = startPayPeriodDividends + (1 years + 1 years / 2);

        return true;
    }

}
