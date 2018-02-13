pragma solidity ^0.4.19;

import './MintableToken.sol';


/**
 * Мой контракт, унаследован от контракта MintableToken
 */
contract MyToken is MintableToken {

    string public constant name = "DividendToken";

    string public constant symbol = "DIVTOK";

    uint32 public constant decimals = 18;

    uint256 public totalSupply;

    function MyToken() {

        // Выпустим 1000000 на продажу и 100000 на дивиденды
        totalSupply = 1100000 * (10 ** uint256(decimals));

        // "Отправляем" все токены на баланс того, кто инициализировал создание контракта токена
        // В нашем случае все токены будут у создателя
        balances[msg.sender] = totalSupply;
    }
}
