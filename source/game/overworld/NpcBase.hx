package game.overworld;

import flixel.FlxSprite;
import flixel.FlxG;
import states.PlayState;

class NpcBase extends FlxSprite
{
    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);
    }    

    override function update(elapsed:Float)
    {
        super.update(elapsed);
    }
}