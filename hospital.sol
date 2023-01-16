// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

// Importa els contractes de Ownable, TokenRecepte, farmacies, metges i pacients 
import "@openzeppelin/contracts/access/Ownable.sol";
import "./TokenRecepte.sol";
import "./farmacies.sol";
import "./metges.sol";
import "./pacients.sol";

/// @title A contract that manages hospital functions, such as adding new doctors, pharmacies...
/// @author GerardoChevez21
/// @dev Compliant with OpenZeppelin's implementation of the Ownable spec draft.
contract hospital is Ownable{

    // Events triggered when adding new pharmacies or doctors
    event newPharmacy(address pharmacy, string cif, string name , string location);
    event newDoctor(address doctor, string cif, string name);
    
    // Variable per guardar l'adreça del contracte TokenRecepte
    address TokenRecepteContractAddress;

    // Declara tres variables per guardar els contractes de metges, pacients i farmàcies
    metges MetgesContract;
    pacients PacientsContract;
    farmacies FarmaciesContract;
    
    // Constructor que permet inicialitzar el contracte a partir de l'adreça del contracte de TokenRecepte 
    constructor(address _tokenRecepteContractAddress){
        TokenRecepteContractAddress =  _tokenRecepteContractAddress;
    }

    // Funció per desplegar els contractes de metges, pacients i farmàcies i retorna les adreces dels contractes
    function deployContracts() public onlyOwner returns (address,address,address){
        MetgesContract = new metges(address (this), TokenRecepteContractAddress);
        PacientsContract = new pacients(address (this), TokenRecepteContractAddress);
        FarmaciesContract = new farmacies(address (this), TokenRecepteContractAddress);
        return (address(MetgesContract),address(PacientsContract),address(FarmaciesContract));     
    }

    // Estructura de les farmàcies, metges i pacients
    struct Farmacia{
        address adreca;
        string cif;
        string nom;
        string ubicacio;
    }

    struct Metge{
        address adreca;
        string dni;
        string nom;
    }

    struct Pacient{
        address adreca;
        string dni;
        string nom;
    }

    // Arrays per guardar les farmàcies, metges i pacients
    Farmacia[] public Farmacies;
    Metge[] public Metges;
    Pacient[] public Pacients;
    
    /* Mappigs per obtenir les adreces de les farmàcies, metges i pacients a partir del seu identificador i viceversa,
    així com un comptador de farmàcies, metges i pacients registrats a l'hospital */
    mapping (address => string) public OwnerToCIF;
    mapping (string => address) public CIFToOwner;
    uint public farmaciesCount;

    mapping (address => string) public MetgeToDNI;
    mapping (string => address) public DNIToMetge;
    uint public metgesCount;


    mapping (address => string) public PacientToDNI;
    mapping (string => address) public DNIToPacient;
    uint public pacientsCount;

    // Funcions per obtenir els identificadors de les farmàcies, metges i pacients a partir de les seves adreces
    function getCIFFarmacia(address _address) public view returns (string memory){
        return OwnerToCIF[_address];
    }

    function getDNIMetge(address _address) public view returns (string memory){
        return MetgeToDNI[_address];
    }

    function getDNIPacient(address _address) public view returns (string memory){
        return PacientToDNI[_address];
    }

    // Funcions per obtenir les adreces de les farmàcies, metges i pacients a partir del seu identificador
    function getFarmaciaFromCIF(string memory _cif) public view returns (address){
        return CIFToOwner[_cif];
    }

    function getMetgeFromDNI(string memory _dni) public view returns (address){
        return DNIToMetge[_dni];
    }

    function getPacientFromDNI(string memory _dni) public view returns (address){
        return DNIToPacient[_dni];
    }

    // Funció per afegir una nova farmàcia a l'hospital
    function afegeixFarmacia(address _adreca, string memory _cif, string memory _nom, string memory _ubicacio) public onlyOwner{
        require(bytes(_cif).length == 9, "Introdueix el CIF!!!");
        require(bytes(_nom).length != 0, "Introdueix el nom!!!");
        require(bytes(_ubicacio).length != 0, "Introdueix la ubicacio!!!");
        Farmacies.push(Farmacia(_adreca, _cif, _nom, _ubicacio));
        OwnerToCIF[_adreca] = _cif;
        CIFToOwner[_cif] = _adreca;
        farmaciesCount++;
        emit newPharmacy(_adreca, _cif, _nom, _ubicacio);
    } 

    // Funció per afegir un nou metge a l'hospital
    function afegeixMetge(address _adreca, string memory _dni, string memory _nom) public onlyOwner{
        require(bytes(_dni).length == 9, "Introdueix el DNI!!!");
        require(bytes(_nom).length != 0, "Introdueix el nom!!!");
        Metges.push(Metge(_adreca, _dni, _nom));
        DNIToMetge[_dni] = _adreca;
        MetgeToDNI[_adreca] = _dni;
        metgesCount++;
        emit newDoctor(_adreca, _dni, _nom);
    }

    // Funció per afegir un nou pacient a l'hospital
    function afegeixPacient(address _adreca, string memory _dni, string memory _nom) external{
        Pacients.push(Pacient(_adreca, _dni, _nom));
        DNIToPacient[_dni] = _adreca;
        PacientToDNI[_adreca] = _dni;
        pacientsCount++;
    } 
}
    

