// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

// Importa els contractes de TokenRecepte i hospital
import "./TokenRecepte.sol";
import "./hospital.sol";

/// @title A contract that manages the tokens received by the pharmacy.
/// @author GerardoChevez21
contract farmacies{

    // Declara dos variables per guardar els contractes TokenRecepte i hospital
    TokenRecepte tokenRecepte;
    hospital Hospital;

    // Constructor que inicialitza el contracte i guarda les adreces dels contractes hospital i TokenRecepte en variables
    constructor(address _addressHospital, address _addressTokenRecepte){
        Hospital = hospital(_addressHospital);
        tokenRecepte = TokenRecepte(_addressTokenRecepte);
    }

    // Modificador que crida a la funció getFarmacia del contracte hospital per verificar si la direcció del remitent té un CIF associat
    modifier _isFarmacia() {
        require(bytes(Hospital.getCIFFarmacia(msg.sender)).length == 9, "No es farmacia!!!"); 
        _;
    }

    // Funció executada per farmàcies que crida a la funció burnToken del contracte TokenRecepte per cremar una recepta 
    function burnToken(uint _idRecepte) public _isFarmacia(){
        require(msg.sender == tokenRecepte.ownerOf(_idRecepte), "No es propietari de la recepta!!!");
        tokenRecepte.burnToken(_idRecepte);
    }
}