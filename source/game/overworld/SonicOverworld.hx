package game.overworld;

import flixel.FlxSprite;
import flixel.FlxG;
import states.PlayState;

class SonicOverworld extends FlxSprite
{
    public var speed:Float = 10;

    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);
        
        frames = Paths.getSparrowAtlas('Sonic_Battle');
        animation.addByPrefix('idle', 'idle', 12, true);
        animation.addByPrefix('run', 'run', 12, true);
        animation.addByPrefix('jump', 'jump', 12, true);
        
        animation.play('idle');
        scale.set(2, 2);
        updateHitbox();
    }

    override function update(elapsed:Float)
    {
        movement();
        super.update(elapsed);
    }

    private function movement()
    {
        if (PlayState.instance.talking == true)
        {
            return;
        }
        else 
        {
            if (FlxG.keys.pressed.LEFT)
            {
                x -= speed;
                animation.play('run');
                flipX = true;
            }
            else if (FlxG.keys.pressed.RIGHT)
            {
                x += speed;
                animation.play('run');
                flipX = false;
            }
            else if (FlxG.keys.pressed.UP)
            {
                y -= speed;
                animation.play('run');
            }
            else if (FlxG.keys.pressed.DOWN)
            {
                y += speed;
                animation.play('run');
            }
            else
            {
                animation.play('idle');
            }
        }    
    }
}