#!/bin/sh

# Check if process already running
# ps -ef | grep sh | grep genData | grep -v grep
number=$(ps -ef | grep sh | grep genData | grep -v grep | wc -l)
if [ $number -gt 2 ]; then
  echo "Process already running"
  exit;
fi

geth attach << EOF | grep "JSONSUMMARY:" | sed "s/JSONSUMMARY: //" > tmp.json
loadScript("lookups.js");
loadScript("deployment.js");


function generateSummaryJSON() {
  console.log("JSONSUMMARY: {");
  var blockNumber = eth.blockNumber;
  var timestamp = eth.getBlock(blockNumber).timestamp;
  console.log("JSONSUMMARY:   \"blockNumber\": " + blockNumber + ",");
  console.log("JSONSUMMARY:   \"blockTimestamp\": " + timestamp + ",");
  console.log("JSONSUMMARY:   \"blockTimestampString\": \"" + new Date(timestamp * 1000).toString() + "\",");
  console.log("JSONSUMMARY:   \"blockTimestampUTCString\": \"" + new Date(timestamp * 1000).toUTCString() + "\",");
  console.log("JSONSUMMARY:   \"makerDAOEthUsdPriceFeedAdaptorAddress\": \"" + makerDAOEthUsdPriceFeedAdaptorAddress + "\",");
  console.log("JSONSUMMARY:   \"makerDAOEthUsdPriceFeedAdaptorName\": \"" + getAddressName(makerDAOEthUsdPriceFeedAdaptorAddress) + "\",");
  console.log("JSONSUMMARY:   \"gzeEthPriceFeedAddress\": \"" + gzeEthPriceFeedAddress + "\",");
  console.log("JSONSUMMARY:   \"gzeEthPriceFeedName\": \"" + getAddressName(gzeEthPriceFeedAddress) + "\",");
  console.log("JSONSUMMARY:   \"bonusListAddress\": \"" + bonusListAddress + "\",");
  console.log("JSONSUMMARY:   \"bonusListName\": \"" + getAddressName(bonusListAddress) + "\",");
  var ethUsd = makerDAOEthUsdPriceFeedAdaptor.getRate();
  console.log("JSONSUMMARY:   \"ethUsdRate\": \"" + ethUsd[0].shift(-18) + "\",");
  console.log("JSONSUMMARY:   \"ethUsdLive\": \"" + ethUsd[1] + "\",");
  var gzeEth = gzeEthPriceFeed.getRate();
  console.log("JSONSUMMARY:   \"gzeEthRate\": \"" + gzeEth[0].shift(-18) + "\",");
  console.log("JSONSUMMARY:   \"gzeEthLive\": \"" + gzeEth[1] + "\",");

  var bonusListAccountListedEvents = bonusList.AccountListed({}, { fromBlock: bonusListFromBlock, toBlock: "latest" }).get();
  console.log("JSONSUMMARY:   \"numberOfBonusListAccountListedEvents\": " + bonusListAccountListedEvents.length + ",");
  console.log("JSONSUMMARY:   \"bonusListAccountListedEvents\": [");
  for (var i = 0; i < bonusListAccountListedEvents.length; i++) {
    var e = bonusListAccountListedEvents[bonusListAccountListedEvents.length - 1 - i];
    var separator;
    if (i == bonusListAccountListedEvents.length - 1) {
      separator = "";
    } else {
      separator = ",";
    }
    var b = eth.getBlock(e.blockNumber);
    var ts = b.timestamp;
    console.log("JSONSUMMARY:     { \"address\": \"" + e.args.account + "\", \"status\": \"" + e.args.status + "\", " +
    "\"timestamp\":" + ts + ", \"timestampUTCString\": \"" + new Date(ts * 1000).toUTCString() + "\" }" + separator);
  }
  console.log("JSONSUMMARY:   ],");

  var gzeEthPriceFeedSetRateEvents = gzeEthPriceFeed.SetRate({}, { fromBlock: gzeEthPriceFeedFromBlock, toBlock: "latest" }).get();
  console.log("JSONSUMMARY:   \"numberOfGzeEthPriceFeedSetRateEvents\": " + gzeEthPriceFeedSetRateEvents.length + ",");
  console.log("JSONSUMMARY:   \"gzeEthPriceFeedSetRateEvents\": [");
  for (var i = 0; i < gzeEthPriceFeedSetRateEvents.length; i++) {
    var e = gzeEthPriceFeedSetRateEvents[gzeEthPriceFeedSetRateEvents.length - 1 - i];
    var separator;
    if (i == gzeEthPriceFeedSetRateEvents.length - 1) {
      separator = "";
    } else {
      separator = ",";
    }
    var b = eth.getBlock(e.blockNumber);
    var ts = b.timestamp;
    console.log("JSONSUMMARY:     { \"newRate\": \"" + e.args.newRate.shift(-18) + "\", \"newLive\": \"" + e.args.newLive + "\", " +
      "\"oldRate\": \"" + e.args.oldRate.shift(-18) + "\", \"oldLive\": \"" + e.args.oldLive + "\", " +
      "\"timestamp\":" + ts + ", \"timestampString\": \"" + new Date(ts * 1000).toString() + "\", " +
      "\"timestampUTCString\": \"" + new Date(ts * 1000).toUTCString() + "\" }" + separator);
  }
  console.log("JSONSUMMARY:   ],");

  console.log("JSONSUMMARY:   \"numberOfTokens\": " + fxxxTokenAddresses.length + ",");
  console.log("JSONSUMMARY:   \"tokens\": [");
  for (var i = 0; i < fxxxTokenAddresses.length; i++) {
    var e = fxxxTokenAddresses[i];
    var fxxxToken = eth.contract(fxxxTokenAbi).at(e);
    var separator;
    if (i == fxxxTokenAddresses.length - 1) {
      separator = "";
    } else {
      separator = ",";
    }
    console.log("JSONSUMMARY:     {");
    console.log("JSONSUMMARY:       \"address\": \"" + e + "\",");
    console.log("JSONSUMMARY:       \"nameAddress\": \"" + getAddressName(e) + "\",");
    console.log("JSONSUMMARY:       \"symbol\": \"" + fxxxToken.symbol() + "\",");
    console.log("JSONSUMMARY:       \"name\": \"" + fxxxToken.name() + "\",");
    console.log("JSONSUMMARY:       \"minterAddress\": \"" + fxxxToken.minter() + "\",");
    console.log("JSONSUMMARY:       \"minterName\": \"" + getAddressName(fxxxToken.minter()) + "\",");
    console.log("JSONSUMMARY:       \"totalSupply\": " + fxxxToken.totalSupply().shift(-18) + ",");

    var fxxxTokenMintEvents = fxxxToken.Mint({}, { fromBlock: fxxxTokenFromBlock, toBlock: "latest" }).get();
    console.log("JSONSUMMARY:       \"numberOfFxxxTokenMintEvents\": " + fxxxTokenMintEvents.length + ",");
    console.log("JSONSUMMARY:       \"fxxxTokenMintEvents\": [");
    for (var i1 = 0; i1 < fxxxTokenMintEvents.length; i1++) {
      var e1 = fxxxTokenMintEvents[fxxxTokenMintEvents.length - 1 - i1];
      var separator1;
      if (i1 == fxxxTokenMintEvents.length - 1) {
        separator1 = "";
      } else {
        separator1 = ",";
      }
      var b1 = eth.getBlock(e1.blockNumber);
      var ts1 = b1.timestamp;
      console.log("JSONSUMMARY:         {");
      console.log("JSONSUMMARY:           \"txHash\": \"" + e1.transactionHash + "\",");
      console.log("JSONSUMMARY:           \"timestamp\":" + ts1 + ",");
      console.log("JSONSUMMARY:           \"timestampUTCString\": \"" + new Date(ts1 * 1000).toUTCString() + "\",");
      console.log("JSONSUMMARY:           \"tokenOwner\": \"" + e1.args.tokenOwner + "\",");
      console.log("JSONSUMMARY:           \"tokens\": " + e1.args.tokens.shift(-18) + ",");
      console.log("JSONSUMMARY:           \"lockAccount\": \"" + e1.args.lockAccount + "\"");
      console.log("JSONSUMMARY:         }" + separator1);
    }
    console.log("JSONSUMMARY:       ]");

    /*
    var fxxxTokenTransferEvents = fxxxToken.Transfer({}, { fromBlock: fxxxTokenFromBlock, toBlock: "latest" }).get();
    console.log("JSONSUMMARY:       \"numberOfFxxxTokenTransferEvents\": " + fxxxTokenTransferEvents.length + ",");
    console.log("JSONSUMMARY:       \"fxxxTokenTransferEvents\": [");
    for (var i1 = 0; i1 < fxxxTokenTransferEvents.length; i1++) {
      var e1 = fxxxTokenTransferEvents[fxxxTokenTransferEvents.length - 1 - i1];
      var separator1;
      if (i1 == fxxxTokenTransferEvents.length - 1) {
        separator1 = "";
      } else {
        separator1 = ",";
      }
      var b1 = eth.getBlock(e1.blockNumber);
      var ts1 = b1.timestamp;
      console.log("JSONSUMMARY:         {");
      console.log("JSONSUMMARY:           \"timestamp\":" + ts1 + ",");
      console.log("JSONSUMMARY:           \"timestampUTCString\": \"" + new Date(ts1 * 1000).toUTCString() + "\",");
      console.log("JSONSUMMARY:           \"from\": \"" + e1.args.from + "\",");
      console.log("JSONSUMMARY:           \"to\": \"" + e1.args.to + "\",");
      console.log("JSONSUMMARY:           \"tokens\": " + e1.args.tokens.shift(-18) + "");
      console.log("JSONSUMMARY:         }" + separator1);
    }
    console.log("JSONSUMMARY:       ]");
    */
    console.log("JSONSUMMARY:     }" + separator);
  }
  console.log("JSONSUMMARY:   ],");

  console.log("JSONSUMMARY:   \"numberOfFxxxLandRushes\": " + fxxxLandRushAddresses.length + ",");
  console.log("JSONSUMMARY:   \"fxxxLandRushes\": [");
  for (var i = 0; i < fxxxLandRushAddresses.length; i++) {
    var e = fxxxLandRushAddresses[i];
    var fxxxLandRush = eth.contract(fxxxLandRushAbi).at(e);
    var separator;
    if (i == fxxxLandRushAddresses.length - 1) {
      separator = "";
    } else {
      separator = ",";
    }
    console.log("JSONSUMMARY:     {");
    console.log("JSONSUMMARY:       \"address\": \"" + e + "\",");
    console.log("JSONSUMMARY:       \"nameAddress\": \"" + getAddressName(e) + "\",");
    console.log("JSONSUMMARY:       \"name\": \"" + fxxxLandRush.name() + "\",");
    console.log("JSONSUMMARY:       \"parcelTokenAddress\": \"" + fxxxLandRush.parcelToken() + "\",");
    console.log("JSONSUMMARY:       \"parcelTokenName\": \"" + getAddressName(fxxxLandRush.parcelToken()) + "\",");
    console.log("JSONSUMMARY:       \"gzeTokenAddress\": \"" + fxxxLandRush.gzeToken() + "\",");
    console.log("JSONSUMMARY:       \"gzeTokenName\": \"" + getAddressName(fxxxLandRush.gzeToken()) + "\",");
    console.log("JSONSUMMARY:       \"ethUsdPriceFeedAddress\": \"" + fxxxLandRush.ethUsdPriceFeed() + "\",");
    console.log("JSONSUMMARY:       \"ethUsdPriceFeedName\": \"" + getAddressName(fxxxLandRush.ethUsdPriceFeed()) + "\",");
    console.log("JSONSUMMARY:       \"gzeEthPriceFeedAddress\": \"" + fxxxLandRush.gzeEthPriceFeed() + "\",");
    console.log("JSONSUMMARY:       \"gzeEthPriceFeedName\": \"" + getAddressName(fxxxLandRush.gzeEthPriceFeed()) + "\",");
    console.log("JSONSUMMARY:       \"bonusListAddress\": \"" + fxxxLandRush.bonusList() + "\",");
    console.log("JSONSUMMARY:       \"bonusListName\": \"" + getAddressName(fxxxLandRush.bonusList()) + "\",");
    console.log("JSONSUMMARY:       \"walletAddress\": \"" + fxxxLandRush.wallet() + "\",");
    console.log("JSONSUMMARY:       \"walletName\": \"" + getAddressName(fxxxLandRush.wallet()) + "\",");
    console.log("JSONSUMMARY:       \"startDate\": " + fxxxLandRush.startDate() + ",");
    console.log("JSONSUMMARY:       \"startDateString\": \"" + new Date(fxxxLandRush.startDate() * 1000).toString() + "\",");
    console.log("JSONSUMMARY:       \"startDateUTCString\": \"" + new Date(fxxxLandRush.startDate() * 1000).toUTCString() + "\",");
    console.log("JSONSUMMARY:       \"endDate\": " + fxxxLandRush.endDate() + ",");
    console.log("JSONSUMMARY:       \"endDateString\": \"" + new Date(fxxxLandRush.endDate() * 1000).toString() + "\",");
    console.log("JSONSUMMARY:       \"endDateUTCString\": \"" + new Date(fxxxLandRush.endDate() * 1000).toUTCString() + "\",");
    console.log("JSONSUMMARY:       \"maxParcels\": " + fxxxLandRush.maxParcels() + ",");
    console.log("JSONSUMMARY:       \"parcelUsd\": " + fxxxLandRush.parcelUsd().shift(-18) + ",");
    console.log("JSONSUMMARY:       \"usdLockAccountThreshold\": " + fxxxLandRush.usdLockAccountThreshold().shift(-18) + ",");
    console.log("JSONSUMMARY:       \"gzeBonusOffList\": " + fxxxLandRush.gzeBonusOffList() + ",");
    console.log("JSONSUMMARY:       \"gzeBonusOnList\": " + fxxxLandRush.gzeBonusOnList() + ",");
    console.log("JSONSUMMARY:       \"parcelsSold\": " + fxxxLandRush.parcelsSold() + ",");
    console.log("JSONSUMMARY:       \"contributedGze\": " + fxxxLandRush.contributedGze().shift(-18) + ",");
    console.log("JSONSUMMARY:       \"contributedEth\": " + fxxxLandRush.contributedEth().shift(-18) + ",");
    console.log("JSONSUMMARY:       \"finalised\": \"" + fxxxLandRush.finalised() + "\",");

    var ethUsd = fxxxLandRush.ethUsd();
    console.log("JSONSUMMARY:       \"ethUsdRate\": " + ethUsd[0].shift(-18) + ",");
    console.log("JSONSUMMARY:       \"ethUsdLive\": \"" + ethUsd[1] + "\",");
    var gzeEth = fxxxLandRush.gzeEth();
    console.log("JSONSUMMARY:       \"gzeEthRate\": " + gzeEth[0].shift(-18) + ",");
    console.log("JSONSUMMARY:       \"gzeEthLive\": \"" + gzeEth[1] + "\",");
    var gzeUsd = fxxxLandRush.gzeUsd();
    console.log("JSONSUMMARY:       \"gzeUsdRate\": " + gzeUsd[0].shift(-18) + ",");
    console.log("JSONSUMMARY:       \"gzeUsdLive\": \"" + gzeUsd[1] + "\",");
    var parcelEth = fxxxLandRush.parcelEth();
    console.log("JSONSUMMARY:       \"parcelEthRate\": " + parcelEth[0].shift(-18) + ",");
    console.log("JSONSUMMARY:       \"parcelEthLive\": \"" + parcelEth[1] + "\",");
    var parcelGzeWithoutBonus = fxxxLandRush.parcelGzeWithoutBonus();
    console.log("JSONSUMMARY:       \"parcelGzeWithoutBonusRate\": " + parcelGzeWithoutBonus[0].shift(-18) + ",");
    console.log("JSONSUMMARY:       \"parcelGzeWithoutBonusLive\": \"" + parcelGzeWithoutBonus[1] + "\",");
    var parcelGzeWithBonusOffList = fxxxLandRush.parcelGzeWithBonusOffList();
    console.log("JSONSUMMARY:       \"parcelGzeWithBonusOffListRate\": " + parcelGzeWithBonusOffList[0].shift(-18) + ",");
    console.log("JSONSUMMARY:       \"parcelGzeWithBonusOffListLive\": \"" + parcelGzeWithBonusOffList[1] + "\",");
    var parcelGzeWithBonusOnList = fxxxLandRush.parcelGzeWithBonusOnList();
    console.log("JSONSUMMARY:       \"parcelGzeWithBonusOnListRate\": " + parcelGzeWithBonusOnList[0].shift(-18) + ",");
    console.log("JSONSUMMARY:       \"parcelGzeWithBonusOnListLive\": \"" + parcelGzeWithBonusOnList[1] + "\",");

    var fxxxLandRushPurchasedEvents = fxxxLandRush.Purchased({}, { fromBlock: fxxxLandRushBlock, toBlock: "latest" }).get();
    console.log("JSONSUMMARY:       \"numberOfFxxxLandRushPurchasedEvents\": " + fxxxLandRushPurchasedEvents.length + ",");
    console.log("JSONSUMMARY:       \"fxxxLandRushPurchasedEvents\": [");
    for (var i1 = 0; i1 < fxxxLandRushPurchasedEvents.length; i1++) {
      var e1 = fxxxLandRushPurchasedEvents[fxxxLandRushPurchasedEvents.length - 1 - i1];
      var separator1;
      if (i1 == fxxxLandRushPurchasedEvents.length - 1) {
        separator1 = "";
      } else {
        separator1 = ",";
      }
      var b1 = eth.getBlock(e1.blockNumber);
      var ts1 = b1.timestamp;
      console.log("JSONSUMMARY:         {");
      console.log("JSONSUMMARY:           \"txHash\": \"" + e1.transactionHash + "\",");
      console.log("JSONSUMMARY:           \"timestamp\":" + ts1 + ",");
      console.log("JSONSUMMARY:           \"timestampUTCString\": \"" + new Date(ts1 * 1000).toUTCString() + "\",");
      console.log("JSONSUMMARY:           \"addr\": \"" + e1.args.addr + "\",");
      console.log("JSONSUMMARY:           \"parcels\": " + e1.args.parcels + ",");
      console.log("JSONSUMMARY:           \"gzeToTransfer\": " + e1.args.gzeToTransfer.shift(-18) + ",");
      console.log("JSONSUMMARY:           \"ethToTransfer\": " + e1.args.ethToTransfer.shift(-18) + ",");
      console.log("JSONSUMMARY:           \"parcelsSold\": " + e1.args.parcelsSold + ",");
      console.log("JSONSUMMARY:           \"contributedGze\": " + e1.args.contributedGze.shift(-18) + ",");
      console.log("JSONSUMMARY:           \"contributedEth\": " + e1.args.contributedEth.shift(-18) + ",");
      console.log("JSONSUMMARY:           \"lockAccount\": \"" + e1.args.lockAccount + "\"");
      console.log("JSONSUMMARY:         }" + separator1);
    }
    console.log("JSONSUMMARY:       ]");

    console.log("JSONSUMMARY:     }" + separator);
  }
  console.log("JSONSUMMARY:   ]");
  console.log("JSONSUMMARY: }");
}

generateSummaryJSON();

EOF

mv tmp.json FxxxLandRushSummary.json
