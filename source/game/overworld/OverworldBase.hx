package game.overworld;

import flixel.FlxSprite;
import flixel.FlxG;
import states.PlayState;
import openfl.geom.Rectangle;
import openfl.display.BitmapData;

class OverworldBase extends FlxSprite
{
    public var speed:Float = 10;
    public var characterAtlas:String;
    var isLeader:Bool = false;

    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);
    }

    public function loadCharacterAnimations()
    {
        if (characterAtlas != null)
        {
            frames = Paths.getSparrowAtlas('overworld/chars/' + characterAtlas);
            animation.addByPrefix('idle', 'idle', 12, true);
            animation.addByPrefix('run', 'run', 12, true);
            animation.addByPrefix('jump', 'jump', 12, true);
            
            animation.play('idle');
            scale.set(2, 2);
            updateHitbox();
        }
    }

    override function update(elapsed:Float)
    {
        if (!isLeader)
        {
            // party member func here lol
        }
        else if (isLeader)
        {
            movement();
        }
        super.update(elapsed);
    }

    private function movement()
    {
        if (PlayState.instance.talking)
            return;
            
        var isMoving:Bool = false;

        if (FlxG.keys.pressed.LEFT)
        {
            x -= speed;
            flipX = true;
            isMoving = true;
        }
        else if (FlxG.keys.pressed.RIGHT)
        {
            x += speed;
            flipX = false;
            isMoving = true;
        }

        if (FlxG.keys.pressed.UP)
        {
            y -= speed;
            isMoving = true;
        }
        else if (FlxG.keys.pressed.DOWN)
        {
            y += speed;
            isMoving = true;
        }

        animation.play(isMoving ? 'run' : 'idle');
    }
}