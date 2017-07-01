import com.haxepunk.Entity;
import com.haxepunk.HXP;
class Donor extends Person
{
  public static inline var IDLE:String          = "IDLE";
  public static inline var YAY:String           = "YAY";
  public static inline var GFX_IDLE:Int         = 0;
  public static inline var GFX_YAY:Int          = 1;
  public static inline var DONATION_TIME:Int    = 10000; // ms

  public function new(main:MainScene){
    // for every patient, there's a donor
    // donor blood is weighted
    super(main, main.blood_tracker.next_donor);

    sprite.add(IDLE, toGenderGFX([GFX_IDLE]) );
    sprite.add(YAY, toGenderGFX([GFX_YAY]) );
    sprite.play(IDLE);

    addGraphic(sprite);

    this.blood_badge_text.setTextProperty("color", 0xD26527);

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

      haxe.Timer.delay( donation_complete, DONATION_TIME );
    }

    // moved off screen, remove self
    else
    {

      this.main.despawn(this);

    }


    destination = null;
  }

  /*
    leave clinic to the right
  */
  private inline function donation_complete():Void
  {
    this.visible = true;
    this.sprite.play(YAY);

    // notify clinic
    this.main.clinic.donor_transfusion(this);

    destination = { x : MainScene.SCREEN_WIDTH, y : Math.random() * MainScene.SCREEN_HEIGHT };

  }
}
