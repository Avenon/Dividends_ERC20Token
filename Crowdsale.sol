// Указываем версию для компилятора
pragma solidity ^0.4.19;

import './SafeMath.sol';

// Объявляем интерфейс
interface MyToken {
    function transfer(address _receiver, uint256 _amount);
}

// Объявляем контракт
contract Crowdsale {

    using SafeMath for uint;

    // Объявляем коэффициент стомости токена
    uint public rate;

    // Объявялем переменную для токена
    MyToken public token;

    address public owner;

    // Дата начала ICO
    uint public start;

    // Период ICO
    uint public period;

    // Записываем наших инвесторов
    mapping (address => bool) public onChain;
    address[] public tokenHolders;


    // Функция инициализации
    function Crowdsale(MyToken _token){
        // Присваиваем токен
        token = _token;
        // Присваем стоимость
        // 1 эфир = 10000 наших токенов
        rate = 10000;

        owner = msg.sender;
        //11.02.2018
        start = 1517745600;
        // Пусть наше ico длится 12 дней, ниже добавим модификатор, где будем
        // это проверять
        period = 12;
    }

    modifier saleIsOn() {
        require(now > start && now < start + period * 1 days);
        _;
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
    function _buy(address _sender, uint256 _amount) internal saleIsOn returns (uint){
        // отправляе эфир на адрес овнераs
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

    // Функция озвращающая длину массива
    function getTokenHoldersCount() public returns (uint) {
        return tokenHolders.length;
    }

    // функция-геттер получающая адрес токенодержателя по индексу
    function getTokenHoldersAddress(uint8 _x) public returns (address)
    {
        return tokenHolders[_x];
    }
}
