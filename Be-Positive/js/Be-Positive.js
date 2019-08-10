BloodType = {
  AB_POS: "AB_POS",
  AB_NEG: "AB_NEG",
  A_POS: "A_POS",
  A_NEG: "A_NEG",
  B_POS: "B_POS",
  B_NEG: "B_NEG",
  O_POS: "O_POS",
  O_NEG: "O_NEG"
};

BloodTransfusionRules = {
  /**
   * Set the simulation speed.
   * @type {Number} : Valid values between 1 and 200
   */
  simulation_speed: 90,

  /**
   * returns BloodType, or false to give no BloodType
   *
   * @name receive_patient
   * @param {Bank} blood_inventory
   * @param {Patient} patient
   * @returns {BloodType or false}
   *
   * Patient properties {
   *   gender : String, (MALE,FEMALE)
   *   blood_type : String (BloodType)
   * }
   *
   * Bank properties {
   *   AB_POS : Integer,
   *   AB_NEG : Integer,
   *   A_POS  : Integer,
   *   A_NEG  : Integer,
   *   B_POS  : Integer,
   *   B_NEG  : Integer,
   *   O_POS  : Integer,
   *   O_NEG  : Integer
   * }
   *
   */

  // receive_patient : function (blood_inventory, patient) {

  //   // give a random blood type to anyone
  //   // very bad idea!
  //   return [
  //     BloodType.AB_POS,
  //     BloodType.AB_NEG,
  //     BloodType.A_POS,
  //     BloodType.A_NEG
  //   ][Math.floor(Math.random()*4)];

  // }

  receive_patient: function(blood_inventory, patient) {
    // if patient blood type is AB+
    if (patient.blood_type === "AB_POS") {
      if (blood_inventory.AB_POS > 0) {
        return BloodType.AB_POS;
      } else if (
        blood_inventory.B_POS > 0 &&
        blood_inventory.B_POS > blood_inventory.A_POS
      ) {
        return BloodType.B_POS;
      } else if (blood_inventory.A_POS > 0) {
        return BloodType.A_POS;
      } else if (blood_inventory.O_POS > 0) {
        return BloodType.O_POS;
      } else if (blood_inventory.AB_NEG > 0) {
        return BloodType.AB_NEG;
      } else if (
        blood_inventory.B_NEG > 0 &&
        blood_inventory.B_NEG > blood_inventory.A_NEG
      ) {
        return BloodType.B_NEG;
      } else if (blood_inventory.A_NEG > 0) {
        return BloodType.A_NEG;
      } else if (blood_inventory.O_NEG > 0) {
        return BloodType.O_NEG;
      } else return false;
      // if patient blood type is AB-
    } else if (patient.blood_type === "AB_NEG") {
      if (blood_inventory.AB_NEG > 0) {
        return BloodType.AB_NEG;
      } else if (
        blood_inventory.B_NEG > 0 &&
        blood_inventory.B_NEG > blood_inventory.A_NEG
      ) {
        return BloodType.B_NEG;
      } else if (blood_inventory.A_NEG > 0) {
        return BloodType.A_NEG;
      } else if (blood_inventory.O_NEG > 0) {
        return BloodType.O_NEG;
      } else return false;
      // if patient blood type is B+
    } else if (patient.blood_type === "B_POS") {
      if (blood_inventory.B_POS > 0) {
        return BloodType.B_POS;
      } else if (blood_inventory.O_POS > 0) {
        return BloodType.O_POS;
      } else if (blood_inventory.B_NEG > 0) {
        return BloodType.B_NEG;
      } else if (blood_inventory.O_NEG > 0) {
        return BloodType.O_NEG;
      } else return false;
      // if patient blood type is B-
    } else if (patient.blood_type === "B_NEG") {
      if (blood_inventory.B_NEG > 0) {
        return BloodType.B_NEG;
      } else if (blood_inventory.O_NEG > 0) {
        return BloodType.O_NEG;
      } else return false;
      // if patient blood type is A+
    } else if (patient.blood_type === "A_POS") {
      if (blood_inventory.A_POS > 0) {
        return BloodType.A_POS;
      } else if (blood_inventory.O_POS > 0) {
        return BloodType.O_POS;
      } else if (blood_inventory.A_NEG > 0) {
        return BloodType.A_NEG;
      } else if (blood_inventory.O_NEG > 0) {
        return BloodType.O_NEG;
      } else return false;
      // if patient blood type is A-
    } else if (patient.blood_type === "A_NEG") {
      if (blood_inventory.A_NEG > 0) {
        return BloodType.A_NEG;
      } else if (blood_inventory.O_NEG > 0) {
        return BloodType.O_NEG;
      } else return false;
      // if patient blood type is O+
    } else if (patient.blood_type === "O_POS") {
      if (blood_inventory.O_POS > 0) {
        return BloodType.O_POS;
      } else if (blood_inventory.O_NEG > 0) {
        return BloodType.O_NEG;
      } else return false;
      // if patient blood type is 0-
    } else if (patient.blood_type === "O_NEG") {
      if (blood_inventory.O_NEG > 0) {
        return BloodType.O_NEG;
      } else return false;
    }
  }

  /*
  ruleset
  O- can receive, in order:
      O-
  O+ can receive, in order:
      O+
      O-
  A- can receive, in order:
      A-
      O-
  A+ can receive, in order:
      A+
      O+
      A-
      O-
  B- can receive, in order:
      B-
      O-
  B+ can receive, in order:
      B+
      O+
      B-
      O-
  AB- can receive, in order:
      AB-
      B- (switch with A-, depending on inventory)
      A-
      O-
  AB+ can receive, in order:
      AB+
      B+ (switch with A+, depending on inventory)
      A+
      O+
      AB-
      B- (switch with A-, depending on inventory)
      A-
      O-
  For AB patients, AB should be first, 
  then second should be whichever there is more of from A and B, 
  then O fourth
  */
};
