pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

contract TrustOfChain{

    uint certificateNumber = 0;
    enum CertificateType { humanImpact, environnementImpact }

    mapping(address => GroupeAudit) groupeAudit;
    mapping(address => Actor) actors;
    mapping(uint => Certificate) public certificates;

    uint nbActor = 0;

    struct Certificate{
        uint id;
        Actor chainActor;
        GroupeAudit auditGroup;
        CertificateType certificateType;
        bool validated;
    }

    struct GroupeAudit{
        address account;
        string name;
        uint id;
    }

    struct Actor{
        uint id;
        address account;
        string name;
        string typeAct;
        string country;
        uint256 dbNum;
    }

    constructor() public {

        groupeAudit[0xb1b890aE2292c878b16bC11a652da1255d7E2a61] = GroupeAudit(0xb1b890aE2292c878b16bC11a652da1255d7E2a61, "Groupe Audit A", 0);
        groupeAudit[0x7CDeD932Cc982E81A0E1914dEEAfa7C602bcCabE] = GroupeAudit(0x7CDeD932Cc982E81A0E1914dEEAfa7C602bcCabE, "Groupe Audit B", 1);
        groupeAudit[0x50D6b8739caEe5Fe1DFC7b3bf939e2390A08bc41] = GroupeAudit(0x50D6b8739caEe5Fe1DFC7b3bf939e2390A08bc41, "Groupe Audit C", 2);

        actors[0x9B40eCBc96f5fde9E498D6183f156AEbB0a0D361] = Actor(0, 0x9B40eCBc96f5fde9E498D6183f156AEbB0a0D361, "Tony", "CottonWoods", "United States", 6);
        actors[0xCb8F292C0799379b9D24b681DFe173854FCe83a9] = Actor(1, 0xCb8F292C0799379b9D24b681DFe173854FCe83a9, "Johny", "Factory", "India", 90);

        Actor memory _a1 = actors[0x9B40eCBc96f5fde9E498D6183f156AEbB0a0D361];
        Actor memory _a2 = actors[0xCb8F292C0799379b9D24b681DFe173854FCe83a9];
        GroupeAudit memory _g1 = groupeAudit[0xb1b890aE2292c878b16bC11a652da1255d7E2a61];
        GroupeAudit memory _g2 = groupeAudit[0x7CDeD932Cc982E81A0E1914dEEAfa7C602bcCabE];
        GroupeAudit memory _g3;
        Certificate memory _c1 = Certificate(certificateNumber, _a1, _g1, CertificateType.environnementImpact, true);
        certificates[certificateNumber ++] = _c1;
        Certificate memory _c2 = Certificate(certificateNumber, _a2, _g2, CertificateType.humanImpact, true);
        certificates[certificateNumber ++] = _c2;
        Certificate memory _c3 = Certificate(certificateNumber, _a2, _g3, CertificateType.environnementImpact, false);
        certificates[certificateNumber ++] = _c3;

    }

    function validateCertificate(uint _certificateId) public{
        bool isGroupeAudit;
        GroupeAudit memory _ga;
        (isGroupeAudit, _ga) = getGroupeAudit();
        require(isGroupeAudit, "You are not a groupe Audit.");
        require(isCertificateIdValid(_certificateId), "Your certificate Id is not valid.");
        require(!certificates[_certificateId].validated, "Your certificate is already validated.");
        certificates[_certificateId].validated = true;
        certificates[_certificateId].auditGroup = _ga;
    }

    function getGroupeAudit() private view returns (bool, GroupeAudit memory){
        GroupeAudit memory _ga = groupeAudit[msg.sender];
        if(_ga.account == 0x0000000000000000000000000000000000000000) return (false, _ga);
        else return (true, _ga);
    }

    function isCertificateIdValid (uint _certificateId) private view returns (bool){
        Certificate memory _c = certificates[_certificateId];
        if(_c.chainActor.account == 0x0000000000000000000000000000000000000000) return false;
        else return true;
    }

    function isActor() private view returns (bool){
        Actor memory _a = actors[msg.sender];
        if(_a.account == 0x0000000000000000000000000000000000000000) return false;
        else return true;
    }

    function registerAsActor(string memory name, string memory typeAct, string memory country, uint256 dbNum) public{
        bool isGroupeAudit;
        GroupeAudit memory _ga;
        (isGroupeAudit, _ga) = getGroupeAudit();
        require(!isGroupeAudit, "You are registered as a group Audit.");
        require(!isActor(), "You are already registered as an actor.");
        Actor memory _a = Actor(nbActor++, msg.sender, name, typeAct, country, dbNum);
        actors[msg.sender] = _a;
    }

    function createCertificateDemand(CertificateType _certificateType) public{
        require(isActor(), "You must be an actor to create a certificate demand.");
        Actor memory _a = actors[msg.sender];
        GroupeAudit memory _g;
        Certificate memory _c = Certificate(certificateNumber, _a, _g, _certificateType, false);
        certificates[certificateNumber ++] = _c;
    }

    function seeCertificates() public view returns (string memory){
        string memory res;
        Certificate memory _c;
        for(uint i = 0; i < certificateNumber; i++){
            _c = certificates[i];
            res = string(abi.encodePacked(res, "**** ID : ", uintToStr(_c.id), "; Actor : ", _c.chainActor.typeAct, ", ", _c.chainActor.country, ", BDNum : ", uintToStr(_c.chainActor.dbNum), "; Audit Groupe : ", _c.auditGroup.name, "; Certificate Type : ", certToStr(_c.certificateType), "; Is Validated : ", boolToStr(_c.validated), "*****"));
        }
        return res;

    }

    function seeMyCertificatesDemande() public view returns (string memory){
        require(isActor(), "You must be an actor to see your certificates demand.");
        string memory res;
        Certificate memory _c;
        for(uint i = 0; i < certificateNumber; i++){
            _c = certificates[i];
            if(_c.chainActor.account == msg.sender && _c.validated == false) res = string(abi.encodePacked(res, "**** ID : ", uintToStr(_c.id), "; Actor : ", _c.chainActor.typeAct, "; Audit Groupe : ", _c.auditGroup.name, "; Certificate Type : ", certToStr(_c.certificateType), "; Is Validated : ", boolToStr(_c.validated), "*****"));
        }
        return res;
    }

    function seeMyCertificatesValidated() public view returns (string memory){
        require(isActor(), "You must be an actor to see your certificates validated.");
        string memory res;
        Certificate memory _c;
        for(uint i = 0; i < certificateNumber; i++){
            _c = certificates[i];
            if(_c.chainActor.account == msg.sender && _c.validated == true) res = string(abi.encodePacked(res, "**** ID : ", uintToStr(_c.id), "; Actor : ", _c.chainActor.typeAct, "; Audit Groupe : ", _c.auditGroup.name, "; Certificate Type : ", certToStr(_c.certificateType), "; Is Validated : ", boolToStr(_c.validated), "*****"));
        }
        return res;
    }

    function certToStr(CertificateType _cert) internal pure returns(string memory _certAsStr){
      if(_cert == CertificateType.environnementImpact) return "Environnement";
      else return "Social";
    }

    function boolToStr(bool _bool) internal pure returns (string memory _boolAsString) {
        if (_bool == false)  return "false";
        else return "true";
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
