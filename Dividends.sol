pragma solidity ^0.4.11;

// Интерфейс токена
interface ChangableToken {
    function payDividends();
}

contract Dividends {

    // Переменная для хранения токена
    ChangableToken public token;

    function Dividends(ChangableToken _token) {
        token = _token;
    }

    function pay() public {
        token.payDividends();
    }
}
