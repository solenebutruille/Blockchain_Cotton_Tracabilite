module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*", // Match any network id
      gas: 30000000//6721975

    }
  },
  solc: {
    optimizer: {
      enabled: true,
      runs: 200
    }
  }
}
