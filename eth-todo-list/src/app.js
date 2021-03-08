App = {
  contracts: {},
  load: async () => {
    //load app ..
    console.log("app loading. . .")
    await App.loadWeb3()
    await App.loadAccount()
    await App.loadContract()
  //  await App.addPrestataire("ok", "ok", "ok")
  },

  // https://medium.com/metamask/https-medium-com-metamask-breaking-change-injecting-web3-7722797916a8
  loadWeb3: async () => {
    if (typeof web3 !== 'undefined') {
      App.web3Provider = web3.currentProvider
      web3 = new Web3(web3.currentProvider)
    } else {
      window.alert("Please connect to Metamask.")
    }
    // Modern dapp browsers...
    if (window.ethereum) {
      window.web3 = new Web3(ethereum)
      try {
        // Request account access if needed
        await ethereum.enable()
        // Acccounts now exposed
    //    web3.eth.sendTransaction({/* ... */})
      } catch (error) {
        // User denied account access...
      }
    }
    // Legacy dapp browsers...
    else if (window.web3) {
      App.web3Provider = web3.currentProvider
      window.web3 = new Web3(web3.currentProvider)
      // Acccounts always exposed
      web3.eth.sendTransaction({/* ... */})
    }
    // Non-dapp browsers...
    else {
      console.log('Non-Ethereum browser detected. You should consider trying MetaMask!')
    }
  },

  loadAccount: async () => {
    var accounts;
// in web front-end, use an onload listener and similar to this manual flow ...
    await web3.eth.getAccounts(function(err,res) { accounts = res; console.log(res);});
console.log(accounts);
    App.account = web3.eth.accounts[0]
    console.log(App.account)
    console.log(web3.eth.accounts)
  },

  loadContract: async() => {
    //create a JavaScript version of the smart contract
    const plateform = await $.getJSON('plateform.json')
    //allow us to interact with the smart contract and call the function we created
    App.contracts.Plateform = TruffleContract(plateform)
    App.contracts.Plateform.setProvider(App.web3Provider)
    //fill the contract with values from the blockchain
    App.plateform = App.contracts.Plateform.deployed()
    console.log(App.plateform)
  },

  seePrestataire: async () => {
    App.plateform.then(async (thePlateform) => {
      res_prestas = await thePlateform.seePrestataires.call();
      console.log(res_prestas);
    });
  },

  seeServices: async () => {
    App.plateform.then(async (thePlateform) => {
      res_prestas = await thePlateform.seeServices.call();
      console.log(res_prestas);
    });
  },

  seeMyServices: async () => {
    App.plateform.then(async (thePlateform) => {
      res_prestas = await thePlateform.seeMyServices.call();
      console.log(res_prestas);
    });
  },

  addPrestataire: async() =>{
    var _name = await $('#nameAddPresta').val();
    var _city = await $('#cityAddPresta').val();
    var _role = await $('#roleAddPresta').val();
    App.plateform.then(async (thePlateform) => {
      await thePlateform.addPrestataire(_name, _city, _role);
    });
  },

  addMandataire: async() =>{
    var _name = await $('#nameAddManda').val();
    var _city = await $('#cityAddManda').val();
    App.plateform.then(async (thePlateform) => {
      await thePlateform.addMandataire(_name, _city);
    });
  },

  askService: async() =>{
    var _prestaId = await $('#prestaIdAsk').val();
    var _serviceType = await $('#serviceTypeAsk').val();
    var _price = await $('#priceAsk').val();
    var _depositPercentage = await $('#depositPercentageAsk').val();
    App.plateform.then(async (thePlateform) => {
      await thePlateform.askService(_prestaId, _serviceType, _price, _depositPercentage);
    });
  },

  acceptService: async(_serviceId) =>{
    var _serviceId = await $('#serviceIdAccept').val();
    App.plateform.then(async (thePlateform) => {
      await thePlateform.acceptService(_serviceId);
    });
  },

  payDeposit: async(_serviceId) =>{
    var _serviceId = await $('#serviceIdDeposit').val();
    var _amountDeposit = await $('#amountDeposit').val();
    App.plateform.then(async (thePlateform) => {
      await thePlateform.payDeposit(_serviceId, {value: _amountDeposit});
    });
  },

  executeService: async(_serviceId) =>{
    var _serviceId = await $('#serviceIdExecute').val();
    App.plateform.then(async (thePlateform) => {
      await thePlateform.executeService(_serviceId);
    });
  },

  payFinalPrice: async(_serviceId) =>{
    var _serviceId = await $('#serviceIdFinalPrice').val();
    var _amountFinalPrice = await $('#amountFinalPrice').val();
    App.plateform.then(async (thePlateform) => {
      await thePlateform.payFinalPrice(_serviceId,{value:_amountFinalPrice});
    });
  },

  withdraw: async() =>{
    App.plateform.then(async (thePlateform) => {
      await thePlateform.withdraw();
    });
  }
}

$(() => {
  $(window).load(() => {
    App.load()
  })
})
