import com.haxepunk.Scene;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;

class MainScene extends Scene
{
  /*
    has priority over donor spawn
    lower number is higher rate, based on simulation speed
    200 too high
    10 is too low
  */
  public static inline var SPAWN_PATIENT_RATE:Int = 100;

  /*
    lower number is higher rate, based on simulation speed
    200 too high
    10 is too low
  */
  public static inline var SPAWN_DONOR_RATE:Int = 100;

  public static inline var SCREEN_WIDTH:Float = 640.0;
  public static inline var SCREEN_HEIGHT:Float = 480.0;

  private var simulator:Simulator;
  private var patients:List<Patient>;
  public var donors:List<Donor>;
  public var blood_tracker:BloodTracker;

  public var clinic:Clinic;

  public function new()
  {
    blood_tracker = new BloodTracker();
    patients = new List<Patient>();
    donors = new List<Donor>();

    super();
  }

	public override function begin()
	{

    // start spawner
    simulator = new Simulator(this);

    clinic = new Clinic(this);
    add(clinic);

	}

  private inline function spawn(t:Class<Person>):Void
  {
    switch (t) {
      case Patient:
        var patient = new Patient(this);
        add( patient );
        patients.add( patient );
      case Donor:
        var donor = new Donor(this);
        add( donor );
        donors.add( donor );
    }
  }

  // called from simulator
  public function spawner(age:Int):Void
  {
    // randomly spawn patients and donors
    if( Std.random( SPAWN_PATIENT_RATE ) == 0 ){
      spawn(Patient);
    }else if( Std.random( SPAWN_DONOR_RATE ) == 0 ){
      spawn(Donor);
    }
  }

  public inline function despawn(person:Person):Void
  {
    switch (Type.getClass(person)) {
      case Patient:
        remove( cast(person,Patient) );
        patients.remove( cast(person,Patient) );
      case Donor:
        remove( cast(person,Donor) );
        donors.remove( cast(person,Donor) );
    }
  }

}
