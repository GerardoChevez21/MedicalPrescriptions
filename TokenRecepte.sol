// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

// Importa els contractes de ERC721 i Ownable
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title A contract that manages prescriptions.
/// @author GerardoChevez21
/// @dev Compliant with OpenZeppelin's implementation of the ERC721 and Ownable spec draft.
contract TokenRecepte is ERC721,Ownable{

    // Events triggered when new prescriptions or transfers happens
    event newPrescription(uint id, address indexed metge, address indexed pacient);
    event newTransfer(address indexed sender, address indexed receiver, uint tokenId);


    // Identificador de recepta
    uint private idPrescription;
    // Preu de transferència del token per defecte 0,01 ETH = 10000000000000000 Wei
    uint public transferPrice = 10000000000000000 wei;

    // Estructura de les receptes
    struct Prescription{
        uint id;
        address Metge;
        address Pacient;
        string idPacient;
        uint ium;
        string nomMedicament;
        uint caducitat;
        string estat;
    }

    // Array per guardar les receptes
    Prescription[] public prescriptions;
    
    // Constructor que permet inicialitzar el contracte amb un nom i símbol per al token i inicialitza el identificador de recepta a 0
    constructor(string memory _nom, string memory _simbol) ERC721(_nom, _simbol){
        idPrescription=0;   
    }

    // Funció per modificar el preu de transferència del token(Wei)
    function setTransferPrice(uint _transferPrice) public onlyOwner{
        transferPrice = _transferPrice;
    }

    // Funció que crida a la funció _safeMint del contracte ERC721 per crear una nova recepta 
    function createPrescription(address _Pacient, string memory _idPacient, uint _ium, string memory _nomMedicament, uint _caducitat) external{
        prescriptions.push(Prescription(idPrescription, msg.sender, _Pacient, _idPacient, _ium, _nomMedicament, _caducitat, "No utilitzada"));
        _safeMint(_Pacient, idPrescription);
        idPrescription++;
        emit newPrescription(idPrescription, msg.sender, _Pacient);
    }

    // Funció que crida a la funció transferFrom del contracte ERC721 per enviar una recepta   
    function sendPrescription(address _addressPacient, address _to, uint _idRecepte) external{      
        transferFrom(_addressPacient, _to, _idRecepte);
        prescriptions[_idRecepte].estat = "Utilitzada";
        emit newTransfer(msg.sender, _to, _idRecepte);
    }

    // Funció que crida a la funció _burn del contracte ERC721 per cremar una recepta amb un cert identificador
    function burnToken(uint _Tokenid) external{
        _burn(_Tokenid);
    }

    // Funció que permet veure les receptes associades a una adreça
    function viewPrescriptions(address _owner) public view returns (Prescription[] memory){
        Prescription[] memory result = new Prescription[](balanceOf(_owner));
        uint comptador_owner = 0;
        for(uint i=0; i<prescriptions.length; i++){
            if(ownerOf(i) == _owner){
                result[comptador_owner] = prescriptions[i];
                comptador_owner++;
            }
        }
        return result;
    } 
}