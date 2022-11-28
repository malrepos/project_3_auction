// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0;

contract Timer {
    uint256 _start;
    uint256 _end;

    modifier timerOver() {
        require(block.timestamp <= _end, "Time is up.");
        _;
    }

    //starts the timer
    function start() public {
        _start = block.timestamp;
    }

    // sets the duration of the timer
    function end(uint256 totalTime) public {
        _end = totalTime + _start;
    }

    // a function to view the amount of time left
    function getTimeLeft() public view timerOver returns (uint256) {
        return _end - block.timestamp;
    }
}
