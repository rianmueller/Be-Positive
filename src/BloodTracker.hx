using BloodType;
using Lambda;

typedef BloodBag = Array<BloodType>;

/* implements Mixed Bag randomness */
class BloodTracker
{
  // of 100
  private static var PATIENT_BAG_COUNTS:BloodTypeCounter<Int> = {
    AB_POS: 30,
    AB_NEG: 30,
    A_POS:  10,
    A_NEG:  10,
    B_POS:  10,
    B_NEG:  10,
    O_POS:  5,
    O_NEG:  5,
  };
  // of 100
  private static var DONOR_BAG_COUNTS:BloodTypeCounter<Int> = {
    AB_POS: 5,
    AB_NEG: 5,
    A_POS:  10,
    A_NEG:  10,
    B_POS:  10,
    B_NEG:  10,
    O_POS:  30,
    O_NEG:  30,
  };
  private var donor_bag:BloodBag;
  private var patient_bag:BloodBag;

  public var next_patient(get, null):BloodType;
  private function get_next_patient():BloodType{
    // get patient from blood bag
    if(this.patient_bag.length == 0) refill_bag( this.patient_bag, PATIENT_BAG_COUNTS );
    return this.patient_bag.splice( Std.random(this.patient_bag.length), 1 )[0];
  }

  public var next_donor(get, null):BloodType;
  private function get_next_donor():BloodType{
    // get donor from blood bag
    if(this.donor_bag.length == 0) refill_bag( this.donor_bag, DONOR_BAG_COUNTS );
    return this.donor_bag.splice( Std.random(this.donor_bag.length), 1 )[0];
  }

  private static inline function refill_bag(bag:BloodBag, bag_counts:BloodTypeCounter<Int>):Void
  {
    Type.allEnums(BloodType).foreach(
      function(blood_type:BloodType):Bool{
        for( i in 0...Reflect.field(bag_counts, Std.string(blood_type)) ){
          bag.push( blood_type );
        }
        return true;
      }
    );
  }

  public function new(){
    this.patient_bag = new Array<BloodType>();
    this.donor_bag = new Array<BloodType>();
    refill_bag(this.patient_bag, PATIENT_BAG_COUNTS);
    refill_bag(this.donor_bag, DONOR_BAG_COUNTS);
  }

}

