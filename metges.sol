// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

// Importa els contractes de TokenRecepte i hospital
import "./TokenRecepte.sol";
import "./hospital.sol";

/// @title A contract that manages the minting of the tokens by the doctors.
/// @author GerardoChevez21
contract metges{

    // Event triggered when new prescriptions happens
    event newPrescription(address indexed patient, string id, uint ium);

    // Declara dos variables per guardar els contractes TokenRecepte i hospital
    TokenRecepte tokenRecepte;
    hospital Hospital;

    // Constructor que inicialitza el contracte i guarda les adreces dels contractes hospital i TokenRecepte en variables
    constructor(address _addressHospital, address _addressTokenRecepte){
        Hospital = hospital(_addressHospital);
        tokenRecepte = TokenRecepte(_addressTokenRecepte);
    }

    // Modificador que crida a la funció getDNIMetge del contracte hospital per verificar si la direcció del remitent está associada a un DNI d'un metge
    modifier _isMetge() {
        require(bytes(Hospital.getDNIMetge(msg.sender)).length == 9, "No es Metge!!!");  
        _;
    }

    // Funció executada per metges que crida a la funció createPrescription del contracte TokenRecepte per receptar una recepte a un pacient
    function createPrescription(address _Pacient, string memory _idPacient, uint _ium, string memory _nomMedicament, uint _caducitat) public  _isMetge(){
        require(_Pacient != msg.sender, "El destinatari de la recepta no pot ser el mateix metge!!!");
        require(bytes(Hospital.getDNIPacient(_Pacient)).length == 9, "El identificador no pertany a un pacient de l'hospital!!!");
        require(_numDigits(_ium) == 13, "El IUM es incorrecte!!!");
        require(bytes(_nomMedicament).length != 0, "Introdueix el nom del medicament!!!");
        require(_numDigits(_caducitat) == 10, "Introdueix la data de caducitat!!!");
        tokenRecepte.createPrescription(_Pacient, _idPacient, _ium, _nomMedicament, _caducitat);
        emit newPrescription(_Pacient, _idPacient, _ium);
    }

     // Funció auxiliar que retona el nombre de digits que conté un nombre
    function _numDigits(uint number) internal pure returns (uint8) {
        uint8 digits = 0;

        while (number != 0) {
            number /= 10;
            digits++;
        }
        return digits;
    }  
}