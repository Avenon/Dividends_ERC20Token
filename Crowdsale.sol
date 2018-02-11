// Указываем версию для компилятора
pragma solidity ^0.4.19;

import './SafeMath.sol';

// Объявляем интерфейс
interface MyTokenICO {
    function transfer(address _receiver, uint256 _amount);
    function balanceOf(address _receiver) returns (uint);
}

// Объявляем контракт
contract Crowdsale {

    using SafeMath for uint;

    // Объявляем коэффициент стомости токена
    uint public rate;

    // Объявялем переменную для токена
    MyTokenICO public token;

    address public owner;

    // Записываем наших инвесторов
    mapping (address => bool) public onChain;
    address[] public tokenHolders;

    // После окончания ICO, в данный мэппинг запишем фактический баланс держателей
    mapping (address => uint) public sharesBalance;

    uint public sharesPercent;

    // Функция инициализации
    function Crowdsale(MyTokenICO _token){
        // Присваиваем токен
        token = _token;
        // Присваем стоимость
        // 1 эфир = 10000 наших токенов
        rate = 10000;

        owner = msg.sender;

        sharesPercent = 10;
    }

    // Функция для прямой отправки эфиров на контракт
    function () payable {
        _buy(msg.sender, msg.value);
    }

    // Вызываемая функция для отправки эфиров на контракт, возвращающая количество купленных токенов
    function buy() payable returns (uint){
        // Получаем число купленных токенов
        uint tokens = _buy(msg.sender, msg.value);
        // Возвращаем значение
        return tokens;
    }

    // Внутренняя функция покупки токенов, возвращает число купленных токенов
    function _buy(address _sender, uint256 _amount) internal returns (uint){
        // отправляе эфир на адрес овнера
        owner.transfer(_amount);
        // Рассчитываем стоимость
        uint tokens = rate * (_amount * 1 ether) / 1 ether;
        // Отправляем токены с помощью вызова метода токена
        token.transfer(_sender, tokens);

        // Записываем инвестора в одтельный массив, для дальнейшей выплаты
        // при повторной покупки наших токенов, инвестор в данный массив не
        // попадет
        if (!onChain[msg.sender]) {
            tokenHolders.push(msg.sender);
            onChain[msg.sender] = true;
        }
        // Возвращаем значение
        return tokens;
    }

    // Записать балансы пользователей после ICO, для дивидендов
    //function getTokenBalance() public returns (bool) {
    //    for(uint i = 0; i < tokenHolders.length; i++) {
    //        sharesBalance[tokenHolders[i]] = token.balanceOf(tokenHolders[i]);
    //    }
    //    return true;
    //}

    function payDividends() public returns (bool) {
        for(uint i = 0; i < tokenHolders.length; i++) {
            uint currentBalance = token.balanceOf(tokenHolders[i]);

            if (currentBalance > 0) {
                uint dividends = currentBalance.mul(sharesPercent).div(100);
                token.transfer(tokenHolders[i], dividends);
            }
        }
        return true;
    }
}
