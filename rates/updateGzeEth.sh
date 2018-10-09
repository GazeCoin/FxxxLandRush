#!/bin/bash
# ----------------------------------------------------------------------------------------------
# BokkyPooBah's Rate Updater
#
# Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2018. The MIT Licence.
# ----------------------------------------------------------------------------------------------

. settings

GAS=`curl -s https://ethgasstation.info/json/ethgasAPI.json | jq -r ".average"`
MARKETGZEETH=`curl -s https://api.coingecko.com/api/v3/coins/gazecoin | jq -r ".market_data.current_price.eth"`

geth attach << EOF | grep -v ">\s*$" | grep -v "undefined" | grep -v "\.\.\."

var pricefeedAddress = "0xD649c9b68BB78e8fd25c0B7a9c22c42f57768c91";
var pricefeedContract = web3.eth.contract([{"constant":true,"inputs":[],"name":"getRate","outputs":[{"name":"rate","type":"uint256"},{"name":"live","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"rate","type":"uint256"},{"name":"live","type":"bool"}],"name":"setRate","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"}]).at(pricefeedAddress);

console.log("now=" + new Date().toUTCString() + " " + new Date().toString());

var gasPrice = new BigNumber("$GAS").add("10.0").shift(8);
console.log("gasPrice=" + gasPrice + " = " + web3.fromWei(gasPrice, "gwei"));
var marketGzeEth = new BigNumber(new BigNumber("$MARKETGZEETH").toFixed(10)).shift(18);
console.log("marketGzeEth=" + marketGzeEth + " = " + web3.fromWei(marketGzeEth, "ether"));

var contractGzeEthInfo = pricefeedContract.getRate();
var contractGzeEth = contractGzeEthInfo[0];
console.log("contractGzeEth=" + contractGzeEth + " = " + web3.fromWei(contractGzeEth, "ether"));

var marketAndContractDiff = marketGzeEth.div(contractGzeEth);
console.log("marketAndContractDiff=" + marketAndContractDiff + " = " + web3.fromWei(marketAndContractDiff, "ether"));

var rateChangeTolerance = new BigNumber("$RATECHANGETOLERANCE");
var rateChangeUpperLimit = new BigNumber("1").add(rateChangeTolerance.div(100));
var rateChangeLowerLimit = new BigNumber("1").div(new BigNumber("1").add(rateChangeTolerance.div(100)));
console.log("rateChangeUpperLimit=" + rateChangeUpperLimit + " = " + web3.fromWei(rateChangeUpperLimit, "ether"));
console.log("rateChangeLowerLimit=" + rateChangeLowerLimit + " = " + rateChangeLowerLimit.shift(-18));

var rateChangeMax = new BigNumber("$RATECHANGEMAX");
var rateChangeUpperMax = new BigNumber("1").add(rateChangeMax.div(100));
var rateChangeLowerMax = new BigNumber("1").div(new BigNumber("1").add(rateChangeMax.div(100)));
console.log("rateChangeUpperMax=" + rateChangeUpperMax + " = " + web3.fromWei(rateChangeUpperMax, "ether"));
console.log("rateChangeLowerMax=" + rateChangeLowerMax + " = " + rateChangeLowerMax.shift(-18));

if (gasPrice > 0 &&
    marketGzeEth > 0 &&
    (marketAndContractDiff > rateChangeUpperLimit || marketAndContractDiff < rateChangeLowerLimit) &&
    (marketAndContractDiff < rateChangeUpperMax && marketAndContractDiff > rateChangeLowerMax)) {
  console.log("Replacing contractGzeEth=" + contractGzeEth + " = " + web3.fromWei(contractGzeEth, "ether"));
  console.log("With marketGzeEth=" + marketGzeEth + " = " + web3.fromWei(marketGzeEth, "ether"));
  console.log("With account $ACCOUNT");
  personal.unlockAccount("$ACCOUNT", "$PASSWORD");
  var tx = pricefeedContract.setRate(marketGzeEth, true, { from: "$ACCOUNT", gasPrice: gasPrice, gas: 40000 });
  eth.getTransaction(tx);
}

EOF
