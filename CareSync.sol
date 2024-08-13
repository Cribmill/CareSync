// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.26;

contract CareSync {
    address public admin;

    struct Patient {
        string name;
        uint age;
        string condition;
        string status;
        address caregiver;
    }

    mapping(uint => Patient) public patients;
    uint public patientCount;

    event PatientAdded(uint patientId, string name, address caregiver);
    event StatusUpdated(uint patientId, string status);

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action.");
        _;
    }

    modifier onlyCaregiver(uint patientId) {
        require(msg.sender == patients[patientId].caregiver, "Only assigned caregiver can perform this action.");
        _;
    }

    function addPatient(
        string memory name,
        uint age,
        string memory condition,
        string memory status,
        address caregiver
    ) public onlyAdmin {
        patientCount++;
        patients[patientCount] = Patient(name, age, condition, status, caregiver);
        emit PatientAdded(patientCount, name, caregiver);
    }

    function updateStatus(uint patientId, string memory status) public onlyCaregiver(patientId) {
        patients[patientId].status = status;
        emit StatusUpdated(patientId, status);
    }

    function getPatient(uint patientId) public view returns (string memory name, uint age, string memory condition, string memory status, address caregiver) {
        Patient memory patient = patients[patientId];
        return (patient.name, patient.age, patient.condition, patient.status, patient.caregiver);
    }
}
