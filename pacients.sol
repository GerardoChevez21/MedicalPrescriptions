// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

// Importa els contractes de TokenRecepte i hospital
import "./TokenRecepte.sol";
import "./hospital.sol";

/// @title A contract that manages the registration of patients and their transfer of prescriptions to pharmacies.
/// @author GerardoChevez21
contract pacients {
    
    // Events triggered when new patient is registered or when a new transfer happens
    event newPatient(address indexed patient, string id, string name);
    event newTransfer(address indexed patient, address indexed pharmacy, uint id);

    // Declara dos variables per guardar els contractes TokenRecepte i hospital
    TokenRecepte tokenRecepte;
    hospital Hospital;

    // Constructor que inicialitza el contracte i guarda les adreces dels contractes hospital i TokenRecepte en variables
    constructor(address _addressHospital, address _addressTokenRecepte){
        Hospital = hospital(_addressHospital);
        tokenRecepte = TokenRecepte(_addressTokenRecepte);
    }

    // Modificador que crida a la funció getPacientFromDNI del contracte hospital per verificar si el DNI no es troba utilitzat
    modifier _isValidDNI(string memory _dni) {
        require(bytes(_dni).length == 9, "Introdueix el DNI!!!");
        require(Hospital.getPacientFromDNI(_dni) == address(0), "El DNI es troba utilitzat!!!"); 
        _;
    }

    // Modificador que crida a la funció getCIFFarmacia del contracte hospital per verificar si la direcció del remitent está associada a un CIF d'una farmàcia
    modifier _isFarmacia(address _address) {
        require(bytes(Hospital.getCIFFarmacia(_address)).length == 9, "No es farmacia!!!"); 
        _;
    }

    // Funció que crida a la funció afegeixPacient del contracte hospital per afegir un nou pacient a l'hospital
    function afegeixPacient(string memory _dni, string memory _nom) public _isValidDNI(_dni){
        require(bytes(_nom).length != 0, "Introdueix el nom!!!");
        Hospital.afegeixPacient(msg.sender, _dni, _nom);
        emit newPatient(msg.sender, _dni, _nom);
    }

    /* Funció que transferir la recepta a la farmàcia a canvi d'una certa quantitat d'ether a pagar a la farmàcia
    i crida a la funció sendPrescription del contracte TokenRecepte per realitzar l'enviament del token */
    function sendPrescription(address payable _to, uint _id) public payable _isFarmacia(_to){
        require(msg.value == tokenRecepte.transferPrice(), "No te suficient ether!!!");
        require(msg.sender == tokenRecepte.ownerOf(_id), "No es propietari de la recepta!!!");
        // Call retorna un booleà que indica si s'ha enviat correctament
        (bool sent,) = _to.call{value: msg.value}("");
        require(sent, "Error al enviar ether!!!");
        tokenRecepte.sendPrescription(msg.sender, _to, _id);
        emit newTransfer(msg.sender, _to, _id);
    }
}