import com.haxepunk.Entity;
import com.haxepunk.graphics.Text;

using BloodType;

typedef Bank = BloodTypeCounter<Int>;

class Clinic extends Entity
{
  public static inline var X:Float = 450;
  public static inline var Y:Float = 200;
  public static inline var DOOR_X:Float = 470.0;
  public static inline var DOOR_Y:Float = 230.0;
  private static inline var DEFAULT_INITIAL_STOCK:Int = 2;

  private var main:MainScene;
  private var bank:Bank;
  private var ab_pos_label:Entity;
  private var ab_neg_label:Entity;
  private var a_pos_label:Entity;
  private var a_neg_label:Entity;
  private var b_pos_label:Entity;
  private var b_neg_label:Entity;
  private var o_pos_label:Entity;
  private var o_neg_label:Entity;
  private var ab_pos_label_text:Text;
  private var ab_neg_label_text:Text;
  private var  a_pos_label_text:Text;
  private var  a_neg_label_text:Text;
  private var  b_pos_label_text:Text;
  private var  b_neg_label_text:Text;
  private var  o_pos_label_text:Text;
  private var  o_neg_label_text:Text;

  private static inline var GFX_PATH:String = "graphics/clinic.png";

  public function new(main:MainScene){
    this.main = main;

    this.bank = {
      AB_POS : DEFAULT_INITIAL_STOCK,
      AB_NEG : DEFAULT_INITIAL_STOCK,
      A_POS : DEFAULT_INITIAL_STOCK,
      A_NEG : DEFAULT_INITIAL_STOCK,
      B_POS : DEFAULT_INITIAL_STOCK,
      B_NEG : DEFAULT_INITIAL_STOCK,
      O_POS : DEFAULT_INITIAL_STOCK,
      O_NEG : DEFAULT_INITIAL_STOCK,
    };

    super( X, Y, new com.haxepunk.graphics.Image(GFX_PATH) );

    // display stock
    var label_text_options = {
      size : 16
    }
    ab_pos_label_text = new Text('${BloodType.AB_POS.toLabel()} ${bank.AB_POS}', 0, 0, null, null, label_text_options );
    ab_neg_label_text = new Text('${BloodType.AB_NEG.toLabel()} ${bank.AB_NEG}', 0, 0, null, null, label_text_options );
     a_pos_label_text = new Text( '${BloodType.A_POS.toLabel()} ${bank.A_POS}', 0, 0, null, null, label_text_options );
     a_neg_label_text = new Text( '${BloodType.A_NEG.toLabel()} ${bank.A_NEG}', 0, 0, null, null, label_text_options );
     b_pos_label_text = new Text( '${BloodType.B_POS.toLabel()} ${bank.B_POS}', 0, 0, null, null, label_text_options );
     b_neg_label_text = new Text( '${BloodType.B_NEG.toLabel()} ${bank.B_NEG}', 0, 0, null, null, label_text_options );
     o_pos_label_text = new Text( '${BloodType.O_POS.toLabel()} ${bank.O_POS}', 0, 0, null, null, label_text_options );
     o_neg_label_text = new Text( '${BloodType.O_NEG.toLabel()} ${bank.O_NEG}', 0, 0, null, null, label_text_options );
    ab_pos_label  = new Entity( 520, 330, ab_pos_label_text );
    ab_neg_label  = new Entity( 520, 345, ab_neg_label_text );
     a_pos_label  = new Entity( 520, 360, a_pos_label_text );
     a_neg_label  = new Entity( 520, 375, a_neg_label_text );
     b_pos_label  = new Entity( 520, 390, b_pos_label_text );
     b_neg_label  = new Entity( 520, 405, b_neg_label_text );
     o_pos_label  = new Entity( 520, 420, o_pos_label_text );
     o_neg_label  = new Entity( 520, 435, o_neg_label_text );
    main.add( ab_pos_label );
    main.add( ab_neg_label );
    main.add(  a_pos_label );
    main.add(  a_neg_label );
    main.add(  b_pos_label );
    main.add(  b_neg_label );
    main.add(  o_pos_label );
    main.add(  o_neg_label );
  }

  private function set_bank_inventory_count(blood_type:BloodType, count:Int):Void
  {
    Reflect.setField(bank, Std.string(blood_type), count);

    // update label text
    var text_graphic:Text = switch (blood_type) {
      case BloodType.AB_POS: ab_pos_label_text;
      case BloodType.AB_NEG: ab_neg_label_text;
      case BloodType.A_POS:   a_pos_label_text;
      case BloodType.A_NEG:   a_neg_label_text;
      case BloodType.B_POS:   b_pos_label_text;
      case BloodType.B_NEG:   b_neg_label_text;
      case BloodType.O_POS:   o_pos_label_text;
      case BloodType.O_NEG:   o_neg_label_text;
      case BloodType.NULL:    null;
    };
    text_graphic.text = '${blood_type.toLabel()} ' + Reflect.field(bank,Std.string(blood_type));
  }

  private inline function get_blood_count(blood_type:BloodType):Int
  {
    return (Reflect.field(bank, Std.string(blood_type)) : Int);
  }

  private inline function increase_blood_inventory(blood_type:BloodType):Void
  {
    set_bank_inventory_count( blood_type, get_blood_count(blood_type)+1 );
  }

  private inline function decrease_blood_inventory(blood_type:BloodType):Bool
  {
    if(get_blood_count(blood_type) > 0){
      set_bank_inventory_count( blood_type, get_blood_count(blood_type)-1 );
      return true;
    }else return false;
  }



  // include rules from Be-Positive.js
  public inline function patient_transfusion(patient:Patient):Void
  {
    // handle rules
    var blood_to_inject_str:String = BloodTransfusionRules.receive_patient( Reflect.copy(bank), patient.as_jso() );
    // give blood
    // update bank count
    if(blood_to_inject_str != "false"){

      var blood_to_inject:BloodType = Reflect.field(BloodType, blood_to_inject_str);

      // check if there is stock of that blood
      if( get_blood_count(blood_to_inject) > 0 ){

        if( decrease_blood_inventory( blood_to_inject ) ){

          patient.receive_blood( blood_to_inject );

        }else{
          // this should never happen
          // don't give any blood
          trace('[[[ERROR]]] blood was about to go below 0.');
        }

      }else{
        // don't give any blood
        trace('[[[WARNING]]] your rules allowed clinic to give ${blood_to_inject_str} without the clinic having sufficient stock. The patient was not given any blood.');
      }

    }else{
      // don't give any new blood
      trace('[[[WARNING]]] denied giving a patient a blood transfusion. The patient will get sick if ${ patient.gender == Person.Gender.MALE ? 'he' : 'she' } is not treated. (do not deny too many times).');
    }
  }

  public inline function donor_transfusion(donor:Donor):Void
  {
    // increase bank count
    increase_blood_inventory(donor.blood_type);
  }

}
