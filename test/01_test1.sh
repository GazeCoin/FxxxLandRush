#!/bin/bash
# ----------------------------------------------------------------------------------------------
# Testing the smart contract
#
# Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2018. The MIT Licence.
# ----------------------------------------------------------------------------------------------

echo "Options: [full|takerSell|takerBuy|exchange]"

MODE=${1:-full}

source settings
echo "---------- Settings ----------" | tee $TEST1OUTPUT
cat ./settings | tee -a $TEST1OUTPUT
echo "" | tee -a $TEST1OUTPUT

CURRENTTIME=`date +%s`
CURRENTTIMES=`perl -le "print scalar localtime $CURRENTTIME"`
START_DATE=`echo "$CURRENTTIME+30" | bc`
START_DATE_S=`perl -le "print scalar localtime $START_DATE"`
END_DATE=`echo "$CURRENTTIME+60" | bc`
END_DATE_S=`perl -le "print scalar localtime $END_DATE"`

printf "CURRENTTIME = '$CURRENTTIME' '$CURRENTTIMES'\n" | tee -a $TEST1OUTPUT
printf "START_DATE  = '$START_DATE' '$START_DATE_S'\n" | tee -a $TEST1OUTPUT
printf "END_DATE    = '$END_DATE' '$END_DATE_S'\n" | tee -a $TEST1OUTPUT

# Make copy of SOL file ---
# rsync -rp $SOURCEDIR/* . --exclude=Multisig.sol --exclude=test/
rsync -rp $SOURCEDIR/* . --exclude=Multisig.sol
# Copy modified contracts if any files exist
find ./modifiedContracts -type f -name \* -exec cp {} . \;

# --- Modify parameters ---
#`perl -pi -e "s/emit LogUint.*$//" $EXCHANGESOL`
# Does not work `perl -pi -e "print if(!/emit LogUint/);" $EXCHANGESOL`

DIFFS1=`diff -r -x '*.js' -x '*.json' -x '*.txt' -x 'testchain' -x '*.md' -x '*.sh' -x 'settings' -x 'modifiedContracts' -x '*_flattened.sol' $SOURCEDIR .`
echo "--- Differences $SOURCEDIR/*.sol *.sol ---" | tee -a $TEST1OUTPUT
echo "$DIFFS1" | tee -a $TEST1OUTPUT

solc_0.4.20 --version | tee -a $TEST1OUTPUT
echo "var bttsFactoryOutput=`solc_0.4.20 --allow-paths . --optimize --pretty-json --combined-json abi,bin,interface $BTTSFACTORYSOL`;" > $BTTSFACTORYJS

solc_0.4.25 --version | tee -a $TEST1OUTPUT
echo "var makerDaoEthUsdPriceFeedSimulatorOutput=`solc_0.4.25 --allow-paths . --optimize --pretty-json --combined-json abi,bin,interface $MDPRICEFEEDSIMULATORSOL`;" > $MDPRICEFEEDSIMULATORJS
echo "var makerDaoPriceFeedAdaptorOutput=`solc_0.4.25 --allow-paths . --optimize --pretty-json --combined-json abi,bin,interface $MDPRICEFEEDADAPTORSOL`;" > $MDPRICEFEEDADAPTORJS
echo "var priceFeedOutput=`solc_0.4.25 --allow-paths . --optimize --pretty-json --combined-json abi,bin,interface $PRICEFEEDSOL`;" > $PRICEFEEDJS
echo "var bonusListOutput=`solc_0.4.25 --allow-paths . --optimize --pretty-json --combined-json abi,bin,interface $BONUSLISTSOL`;" > $BONUSLISTJS
echo "var landRushOutput=`solc_0.4.25 --allow-paths . --optimize --pretty-json --combined-json abi,bin,interface $LANDRUSHSOL`;" > $LANDRUSHJS

../scripts/solidityFlattener.pl --contractsdir=../contracts --mainsol=$MDPRICEFEEDSIMULATORSOL --outputsol=$MDPRICEFEEDSIMULATORFLATTENED --verbose | tee -a $TEST1OUTPUT
../scripts/solidityFlattener.pl --contractsdir=../contracts --mainsol=$MDPRICEFEEDADAPTORSOL --outputsol=$MDPRICEFEEDADAPTORFLATTENED --verbose | tee -a $TEST1OUTPUT
../scripts/solidityFlattener.pl --contractsdir=../contracts --mainsol=$PRICEFEEDSOL --outputsol=$PRICEFEEDFLATTENED --verbose | tee -a $TEST1OUTPUT
../scripts/solidityFlattener.pl --contractsdir=../contracts --mainsol=$BONUSLISTSOL --outputsol=$BONUSLISTFLATTENED --verbose | tee -a $TEST1OUTPUT
../scripts/solidityFlattener.pl --contractsdir=../contracts --mainsol=$LANDRUSHSOL --outputsol=$LANDRUSHFLATTENED --verbose | tee -a $TEST1OUTPUT

if [ "$MODE" = "compile" ]; then
  echo "Compiling only"
  exit 1;
fi


geth --verbosity 3 attach $GETHATTACHPOINT << EOF | tee -a $TEST1OUTPUT
loadScript("$BTTSFACTORYJS");
loadScript("$MDPRICEFEEDSIMULATORJS");
loadScript("$MDPRICEFEEDADAPTORJS");
loadScript("$PRICEFEEDJS");
loadScript("$BONUSLISTJS");
loadScript("$LANDRUSHJS");
loadScript("lookups.js");
loadScript("functions.js");


var bttsLibAbi = JSON.parse(bttsFactoryOutput.contracts["$BTTSFACTORYSOL:BTTSLib"].abi);
var bttsLibBin = "0x" + bttsFactoryOutput.contracts["$BTTSFACTORYSOL:BTTSLib"].bin;
var bttsTokenAbi = JSON.parse(bttsFactoryOutput.contracts["$BTTSFACTORYSOL:BTTSToken"].abi);
var bttsFactoryAbi = JSON.parse(bttsFactoryOutput.contracts["$BTTSFACTORYSOL:BTTSTokenFactory"].abi);
var bttsFactoryBin = "0x" + bttsFactoryOutput.contracts["$BTTSFACTORYSOL:BTTSTokenFactory"].bin;
var makerDaoEthUsdPriceFeedSimulatorAbi = JSON.parse(makerDaoEthUsdPriceFeedSimulatorOutput.contracts["$MDPRICEFEEDSIMULATORSOL:MakerDAOETHUSDPriceFeedSimulator"].abi);
var makerDaoEthUsdPriceFeedSimulatorBin = "0x" + makerDaoEthUsdPriceFeedSimulatorOutput.contracts["$MDPRICEFEEDSIMULATORSOL:MakerDAOETHUSDPriceFeedSimulator"].bin;
var makerDaoPriceFeedAdaptorAbi = JSON.parse(makerDaoPriceFeedAdaptorOutput.contracts["$MDPRICEFEEDADAPTORSOL:MakerDAOPriceFeedAdaptor"].abi);
var makerDaoPriceFeedAdaptorBin = "0x" + makerDaoPriceFeedAdaptorOutput.contracts["$MDPRICEFEEDADAPTORSOL:MakerDAOPriceFeedAdaptor"].bin;
var priceFeedAbi = JSON.parse(priceFeedOutput.contracts["$PRICEFEEDSOL:PriceFeed"].abi);
var priceFeedBin = "0x" + priceFeedOutput.contracts["$PRICEFEEDSOL:PriceFeed"].bin;
var bonusListAbi = JSON.parse(bonusListOutput.contracts["$BONUSLISTSOL:BonusList"].abi);
var bonusListBin = "0x" + bonusListOutput.contracts["$BONUSLISTSOL:BonusList"].bin;
var landRushAbi = JSON.parse(landRushOutput.contracts["$LANDRUSHSOL:FxxxLandRush"].abi);
var landRushBin = "0x" + landRushOutput.contracts["$LANDRUSHSOL:FxxxLandRush"].bin;

// console.log("DATA: bttsLibAbi=" + JSON.stringify(bttsLibAbi));
// console.log("DATA: bttsLibBin=" + JSON.stringify(bttsLibBin));
// console.log("DATA: bttsTokenAbi=" + JSON.stringify(bttsTokenAbi));
// console.log("DATA: bttsFactoryAbi=" + JSON.stringify(bttsFactoryAbi));
// console.log("DATA: bttsFactoryBin=" + JSON.stringify(bttsFactoryBin));
// console.log("DATA: makerDaoEthUsdPriceFeedSimulatorAbi=" + JSON.stringify(makerDaoEthUsdPriceFeedSimulatorAbi));
// console.log("DATA: makerDaoEthUsdPriceFeedSimulatorBin=" + JSON.stringify(makerDaoEthUsdPriceFeedSimulatorBin));
// console.log("DATA: makerDaoPriceFeedAdaptorAbi=" + JSON.stringify(makerDaoPriceFeedAdaptorAbi));
// console.log("DATA: makerDaoPriceFeedAdaptorBin=" + JSON.stringify(makerDaoPriceFeedAdaptorBin));
// console.log("DATA: priceFeedBin=" + JSON.stringify(priceFeedBin));
// console.log("DATA: bonusListAbi=" + JSON.stringify(bonusListAbi));
// console.log("DATA: bonusListBin=" + JSON.stringify(bonusListBin));
// console.log("DATA: landRushAbi=" + JSON.stringify(landRushAbi));
// console.log("DATA: landRushBin=" + JSON.stringify(landRushBin));


unlockAccounts("$PASSWORD");
printBalances();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var deployLibMessage = "Deploy Lib";
// -----------------------------------------------------------------------------
console.log("RESULT: ---------- " + deployLibMessage + " ----------");
var bttsLibContract = web3.eth.contract(bttsLibAbi);
var bttsLibTx = null;
var bttsLibAddress = null;
var bttsLib = bttsLibContract.new({from: deployer, data: bttsLibBin, gas: 5000000, gasPrice: defaultGasPrice},
  function(e, contract) {
    if (!e) {
      if (!contract.address) {
        bttsLibTx = contract.transactionHash;
      } else {
        bttsLibAddress = contract.address;
        addAccount(bttsLibAddress, "BTTSLib");
        // addDexOneExchangeContractAddressAndAbi(dexzAddress, dexzAbi);
        console.log("DATA: var bttsLibAddress=\"" + bttsLibAddress + "\";");
        console.log("DATA: var bttsLibAbi=" + JSON.stringify(bttsLibAbi) + ";");
        console.log("DATA: var bttsLib=eth.contract(bttsLibAbi).at(bttsLibAddress);");
      }
    }
  }
);
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(bttsLibTx, deployLibMessage + " - BTTSLib");
printTxData("bttsLibTx", bttsLibTx);
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var deployFactoryMessage = "Deploy Factory";
// -----------------------------------------------------------------------------
console.log("RESULT: ---------- " + deployFactoryMessage + " ----------");
// console.log("RESULT: old='" + bttsFactoryBin + "'");
var newBTTSFactoryBin = bttsFactoryBin.replace(/__BTTSTokenFactory110.sol:BTTSLib_______/g, bttsLibAddress.substring(2, 42));
// console.log("RESULT: new='" + newBTTSFactoryBin + "'");
var bttsFactoryContract = web3.eth.contract(bttsFactoryAbi);
var bttsFactoryTx = null;
var bttsFactoryAddress = null;
var bttsFactory = bttsFactoryContract.new({from: deployer, data: newBTTSFactoryBin, gas: 5000000, gasPrice: defaultGasPrice},
  function(e, contract) {
    if (!e) {
      if (!contract.address) {
        bttsFactoryTx = contract.transactionHash;
      } else {
        bttsFactoryAddress = contract.address;
        addAccount(bttsFactoryAddress, "BTTSFactory");
        addFactoryContractAddressAndAbi(bttsFactoryAddress, bttsFactoryAbi);
        console.log("DATA: var bttsFactoryAddress=\"" + bttsFactoryAddress + "\";");
        console.log("DATA: var bttsFactoryAbi=" + JSON.stringify(bttsFactoryAbi) + ";");
        console.log("DATA: var bttsFactory=eth.contract(bttsFactoryAbi).at(bttsFactoryAddress);");
      }
    }
  }
);
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(bttsFactoryTx, deployFactoryMessage + " - BTTSFactory");
printTxData("bttsFactoryTx", bttsFactoryTx);
printFactoryContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var deployGroup1Message = "Deploy PriceFeeds";
// -----------------------------------------------------------------------------
console.log("RESULT: ---------- " + deployGroup1Message + " ----------");
var makerDaoEthUsdPriceFeedContract = web3.eth.contract(makerDaoEthUsdPriceFeedSimulatorAbi);
var makerDaoEthUsdPriceFeedTx = null;
var makerDaoEthUsdPriceFeedAddress = null;
var makerDaoEthUsdPriceFeed = makerDaoEthUsdPriceFeedContract.new(new BigNumber($INITIALETHUSD).shift(18), true, {from: deployer, data: makerDaoEthUsdPriceFeedSimulatorBin, gas: 5000000, gasPrice: defaultGasPrice},
  function(e, contract) {
    if (!e) {
      if (!contract.address) {
        makerDaoEthUsdPriceFeedTx = contract.transactionHash;
      } else {
        makerDaoEthUsdPriceFeedAddress = contract.address;
        addAccount(makerDaoEthUsdPriceFeedAddress, "MakerDAO ETH/USD PriceFeed Simulator");
        // addEthUsdPriceFeedContractAddressAndAbi(makerDaoEthUsdPriceFeedAddress, makerDaoEthUsdPriceFeedSimulatorAbi);
        console.log("DATA: var makerDaoEthUsdPriceFeedAddress=\"" + makerDaoEthUsdPriceFeedAddress + "\";");
        console.log("DATA: var makerDaoEthUsdPriceFeedAbi=" + JSON.stringify(makerDaoEthUsdPriceFeedSimulatorAbi) + ";");
        console.log("DATA: var makerDaoEthUsdPriceFeed=eth.contract(makerDaoEthUsdPriceFeedAbi).at(makerDaoEthUsdPriceFeedAddress);");
      }
    }
  }
);
while (txpool.status.pending > 0) {
}
var makerDaoPriceFeedAdaptorContract = web3.eth.contract(makerDaoPriceFeedAdaptorAbi);
var makerDaoPriceFeedAdaptorTx = null;
var makerDaoPriceFeedAdaptorAddress = null;
var makerDaoPriceFeedAdaptor = makerDaoPriceFeedAdaptorContract.new("ETH/USD PriceFeed", makerDaoEthUsdPriceFeedAddress, {from: deployer, data: makerDaoPriceFeedAdaptorBin, gas: 5000000, gasPrice: defaultGasPrice},
  function(e, contract) {
    if (!e) {
      if (!contract.address) {
        makerDaoPriceFeedAdaptorTx = contract.transactionHash;
      } else {
        makerDaoPriceFeedAdaptorAddress = contract.address;
        addAccount(makerDaoPriceFeedAdaptorAddress, "MakerDAO ETH/USD PriceFeed Adaptor");
        addEthUsdPriceFeedContractAddressAndAbi(makerDaoPriceFeedAdaptorAddress, makerDaoPriceFeedAdaptorAbi);
        console.log("DATA: var makerDaoPriceFeedAdaptorAddress=\"" + makerDaoPriceFeedAdaptorAddress + "\";");
        console.log("DATA: var makerDaoPriceFeedAdaptorAbi=" + JSON.stringify(makerDaoPriceFeedAdaptorAbi) + ";");
        console.log("DATA: var makerDaoPriceFeedAdaptor=eth.contract(makerDaoPriceFeedAdaptorAbi).at(makerDaoPriceFeedAdaptorAddress);");
      }
    }
  }
);
var gzeEthPriceFeedContract = web3.eth.contract(priceFeedAbi);
var gzeEthPriceFeedTx = null;
var gzeEthPriceFeedAddress = null;
var gzeEthPriceFeed = gzeEthPriceFeedContract.new("GZE/ETH PriceFeed", new BigNumber($INITIALGZEETH).shift(18), true, {from: deployer, data: priceFeedBin, gas: 5000000, gasPrice: defaultGasPrice},
  function(e, contract) {
    if (!e) {
      if (!contract.address) {
        gzeEthPriceFeedTx = contract.transactionHash;
      } else {
        gzeEthPriceFeedAddress = contract.address;
        addAccount(gzeEthPriceFeedAddress, "GZE/ETH PriceFeed");
        addGzeEthPriceFeedContractAddressAndAbi(gzeEthPriceFeedAddress, priceFeedAbi);
        console.log("DATA: var gzeEthPriceFeedAddress=\"" + gzeEthPriceFeedAddress + "\";");
        console.log("DATA: var gzeEthPriceFeedAbi=" + JSON.stringify(priceFeedAbi) + ";");
        console.log("DATA: var gzeEthPriceFeed=eth.contract(gzeEthPriceFeedAbi).at(gzeEthPriceFeedAddress);");
      }
    }
  }
);
var bonusListContract = web3.eth.contract(bonusListAbi);
var bonusListTx = null;
var bonusListAddress = null;
var bonusList = bonusListContract.new({from: deployer, data: bonusListBin, gas: 5000000, gasPrice: defaultGasPrice},
  function(e, contract) {
    if (!e) {
      if (!contract.address) {
        bonusListTx = contract.transactionHash;
      } else {
        bonusListAddress = contract.address;
        addAccount(bonusListAddress, "BonusList");
        addBonusListContractAddressAndAbi(bonusListAddress, bonusListAbi);
        console.log("DATA: var bonusListAddress=\"" + bonusListAddress + "\";");
        console.log("DATA: var bonusListAbi=" + JSON.stringify(bonusListAbi) + ";");
        console.log("DATA: var bonusList=eth.contract(bonusListAbi).at(bonusListAddress);");
      }
    }
  }
);
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(makerDaoEthUsdPriceFeedTx, deployGroup1Message + " - MakerDAO ETH/USD PriceFeed Simulator");
failIfTxStatusError(makerDaoPriceFeedAdaptorTx, deployGroup1Message + " - MakerDAO ETH/USD PriceFeed Adaptor");
failIfTxStatusError(gzeEthPriceFeedTx, deployGroup1Message + " - GZE/ETH PriceFeed");
failIfTxStatusError(bonusListTx, deployGroup1Message + " - BonusList");
printTxData("makerDaoEthUsdPriceFeedTx", makerDaoEthUsdPriceFeedTx);
printTxData("makerDaoPriceFeedAdaptorTx", makerDaoPriceFeedAdaptorTx);
printTxData("gzeEthPriceFeedTx", gzeEthPriceFeedTx);
printTxData("bonusListTx", bonusListTx);
printEthUsdPriceFeedContractDetails();
printGzeEthPriceFeedContractDetails();
printBonusListContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var deployTokens1Message = "Deploy Tokens";
var numberOfTokens = $NUMBEROFTOKENS;
var _tokenSymbols = "$TOKENSYMBOLS".split(":");
var _tokenNames = "$TOKENNAMES".split(":");
var _tokenDecimals = "$TOKENDECIMALS".split(":");
var _tokenInitialSupplies = "$TOKENINITIALSUPPLIES".split(":");
var _tokenInitialDistributions = "$TOKENINITIALDISTRIBUTION".split(":");
var _tokenMintable = "$TOKENMINTABLE".split(":");
// console.log("RESULT: _tokenSymbols = " + JSON.stringify(_tokenSymbols));
// console.log("RESULT: _tokenNames = " + JSON.stringify(_tokenNames));
// console.log("RESULT: _tokenDecimals = " + JSON.stringify(_tokenDecimals));
// console.log("RESULT: _tokenInitialSupplies = " + JSON.stringify(_tokenInitialSupplies));
// console.log("RESULT: _tokenInitialDistributions = " + JSON.stringify(_tokenInitialDistributions));
// console.log("RESULT: _tokenMintable = " + JSON.stringify(_tokenMintable));
var transferable = true;
var i;
// -----------------------------------------------------------------------------
console.log("RESULT: ---------- " + deployTokens1Message + " ----------");
var tokenTxs = [];
var tokens = [];
for (i = 0; i < numberOfTokens; i++) {
  tokenTxs[i] = bttsFactory.deployBTTSTokenContract(_tokenSymbols[i], _tokenNames[i], _tokenDecimals[i], new BigNumber(_tokenInitialSupplies[i]).shift(_tokenDecimals[i]), _tokenMintable[i] == "true", transferable, {from: deployer, gas: 6000000, gasPrice: defaultGasPrice});
}
while (txpool.status.pending > 0) {
}
var tokenAddresses = getBTTSFactoryTokenListing();
for (i = 0; i < numberOfTokens; i++) {
  tokens[i] = eth.contract(bttsTokenAbi).at(tokenAddresses[i]);
  addAccount(tokenAddresses[i], "Token '" + tokens[i].symbol() + "' '" + tokens[i].name() + "'");
  addAddressSymbol(tokenAddresses[i], tokens[i].symbol());
  addTokenContractAddressAndAbi(i, tokenAddresses[i], bttsTokenAbi);
}
printBalances();
for (i = 0; i < numberOfTokens; i++) {
  failIfTxStatusError(tokenTxs[i], deployTokens1Message + " - Token '" + tokens[i].symbol() + "' '" + tokens[i].name() + "'");
}
for (i = 0; i < numberOfTokens; i++) {
  printTxData("tokenTx[" + i + "]", tokenTxs[i]);
}
console.log("RESULT: ");
for (i = 0; i < numberOfTokens; i++) {
  printTokenContractDetails(i);
  console.log("RESULT: ");
}
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var deployLandRushMessage = "Deploy FxxxLandRush";
var landRushAbi = JSON.parse(landRushOutput.contracts["$LANDRUSHSOL:FxxxLandRush"].abi);
var landRushBin = "0x" + landRushOutput.contracts["$LANDRUSHSOL:FxxxLandRush"].bin;
var initialParcelUsd = new BigNumber($INITIALPARCELUSD).shift(18);
var usdLockAccountThreshold = new BigNumber($USDLOCKACCOUNTTHRESHOLD).shift(18);
// -----------------------------------------------------------------------------
console.log("RESULT: ---------- " + deployLandRushMessage + " ----------");
var landRushContract = web3.eth.contract(landRushAbi);
var landRushTx = null;
var landRushAddress = null;
var landRush = landRushContract.new(tokenAddresses[$AAA], tokenAddresses[$GZE], makerDaoPriceFeedAdaptorAddress, gzeEthPriceFeedAddress, bonusListAddress, wallet, $START_DATE, $END_DATE, $INITIALMAXPARCELS, initialParcelUsd, usdLockAccountThreshold, $GZEBONUSOFFLIST, $GZEBONUSONLIST, {from: deployer, data: landRushBin, gas: 5000000, gasPrice: defaultGasPrice},
  function(e, contract) {
    if (!e) {
      if (!contract.address) {
        landRushTx = contract.transactionHash;
      } else {
        landRushAddress = contract.address;
        addAccount(landRushAddress, "FxxxLandRush");
        addLandRushContractAddressAndAbi(landRushAddress, landRushAbi);
        console.log("DATA: var landRushAddress=\"" + landRushAddress + "\";");
        console.log("DATA: var landRushAbi=" + JSON.stringify(landRushAbi) + ";");
        console.log("DATA: var landRush=eth.contract(landRushAbi).at(landRushAddress);");
      }
    }
  }
);
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(landRushTx, deployLandRushMessage + " - FxxxLandRush");
printTxData("landRushTx", landRushTx);
printLandRushContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var settingGroup1Message = "Setting Group #1";
// -----------------------------------------------------------------------------
console.log("RESULT: ---------- " + settingGroup1Message + " ----------");
var settingGroup1_setMinterTx = tokens[$AAA].setMinter(landRushAddress, {from: deployer, gas: 2000000, gasPrice: defaultGasPrice});
var users = [user1, user2, user3];
var settingGroup1_Txs = [];
users.forEach(function(u) {
  for (i = 0; i < numberOfTokens; i++) {
    var tx = tokens[i].transfer(u, new BigNumber(_tokenInitialDistributions[i]).shift(_tokenDecimals[i]), {from: deployer, gas: 2000000, gasPrice: defaultGasPrice});
    settingGroup1_Txs.push(tx);
  }
});
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(settingGroup1_setMinterTx, settingGroup1Message + " - AAA.setMinter(landRush)");
settingGroup1_Txs.forEach(function(t) {
  failIfTxStatusError(t, settingGroup1Message + " - Distribute tokens - " + t);
});
printTxData("settingGroup1_setMinterTx", settingGroup1_setMinterTx);
settingGroup1_Txs.forEach(function(t) {
  printTxData("", t);
});
console.log("RESULT: ");
for (i = 0; i < numberOfTokens; i++) {
  printTokenContractDetails(i);
  console.log("RESULT: ");
}
console.log("RESULT: ");


waitUntil("landRush.startDate", landRush.startDate(), 0);


// -----------------------------------------------------------------------------
var contribute1Message = "Contribute #1";
var gzeAmount1 = new BigNumber(200000).shift(18);
// -----------------------------------------------------------------------------
console.log("RESULT: ---------- " + contribute1Message + " ----------");
var contribute1_1Tx = tokens[$GZE].approveAndCall(landRushAddress, gzeAmount1, "", {from: user1, gas: 2000000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
var contribute1_2Tx = eth.sendTransaction({from: user2, to: landRushAddress, value: web3.toWei(25, "ether"), gas: 2000000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(contribute1_1Tx, contribute1Message + " - GZE.approveAndCall(landRush, " + gzeAmount1.shift(-18) + ", \"\")");
failIfTxStatusError(contribute1_2Tx, contribute1Message + " - sendTransaction(landRush, 25 ETH)");
printTxData("contribute1_1Tx", contribute1_1Tx);
printTxData("contribute1_2Tx", contribute1_2Tx);
console.log("RESULT: ");
printLandRushContractDetails();
console.log("RESULT: ");
for (i = 0; i < numberOfTokens; i++) {
  printTokenContractDetails(i);
  console.log("RESULT: ");
}
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var contribute2Message = "Contribute #2";
var gzeAmount2 = new BigNumber(400000).shift(18);
// -----------------------------------------------------------------------------
console.log("RESULT: ---------- " + contribute2Message + " ----------");
var contribute2_1Tx = tokens[$GZE].approve(landRushAddress, gzeAmount2, {from: user3, gas: 2000000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
var contribute2_2Tx = landRush.purchaseWithGze(gzeAmount2, {from: user3, to: landRushAddress, gas: 2000000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(contribute2_1Tx, contribute2Message + " - user3 GZE.approve(landRush, " + gzeAmount2.shift(-18) + ", \"\")");
failIfTxStatusError(contribute2_2Tx, contribute2Message + " - user3 landRush.purchaseWithGze(" + gzeAmount2.shift(-18) + ")");
printTxData("contribute2_1Tx", contribute2_1Tx);
printTxData("contribute2_2Tx", contribute2_2Tx);
console.log("RESULT: ");
printLandRushContractDetails();
console.log("RESULT: ");
for (i = 0; i < numberOfTokens; i++) {
  printTokenContractDetails(i);
  console.log("RESULT: ");
}
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var offlinePurchaseMessage = "Offline Purchase #1";
// -----------------------------------------------------------------------------
console.log("RESULT: ---------- " + offlinePurchaseMessage + " ----------");
var offlinePurchase_1Tx = landRush.offlinePurchase(user3, 5, {from: deployer, gas: 2000000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(offlinePurchase_1Tx, offlinePurchaseMessage + " - deployer landRush.offlinePurchase(user3, 5)");
printTxData("offlinePurchase_1Tx", offlinePurchase_1Tx);
console.log("RESULT: ");
printLandRushContractDetails();
console.log("RESULT: ");
for (i = 0; i < numberOfTokens; i++) {
  printTokenContractDetails(i);
  console.log("RESULT: ");
}
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var finaliseMessage = "Finalise";
// -----------------------------------------------------------------------------
if (!landRush.finalised()) {
  waitUntil("landRush.endDate", landRush.endDate(), 0);

  console.log("RESULT: ---------- " + finaliseMessage + " ----------");
  var finalise_1Tx = landRush.finalise({from: deployer, gas: 2000000, gasPrice: defaultGasPrice});
  while (txpool.status.pending > 0) {
  }
  printBalances();
  failIfTxStatusError(finalise_1Tx, finaliseMessage + " - deployer landRush.finalise()");
  printTxData("finalise_1Tx", finalise_1Tx);
  console.log("RESULT: ");
  printLandRushContractDetails();
  console.log("RESULT: ");
  for (i = 0; i < numberOfTokens; i++) {
    printTokenContractDetails(i);
    console.log("RESULT: ");
  }
  console.log("RESULT: ");
}


console.log("RESULT: ---------- GasUsed ----------");
printTxData("makerDaoPriceFeedAdaptorTx", makerDaoPriceFeedAdaptorTx);
printTxData("gzeEthPriceFeedTx", gzeEthPriceFeedTx);
printTxData("bonusListTx", bonusListTx);
printTxData("landRushTx", landRushTx);
printTxData("contribute1_1Tx", contribute1_1Tx);
printTxData("contribute1_2Tx", contribute1_2Tx);
printTxData("contribute2_1Tx", contribute2_1Tx);
printTxData("contribute2_2Tx", contribute2_2Tx);
printTxData("offlinePurchase_1Tx", offlinePurchase_1Tx);

EOF
grep "DATA: " $TEST1OUTPUT | sed "s/DATA: //" > $DEPLOYMENTDATA
cat $DEPLOYMENTDATA
grep "RESULT: " $TEST1OUTPUT | sed "s/RESULT: //" > $TEST1RESULTS
cat $TEST1RESULTS
