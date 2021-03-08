const TrustOfChain = artifacts.require("./TrustOfChain.sol");

module.exports = function(deployer) {
  deployer.deploy(TrustOfChain);
};
