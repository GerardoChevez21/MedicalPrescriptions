# MedicalPrescriptions
This is an implementation of a decentralized system of medical prescriptions using the token standard ERC721.

The main purpose of each contract will be detailed below: 

-TokenRecepte

Contains the functions to manage the prescriptions.

-hospital

Represents the hospital where the system is implemented. It contains the necessary functionalities to register pharmacies, doctors, patients and deploy their contracts.

-metges

Used by the doctors who belong to the hospital where the system is implemented. 
The main functionality is to allow doctors to issue prescriptions for hospital patients.

-pacients

Allows register patients in the hospital and to transfer patient's prescriptions to pharmacies.

-farmacies

Allow pharmacies to burn patient's prescriptions once they have obtained the associated drug.

Note: If you want to test the system for example by using Remix, 
you first need to deploy the TokenRecepte's contract, get its address, and deploy the contract hospital from it.


Once done, execute the deployContracts function of hospital, which returns in order, the addresses of the contracts metges, pacients and farmacies.
