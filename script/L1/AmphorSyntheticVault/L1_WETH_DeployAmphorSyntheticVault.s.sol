// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.21;

import {Script, console} from "forge-std/Script.sol";
import {AmphorSyntheticVault} from "../../../src/AmphorSyntheticVault.sol";
import "@openzeppelin-v4.9.3/contracts/token/ERC20/ERC20.sol";

contract L1_WETH_DeployAmphorSyntheticVault is Script {
    function run() external {
        // if you want to deploy a vault with a seed phrase instead of a pk, uncomment the following line
        // string memory seedPhrase = vm.readFile(".secret");
        // uint256 privateKey = vm.deriveKey(seedPhrase, 0);
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        address amphorlabsAddress = vm.envAddress("AMPHORLABS_ADDRESS");
        ERC20 underlying = ERC20(vm.envAddress("WETH_MAINNET"));
        uint8 decimalOffset = uint8(vm.envUint("DECIMALS_OFFSET_USDC"));
        uint16 fees = uint16(vm.envUint("INITIAL_FEES_AMOUNT"));
        uint256 bootstrapAmount = vm.envUint("BOOTSTRAP_AMOUNT_SYNTHETIC_USDC");
        string memory vaultName = vm.envString("SYNTHETIC_USDC_V0_NAME");
        string memory vaultSymbol = vm.envString("SYNTHETIC_USDC_V0_SYMBOL");

        vm.startBroadcast(privateKey);

        AmphorSyntheticVault amphorSyntheticVault =
        new AmphorSyntheticVault(
                underlying,
                vaultName,
                vaultSymbol,
                decimalOffset
            );

        amphorSyntheticVault.setFees(fees);

        IERC20(underlying).approve(
            address(amphorSyntheticVault), bootstrapAmount
        );
        amphorSyntheticVault.deposit(bootstrapAmount, amphorlabsAddress);

        amphorSyntheticVault.transferOwnership(amphorlabsAddress);

        console.log(
            "Synthetic vault WETH contract address: ",
            address(amphorSyntheticVault)
        );

        vm.stopBroadcast();
    }
}