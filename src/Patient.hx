import com.haxepunk.Entity;
import com.haxepunk.HXP;
import BloodType;
class Patient extends Person
{
  public static inline var SICK_BEFORE:String      = "SICK_BEFORE";
  public static inline var HEALTHY_AFTER:String    = "HEALTHY_AFTER";
  public static inline var SICK_AFTER:String       = "SICK_AFTER";
  public static inline var DEAD:String             = "DEAD";
  public static inline var GFX_SICK_BEFORE:Int     = 2;
  public static inline var GFX_HEALTHY_AFTER:Int   = 3;
  public static inline var GFX_SICK_AFTER:Int      = 4;
  public static inline var GFX_DEAD:Int            = 5;
  public static inline var TRANSFUSION_TIME:Int    = 6000; // ms
  private static inline var RANDOM_WAIT_TO_REVISIT_CLINIC_MS:Int = 10000;
  private static inline var RANDOM_WAIT_TO_RESOLVE_BLOOD:Int = 5000;
  private static inline var REALLY_SICK_MOVESPEED:Float = 0.7;
  private static inline var MAX_DENIED_TRANSFUSIONS:Int = 2;

  private var recently_got_blood:Bool; // if true, JUST left hospital
  private var blood_received:BloodType;
  private var denied_transfuions:Int;

  public function new(main:MainScene){
    // for every patient, there's a donor
    // donor blood is weighted

    super(main, main.blood_tracker.next_patient);

    sprite.add(SICK_BEFORE, toGenderGFX([GFX_SICK_BEFORE]) );
    sprite.add(HEALTHY_AFTER, toGenderGFX([GFX_HEALTHY_AFTER]) );
    sprite.add(SICK_AFTER, toGenderGFX([GFX_SICK_AFTER]) );
    sprite.add(DEAD, toGenderGFX([GFX_DEAD]) );
    sprite.play(SICK_BEFORE);

    addGraphic(sprite);

    this.blood_badge_text.setTextProperty("color", 0x68CDF1);


    // when born, go to the clinic
    destination = { x : Clinic.DOOR_X, y : Clinic.DOOR_Y };
  }

  // private override function sprite_loaded():Void
  // {
  // }

  private override function arrive():Void
  {
    // if clinic, go in clinic
    if( destination.x == Clinic.DOOR_X && destination.y == Clinic.DOOR_Y ){
      // ARRIVED TO CLINIC
      // don't show for a while
      this.visible = false;

      haxe.Timer.delay( transfusion_complete, TRANSFUSION_TIME );
    }

    // go outside, hang out, then resolve blood
    else if(recently_got_blood)
    {
      haxe.Timer.delay(resolve_blood_transfusion, Std.random(RANDOM_WAIT_TO_RESOLVE_BLOOD));

    }

    // landed somewhere after resolving blood
    else{

      if(this.sprite.currentAnim == HEALTHY_AFTER){
        // clean up
        this.main.despawn(this);
      }else{ // SICK_AFTER
        // drop dead
        this.sprite.play(DEAD);
      }


    }


    destination = null;
  }

  public function receive_blood(new_blood:BloodType):Void
  {
    blood_received = new_blood;

    // update the label
    this.blood_badge_text.text = Person.badge_text(this.blood_type) + " < " + Person.badge_text(this.blood_received);
    this.blood_badge_text.x = -26;
  }

  /*
    runs after "transfusion" delay, inside of clinic
    leave clinic slowly to random spot outside
      wait seconds
    transition to resolved state
  */
  private inline function transfusion_complete():Void
  {
    this.visible = true;
    this.sprite.play(SICK_AFTER);
    this.recently_got_blood = true;

    // notify clinic
    this.main.clinic.patient_transfusion(this);

    // go to random spot outside
    this.destination = {
      x : Math.random() * MainScene.SCREEN_WIDTH * .75,
      y : Math.random() * MainScene.SCREEN_HEIGHT * .75
    };
  }

  /*
    triggers immediately when arriving to random destination
    on the 'field' when leaving the clinic
    the patient may or may not have a new blood in them
   */
  private inline function resolve_blood_transfusion():Void
  {
    if(this.blood_received != null){

      // if the new blood violates the rule, kill the patient
      if( BloodTypeTools.blood_map[this.blood_type][this.blood_received] ){
        // ok, make happy, run off map, and remove entity
        sprite.play(HEALTHY_AFTER);
        this.destination = {
          x : -100.0,
          y : Math.random() * MainScene.SCREEN_HEIGHT * 1.35
        };
      }else{
        // bad blood, get sicker, move a bit really slowly, then die
        this.move_speed = REALLY_SICK_MOVESPEED;
        this.destination = {
          x : Math.random() * MainScene.SCREEN_WIDTH * .95,
          y : Math.random() * MainScene.SCREEN_HEIGHT * .86
        };
      }

    }else{ // did not get blood, go back in to clinic

      if( this.denied_transfuions++ >= MAX_DENIED_TRANSFUSIONS ){
        // patient needed blood, didn't get, kill him
        this.receive_blood(BloodType.NULL);
        this.move_speed = REALLY_SICK_MOVESPEED;
        this.destination = {
          x : Math.random() * MainScene.SCREEN_WIDTH * .95,
          y : Math.random() * MainScene.SCREEN_HEIGHT * .86
        };

      }else{
        // go back to clinic and ask again
        haxe.Timer.delay(function():Void
        {
          destination = { x : Clinic.DOOR_X, y : Clinic.DOOR_Y };
        }, Std.random(RANDOM_WAIT_TO_REVISIT_CLINIC_MS));
      }
    }

    recently_got_blood = false;

  }


}
