pragma solidity ^0.5.0;

pragma experimental ABIEncoderV2;

// the Ether unit assumed for the contract is wei
contract plateformPSAT {
    actor[] actors;
    transaction[] tabTransact;

    mapping(uint => transaction) suiviIdProduct;    // idProduct with its transaction

    struct partnershipProposal {
      uint id;
  		actor asker;
  		actor needToAccept;
  		bool isAccepted;
  		bool askerIsFournisseur;
	}

    mapping(address => partnershipProposal[]) listPartnershipProposals;       // current balances

    uint nbActor = 0;
    uint nbTransac = 0;
    uint nbPartnershipProposal = 0;

    constructor() public{
      actors.push(new actor(0xb1b890aE2292c878b16bC11a652da1255d7E2a61, nbActor++, "Albert", "United States", "Cotton Woods", 12));
      actors.push(new actor(0x7CDeD932Cc982E81A0E1914dEEAfa7C602bcCabE, nbActor++, "Bernard", "Chine", "AB Farmer", 64));
      actors.push(new actor(0x50D6b8739caEe5Fe1DFC7b3bf939e2390A08bc41, nbActor++, "Cathy", "Canada", "AC Farmer", 50));
      actors.push(new actor(0x9B40eCBc96f5fde9E498D6183f156AEbB0a0D361, nbActor++, "Arnold", "India", "UA Factory", 78));
      actors.push(new actor(0xCb8F292C0799379b9D24b681DFe173854FCe83a9, nbActor++, "Baptiste", "Bangladesh", "UB Factory", 92));
      actors.push(new actor(0x316f3ebbBe6011072A361E6Fb2D0F49c99DC91a9, nbActor++, "Carnold", "Chine", "UC Factory", 242));
      actors.push(new actor(0xb4a73Aff3C51e014920219619DfA295c2CAd61Fc, nbActor++, "Ashley", "France", "MA Shop", 678));
      actors.push(new actor(0x2CC30A061B4719B4f91359cb826B31C9FE18761F, nbActor++, "Barnabe", "Birmanie", "MB Shop", 89));
      actors.push(new actor(0x65C087d9Ef1Fc3DBBD18EE525Dfd9e5E05aAAa48, nbActor++, "Candice", "Coree", "MC Shop", 82));

      actor _actorAA = actors[0];
      actor _actorAB = actors[1];
      actor _actorAC = actors[2];
      actor _actorUA = actors[3];
      actor _actorUB = actors[4];
      actor _actorUC = actors[5];
      actor _actorMA = actors[6];
      actor _actorMB = actors[7];
      actor _actorMC = actors[8];

      //partnership between farmer  and factory
      _actorAA.acceptPartnership(_actorUA, false);
      _actorUA.acceptPartnership(_actorAA, true);
      _actorAA.acceptPartnership(_actorUC, false);
      _actorUC.acceptPartnership(_actorAA, true);
      _actorAB.acceptPartnership(_actorUB, false);
      _actorUB.acceptPartnership(_actorAB, true);
      _actorAB.acceptPartnership(_actorUC, false);
      _actorUC.acceptPartnership(_actorAB, true);
      _actorAC.acceptPartnership(_actorUC, false);
      _actorUC.acceptPartnership(_actorAC, true);

      //partnership between factory and factory
      _actorUC.acceptPartnership(_actorUB, false);
      _actorUB.acceptPartnership(_actorUC, true);

      //partnership between factory and shop
      _actorUA.acceptPartnership(_actorMA, false);
      _actorMA.acceptPartnership(_actorUA, true);
      _actorUA.acceptPartnership(_actorMB, false);
      _actorMB.acceptPartnership(_actorUA, true);
      _actorUB.acceptPartnership(_actorMB, false);
      _actorMB.acceptPartnership(_actorUB, true);
      _actorUC.acceptPartnership(_actorMB, false);
      _actorMB.acceptPartnership(_actorUC, true);
      _actorUC.acceptPartnership(_actorMC, false);
      _actorMC.acceptPartnership(_actorUC, true);

      transaction t1 = new transaction(nbTransac++, _actorAA, _actorUA, "26/01/2021", 67);
      t1.addProductExitId(59);
      suiviIdProduct[59] = t1;
      tabTransact.push(t1);
      transaction t2 = new transaction(nbTransac++, _actorUA, _actorMA, "26/01/2021", 59);
      t2.addProductExitId(152);
      suiviIdProduct[152] = t2;
      tabTransact.push(t2);
      transaction t3 = new transaction(nbTransac++, _actorAB, _actorUC, "26/01/2021", 794);
      t3.addProductExitId(12);
      suiviIdProduct[12] = t3;
      tabTransact.push(t3);
      transaction t4 = new transaction(nbTransac++, _actorUC, _actorUB, "26/01/2021", 12);
      t4.addProductExitId(48);
      suiviIdProduct[48] = t4;
      tabTransact.push(t4);
      transaction t5 = new transaction(nbTransac++, _actorUB, _actorMB, "26/01/2021", 48);
      t5.addProductExitId(846);
      suiviIdProduct[846] = t5;
      tabTransact.push(t5);
    }

        //Adding an actor to the list
    function addActor(string memory _name, string memory _typeAct, string memory _country, uint256 _dbNum) public {
        //Check if actor already exists
        require(!isActor(msg.sender), "The user is already register.");
        //Adding  actor to the list
        actors.push(new actor(msg.sender, nbActor++, _name, _country, _typeAct, _dbNum));
    }

        //Creates a partnership proposal betwenn calling actor and actor with id in parameter
    function proposePartnership(uint actorId, bool isFournisseur) public {
        //find actors in list
        require(isActor(msg.sender), "You must be register as an actor to propose partnership.");
        require(isActor(actorId), "The actor id you want to partnership with is not valid.");

        actor askPartnership;
        actor isAskPartnership;

        (askPartnership, isAskPartnership) = findActorsInList(msg.sender, actorId);

        require(askPartnership != isAskPartnership, "You can't make partnership with yourself.");

        //proposePartnership
        listPartnershipProposals[isAskPartnership.getAccount()].push(partnershipProposal(nbPartnershipProposal++, askPartnership, isAskPartnership, false, isFournisseur));
    }

        //Actor accepts partnership, the partnership is installed
    function acceptPartnership(uint partnershipId) public{
        require(isActor(msg.sender), "You must be register as an actor to accept a partnership propositions.");
        partnershipProposal memory _acceptedProposal;
        bool proposalValid;
        (_acceptedProposal, proposalValid) = getAcceptedPartnershipProposal(partnershipId);
        require(proposalValid, "Your partnership id is not valid.");
        actor _actorAccepts = _acceptedProposal.needToAccept;
        actor _actorIsAccepted = _acceptedProposal.asker;
        require(_actorAccepts.getAccount() == msg.sender, "You can accept the proposal only if it was ask to you.");
        require(_acceptedProposal.isAccepted == true, "The proposition was already accepted.");
        _actorAccepts.acceptPartnership(_actorIsAccepted, _acceptedProposal.askerIsFournisseur);
        _actorIsAccepted.partnershipProposalAccepted(_actorAccepts, _acceptedProposal.askerIsFournisseur);
    }

    function createTransaction(uint _partnerId, string memory _date, uint _entranceProductId) public {
        require(isActor(msg.sender), "You must be an actor to create a transaction.");
        require(isActor(_partnerId), "The id of your partner is not valid.");
    //marche pas    require(isProductIdUnique(_entranceProductId), "The product id must unique, this one is already use");
        //require que les 2 acteurs soient partenaires
        actor _a1 = getActor(msg.sender);
        actor _a2 = getActor(_partnerId);
        require(_a1 != _a2, "You can't transact with yourself.");
        tabTransact.push(new transaction(nbTransac++, _a1, _a2, _date, _entranceProductId));
    }

    function addProductExitIdToTransaction(uint _transactionId, uint _productExitId) public{
        require(isProductIdUnique(_productExitId), "The product id must unique, this one is already use");
        bool valid;
        transaction _t;
        (valid, _t) = getTransaction(_transactionId);
        require(valid, "The id of your transaction is not valid.");
        _t.addProductExitId(_productExitId);
        suiviIdProduct[_productExitId] = _t;
    }

    function getProductHistory(uint _productId) public view returns (string memory){
        string memory res = "";
        transaction _t = suiviIdProduct[_productId];
        if(!(address(_t) == 0x0000000000000000000000000000000000000000)){
            res = string(abi.encodePacked(res, _t.toString(), " \n"));
            res = string(abi.encodePacked(res, getProductHistory(_t.getProductEntranceId()), " \n"));
        }
        return res;
    }


    //Check on input informations and memory informations

    function isActor(address checkAdresse) private view returns (bool){
	    for(uint i = 0; i < actors.length; i++){
	       if(actors[i].getAccount() == checkAdresse) return true;
	    }
	    return false;
	}

	function isActor(uint _actorId) private view returns (bool){
	    for(uint i = 0; i < actors.length; i++){
	       if(actors[i].getId() == _actorId) return true;
	    }
	    return false;
	}

	function isProductIdUnique(uint _entranceProductId) private view returns (bool){
	    transaction _t = suiviIdProduct[_entranceProductId];
        return (address(_t) == 0x0000000000000000000000000000000000000000);
	}


	//Getters

	    //display all actors
	function seeActors() public view returns(string memory){
        string memory res;
	    for(uint i = 0; i < actors.length; i++){
	        res = string(abi.encodePacked(res, actors[i].toString(), "\n"));
	    }
	    return res;
    }
        //display all transactions
	function seeTransactions() public view returns(string memory){
        string memory res;
	    for(uint i = 0; i < tabTransact.length; i++){
	        res = string(abi.encodePacked(res, tabTransact[i].toString(), "\n"));
	    }
	    return res;
    }

        //display all partners from calling actor
    function seePartners() public view returns(string memory){
        require(isActor(msg.sender), "You must be register as an actor to see your partners.");
        return getActor(msg.sender).seePartners();
    }

        //display all partnership proposals
    function seePartnershipProposals() public view returns(partnershipProposal[] memory){
        require(isActor(msg.sender), "You must be register as an actor to see your partnership propositions.");
        require(listPartnershipProposals[msg.sender].length != 0, "You don't have any partnership proposal.");
        return listPartnershipProposals[msg.sender];
    }

    function getTransaction(uint _id) private view returns (bool, transaction){
        transaction t;
        for(uint i = 0; i < tabTransact.length; i++){
            if(tabTransact[i].getId() == _id) return (true, tabTransact[i]);
	    }
	    return(false, t);
    }

        //return actor from given address
    function getActor(address checkAdresse) private view returns (actor){
        for(uint i = 0; i < actors.length; i++){
	       if(actors[i].getAccount() == checkAdresse) return actors[i];
	    }
    }

        //return actor from given id
    function getActor(uint _id) private view returns (actor){
        for(uint i = 0; i < actors.length; i++){
	       if(actors[i].getId() == _id) return actors[i];
	    }
    }

        //return actors from given address and id
    function findActorsInList(address checkAdresse, uint actorId) private view returns(actor, actor){
	    actor askPartnership;
	    actor isAskPartnership;

	    for(uint i = 0; i < actors.length; i++){
	        if(actors[i].getAccount() == checkAdresse) askPartnership = actors[i];
	        if(actors[i].getId() == actorId) isAskPartnership = actors[i];
	    }

	    return (askPartnership, isAskPartnership);
	}

	    //returns partnership proposal from given id
	function getAcceptedPartnershipProposal(uint partnershipId) private view returns (partnershipProposal memory, bool){
        partnershipProposal[] memory partnershipList = listPartnershipProposals[msg.sender];
        partnershipProposal memory pp;
        for(uint i = 0; i < partnershipList.length; i++){
	       if(partnershipList[i].id == partnershipId) {
	           partnershipList[i].isAccepted = true;
	           return (partnershipList[i], true);
	       }
	    }
	    return (pp, false);
    }

        //returns all potential direct and indirect prestataire
    function seeAllPotentielFournisseurs(uint _actorId) public view returns (string memory){
        string memory res;
        require(isActor(_actorId), "You must be register as an actor to see your potential fournisseurs.");
        //reccuperer l'actor
        actor _actor = getActor(_actorId);
        //reccuperer ses partenaires
        actor[] memory fournisseurActor = _actor.getFournisseurs();

        if(fournisseurActor.length != 0){
            res = string(abi.encodePacked("Fournisseurs of : ", _actor.getType(), " --> "));
            for(uint i = 0; i < fournisseurActor.length; i++){
                res = string(abi.encodePacked(res, "*** ", fournisseurActor[i].getType(), ", ", fournisseurActor[i].getCountry(), ", DBNum : ", uintToStr(fournisseurActor[i].getDbNum()), " ***"));
                res = string(abi.encodePacked(res, seeAllPotentielFournisseurs(fournisseurActor[i].getId()), " \n"));
            }
        }

        return res;
    }

    function uintToStr(uint _i) internal pure returns (string memory _uintAsString) {
          uint number = _i;
          if (number == 0) {
              return "0";
          }
          uint j = number;
          uint len;
          while (j != 0) {
              len++;
              j /= 10;
          }
          bytes memory bstr = new bytes(len);
          uint k = len - 1;
          while (number != 0) {
              bstr[k--] = byte(uint8(48 + number % 10));
              number /= 10;
          }
          return string(bstr);
      }

}

contract transaction {

    actor mandataire;
    actor prestataire;
    string date;

    uint id;

    uint256 productEntranceId;
    uint256[] productExitId;

    bool finish;

    constructor(uint _id, actor _mandataire, actor _prestataire, string memory _date, uint _productEntranceId) public {
        id =_id;
        mandataire = _mandataire;
        prestataire = _prestataire;
        date = _date;
        productEntranceId = _productEntranceId;
    }

    //Getters / Setters

    function getId() public view returns(uint){
        return id;
    }

    function getPrestataire() public view returns (actor) {
        return prestataire;
    }

    function getMandataire() public view returns (actor) {
        return mandataire;
    }

    function getDate() public view returns (string memory) {
        return date;
    }

    function toString() public view returns (string memory) {
        return string(abi.encodePacked("*** Transaction ID : ", uintToStr(id), " | Entrance Product Id : ", uintToStr(productEntranceId), ", Exit Product Id : ", seeProductExitId(), " | Fournisseur : ", mandataire.getType(), ", ", mandataire.getCountry(), ", BD Number : ", uintToStr(mandataire.getDbNum()), " | Acheteur : ",  prestataire.getType(), ", ", prestataire.getCountry(), ", BD Number : ", uintToStr(prestataire.getDbNum()), "***"));
    }

    function getProductEntranceId() public view returns(uint){
        return productEntranceId;
    }

    //returns true if id already exists else false
    function isProductEntranceId(uint256 _num) public view returns (bool) {
        if(productEntranceId == _num) return true;
        else return false;
    }

    function isProductExitId(uint256 _num) public view returns (bool) {
        bool exist = false;
        for(uint i = 0; i < productExitId.length; i++){
           if(productExitId[i] == _num){
               exist = true;
           }
        }
        return exist;
    }

    //return true if add correctly else false
    function addProductEntranceId(uint256 _num) public returns (bool) {
        productEntranceId = _num;
    }

    //return true if add correctly else false
    function addProductExitId(uint256 _num) public returns (bool) {
        if(!isProductExitId(_num)){
            productExitId.push(_num);
            //require(!isProductEntranceId(_num), "Number added.");
        }
        else{
            require(isProductExitId(_num), "This number already exists in the list.");
        }
    }

    function seeProductExitId() public view returns (string memory) {
        string memory res;
        for(uint i = 0; i < productExitId.length; i++){
            res = string(abi.encodePacked(res, uintToStr(productExitId[i]), ","));
        }
        return res;
    }

    //Internal Practical Function

    function uintToStr(uint _i) internal pure returns (string memory _uintAsString) {
        uint number = _i;
        if (number == 0) {
            return "0";
        }
        uint j = number;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len - 1;
        while (number != 0) {
            bstr[k--] = byte(uint8(48 + number % 10));
            number /= 10;
        }
        return string(bstr);
    }

}

contract actor {

    uint id;
    string name;
    string typeAct;
    string country;
    uint256 dbNum;

    actor[] fournisseurs;
    actor[] acheteurs;

    address payable account;


    constructor(address payable _account, uint _id, string memory _name, string memory _country, string memory _typeAct, uint256 _dbNum) public {
        account = _account;
        id = _id;
        country = _country;
        name = _name;
        typeAct = _typeAct;
        dbNum = _dbNum;
    }

    function toString() public view returns (string memory){
        return string(abi.encodePacked("--- Id = ", uintToStr(id), " | ", name, ", ", typeAct, ", ", country, " | DBNum : ", uintToStr(dbNum), " ---"));
    }

   //Functions

        //When you accept a partnership, the actor goes in your mandataire or prestataire list depending on his function
    function acceptPartnership(actor acceptedPartner, bool askerIsFournisseur) public {
        if(askerIsFournisseur) fournisseurs.push(acceptedPartner);
        else acheteurs.push(acceptedPartner);
    }
        //When your proposal of partnership is accepted, the actor goes in your mandataire or prestataire list depending on his function
    function partnershipProposalAccepted(actor acceptedPartner, bool askerIsFournisseur) public {
        if(askerIsFournisseur) acheteurs.push(acceptedPartner);
        else fournisseurs.push(acceptedPartner);
    }

     //Getters

	function getId() public view returns (uint) {
		return id;
	}

	function getName() public view returns (string memory) {
		return name;
	}

	function getType() public view returns (string memory) {
		return typeAct;
	}

	function getDbNum() public view returns (uint) {
		return dbNum;
	}

    function getAccount() public view returns (address) {
		return account;
	}

  function getCountry() public view returns (string memory) {
  return country;
}

	    //display list of partners
	function seePartners() public view returns(string memory){
	    string memory res = string(abi.encodePacked("Partners of ", typeAct," : "));
	    if(fournisseurs.length != 0){
	        res = string(abi.encodePacked(res, "*** Fournisseurs --> "));
    	    for(uint i = 0; i < fournisseurs.length; i++){
    	        res = string(abi.encodePacked(res, fournisseurs[i].toString(), "\n"));
    	    }
          res = string(abi.encodePacked(res, " ***"));
	    }
	    if(acheteurs.length != 0){
    	    res = string(abi.encodePacked(res, "*** Acheteurs --> "));
    	    for(uint i = 0; i < acheteurs.length; i++){
    	        res = string(abi.encodePacked(res, acheteurs[i].toString(), "\n"));
    	    }
          res = string(abi.encodePacked(res, " ***"));
	    }
    	return res;
	}

	function getAcheteurs() public view returns (actor[] memory){
	    return acheteurs;
	}

	function getFournisseurs() public view returns (actor[] memory){
	    return fournisseurs;
	}

    //Internal Practical Function

	function uintToStr(uint _i) internal pure returns (string memory _uintAsString) {
        uint number = _i;
        if (number == 0) {
            return "0";
        }
        uint j = number;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len - 1;
        while (number != 0) {
            bstr[k--] = byte(uint8(48 + number % 10));
            number /= 10;
        }
        return string(bstr);
    }
}
