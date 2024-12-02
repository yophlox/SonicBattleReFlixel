package game.battle;

import flixel.FlxSprite;
import flixel.FlxG;
import states.PlayState;
import openfl.geom.Rectangle;
import openfl.display.BitmapData;
import zero.flixel.depth.BillboardSprite;

class BattleBase extends BillboardSprite
{
    public var speed:Float = 10;
    public var characterAtlas:String;
    public var isPlayer:Bool;

    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);
    }

    public function loadCharacterAnimations()
    {
        if (characterAtlas != null)
        {
            frames = Paths.getSparrowAtlas('battle/chars/' + characterAtlas);
            animation.addByPrefix('idle', 'idle', 12, true);
            animation.addByPrefix('run', 'run', 12, true);
            animation.addByPrefix('jump', 'jump', 12, true);
            animation.addByPrefix('turn', 'turn', 12, true);
            animation.addByPrefix('turnrun', 'turnrun', 12, true);
            animation.addByPrefix('stop', 'stop', 12, true);
            animation.addByPrefix('fall', 'fall', 12, true);
            animation.addByPrefix('guard', 'guard', 12, true);
            animation.addByPrefix('heal', 'heal', 12, true);
            animation.addByPrefix('firstATK', 'firstATK', 12, true);
            animation.addByPrefix('secondATK', 'secondATK', 12, true);
            animation.addByPrefix('thirdATK', 'thirdATK', 12, true);
            animation.addByPrefix('ATKFinale', 'ATKFinale', 12, true);

            animation.play('idle');
            scale.set(2, 2);
            updateHitbox();
        }
    }

    override function update(elapsed:Float)
    {
        if (isPlayer)
        {
            movement();
        }
        else
        {
            // npc stuff here lol
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