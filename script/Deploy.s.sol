//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./DeployHelpers.s.sol";
import {FairdexV2Factory} from "../contracts/FairdexV2Factory.sol";
import {FairdexV2Router02} from "../contracts/FairdexV2Router02.sol";
import {WETH} from "../contracts/WETH.sol";

// import {PracticeSupplyERC20} from "../contracts/PracticeSupplyERC20.sol";

contract DeployScript is ScaffoldETHDeploy {
    error InvalidPrivateKey(string);
    error InvalidOwnerAddress();
    FairdexV2Factory factory;
    FairdexV2Router02 router;
    WETH weth;

    // PracticeSupplyERC20 practiceERC20;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("ADMIN_PRIVATE_KEY");
        uint256 owner = vm.envUint("OWNER_ADDRESS");
        // address admin = vm.addr(deployerPrivateKey);

        if (deployerPrivateKey == 0) {
            revert InvalidPrivateKey(
                "You don't have a deployer account. Make sure you have set DEPLOYER_PRIVATE_KEY in .env or use `yarn generate` to generate a new random account"
            );
        }
        if (owner == 0) {
            revert InvalidOwnerAddress();
        }
        vm.startBroadcast(deployerPrivateKey);
        address setter = vm.addr(deployerPrivateKey);
        factory = new FairdexV2Factory(setter);
        factory.setFeeTo(setter);
        weth = new WETH();
        router = new FairdexV2Router02(address(factory), address(weth));

        console.logString(
            string.concat(
                "factory contract deployed at: ",
                vm.toString(address(factory))
            )
        );
        console.logString(
            string.concat(
                "WETH contract deployed at: ",
                vm.toString(address(weth))
            )
        );
        console.logString(
            string.concat(
                "router contract deployed at: ",
                vm.toString(address(router))
            )
        );
        // console.logString(
        //     string.concat(
        //         "PracticeERC20 contract deployed at: ",
        //         vm.toString(address(practiceERC20))
        //     )
        // );
        vm.stopBroadcast();
        exportDeployments();
    }
}
