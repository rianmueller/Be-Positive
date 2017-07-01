/*
  stepper that runs on it's own loop, separate from render loop

  1.0(min)      => 10,000 ms
  10.0          => 1,000 ms
  20.0(default) => 500 ms
  200.0(max)    => 50 ms
  1000.0        => 1

  10000 / new_speed = interval in ms

*/
import haxe.Timer;
class Simulator
{
  private static inline var MAX_SIMULATION_SPEED:Int = 10000;
  private static inline var DEFAULT_SIMULATION_SPEED:Float = 50.0;
  private static inline var SPAWN_RATE:Int = 20;
  private var simulation_speed:Float;

  private var main:MainScene;
  private var ticker:Timer;
  private var age:Int;

  public function new(main:MainScene)
  {
    this.main = main;
    this.age = 0;

    simulation_speed = try{
      BloodTransfusionRules.simulation_speed;
    }catch(e:Dynamic){
      DEFAULT_SIMULATION_SPEED;
    }

    change_simulation_speed(simulation_speed);

  }

  public function change_simulation_speed(new_speed:Float):Void
  {
    if(ticker != null){
      ticker.stop();
    }
    // cap at 100
    if(new_speed > 200){
      trace('Warning! capped speed $new_speed down to max: 200.0');
      new_speed = 200.0;
    }else if(new_speed < 1){
      trace('Warning! capped speed $new_speed up to min: 1.0');
      new_speed = 1.0;
    }
    simulation_speed = new_speed;

    ticker = new Timer( Std.int( MAX_SIMULATION_SPEED / simulation_speed ) );
    ticker.run = tick;
  }

  private inline function tick():Void
  {
    age++;
    if( Std.random(SPAWN_RATE) == 0 ){
      main.spawner(age);
    }
  }

}
