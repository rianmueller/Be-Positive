using Lambda;

enum SpawnType{
  PATIENT;
  DONOR;
}

typedef SpawnBag = Array<SpawnType>;

/* implements Mixed Bag randomness */
class SpawnTracker
{
  // of 10
  private static var SPAWN_COUNTS = {
    PATIENT: 5,
    DONOR: 5
  };

  private var spawn_bag:SpawnBag;

  public var next(get, null):Class<Person>;
  private function get_next():Class<Person>{
    // get next person type to spawn
    if(this.spawn_bag.length == 0) refill_bag( this.spawn_bag, SPAWN_COUNTS );
    return switch(this.spawn_bag.splice( Std.random(this.spawn_bag.length), 1 )[0]){
      case PATIENT: Patient;
      case DONOR: Donor;
      default: throw 'Cannot spawn unknown type.';
    };
  }

  private static inline function refill_bag(bag:SpawnBag, bag_counts:{ PATIENT:Int, DONOR:Int }):Void
  {
    Type.allEnums(SpawnType).foreach(
      function(spawn_type:SpawnType):Bool{
        for( i in 0...Reflect.field(bag_counts, Std.string(spawn_type)) ){
          bag.push( spawn_type );
        }
        return true;
      }
    );
  }

  public function new(){
    this.spawn_bag = new Array<SpawnType>();
    refill_bag(this.spawn_bag, SPAWN_COUNTS);
  }

}

