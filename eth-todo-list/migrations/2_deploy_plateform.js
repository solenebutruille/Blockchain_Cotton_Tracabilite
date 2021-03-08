const PlateformPSAT = artifacts.require("./PlateformPSAT.sol");

module.exports = function(deployer) {
  deployer.deploy(PlateformPSAT);
};
