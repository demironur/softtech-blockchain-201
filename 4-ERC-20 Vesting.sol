// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract VestingContract is Ownable {
    struct VestingSchedule {
        uint256 cliff;
        uint256 duration;
        uint256 start;
        uint256 totalAmount;
        uint256 releasedAmount;
    }

    IERC20 public token;
    mapping(address => VestingSchedule) public vestingSchedules;

    event VestingScheduled(address indexed beneficiary, uint256 totalAmount, uint256 cliff, uint256 duration);
    event TokensReleased(address indexed beneficiary, uint256 amount);

    constructor(address _tokenAddress) {
        token = IERC20(_tokenAddress);
    }

    function createVestingSchedule(
        address beneficiary,
        uint256 totalAmount,
        uint256 cliff,
        uint256 duration
    ) external onlyOwner {
        require(vestingSchedules[beneficiary].totalAmount == 0, "Vesting schedule already exists");
        require(cliff <= duration, "Cliff must be less than or equal to duration");

        vestingSchedules[beneficiary] = VestingSchedule({
            cliff: cliff,
            duration: duration,
            start: block.timestamp,
            totalAmount: totalAmount,
            releasedAmount: 0
        });

        emit VestingScheduled(beneficiary, totalAmount, cliff, duration);
    }

    function releaseTokens() external {
        VestingSchedule storage schedule = vestingSchedules[msg.sender];
        require(schedule.totalAmount > 0, "No vesting schedule found");
        require(block.timestamp >= schedule.start + schedule.cliff, "Cliff period has not passed");
        require(!hasVestingCompleted(msg.sender), "Vesting has already completed");

        uint256 vestedAmount = calculateVestedAmount(schedule);

        uint256 amountToRelease = vestedAmount - schedule.releasedAmount;
        schedule.releasedAmount = vestedAmount;

        token.transfer(msg.sender, amountToRelease);
        emit TokensReleased(msg.sender, amountToRelease);
    }

    function hasVestingCompleted(address beneficiary) public view returns (bool) {
        VestingSchedule storage schedule = vestingSchedules[beneficiary];
        return block.timestamp >= schedule.start + schedule.duration;
    }

    function calculateVestedAmount(VestingSchedule storage schedule) internal view returns (uint256) {
        if (block.timestamp < schedule.start + schedule.cliff) {
            return 0;
        }
        if (block.timestamp >= schedule.start + schedule.duration) {
            return schedule.totalAmount;
        }
        return
            (schedule.totalAmount * (block.timestamp - schedule.start)) /
            schedule.duration;
    }
}
