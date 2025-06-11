// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.28;

contract TelosConsiliumProxy {
    mapping(address => bool) public admins;
    mapping(address => bool) public callers;
    mapping(uint256 => bool) public correlations;

    event Admin(address indexed setter, address indexed param, bool state);
    event Caller(address indexed setter, address indexed param, bool state);
    event Action(uint256 indexed correlation, address indexed caller, address indexed target, uint8 action, bool success, bytes result);

    constructor(address admin) {
        admins[admin] = true;
        emit Admin(msg.sender, admin, true);
    }

    function setAdmin(address admin, bool state) public {
        require(admins[msg.sender], "Not admin");
        require(msg.sender != admin, "Not self");
        admins[admin] = state;
        emit Admin(msg.sender, admin, state);
    }

    function setCaller(address caller, bool state) public {
        require(admins[msg.sender], "Not admin");
        callers[caller] = state;
        emit Caller(msg.sender, caller, state);
    }

    function doCall(uint256 correlation, address target, bytes memory code) public returns (bool, bytes memory) {
        require(callers[msg.sender], "Not caller");
        require(correlations[correlation] == false, "Correlated");
        (bool success, bytes memory result) = target.call(code);
        correlations[correlation] = true;
        emit Action(correlation, msg.sender, target, 1, success, result);
        return (success, result);
    }

    function doDelegateCall(uint256 correlation, address target, bytes memory code) public returns (bool, bytes memory) {
        require(callers[msg.sender], "Not caller");
        require(correlations[correlation] == false, "Correlated");
        (bool success, bytes memory result) = target.delegatecall(code);
        correlations[correlation] = true;
        emit Action(correlation, msg.sender, target, 2, success, result);
        return (success, result);
    }

    function doStaticCall(uint256 correlation, address target, bytes memory code) public returns (bool, bytes memory) {
        require(callers[msg.sender], "Not caller");
        require(correlations[correlation] == false, "Correlated");
        (bool success, bytes memory result) = target.staticcall(code);
        correlations[correlation] = true;
        emit Action(correlation, msg.sender, target, 3, success, result);
        return (success, result);
    }
}
