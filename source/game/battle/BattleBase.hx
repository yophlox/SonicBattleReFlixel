package game.battle;

import flixel.FlxSprite;
import flixel.FlxG;
import states.PlayState;
import openfl.geom.Rectangle;
import openfl.display.BitmapData;
import zero.flixel.depth.BillboardSprite;
import flixel.util.FlxTimer;

class BattleBase extends BillboardSprite
{
    public var speed:Float = 3;
    public var characterAtlas:String;
    public var isPlayer:Bool;
    private var turning:Bool = false;
    private var isJumping:Bool = false;
    private var canDoubleJump:Bool = false;
    private var gravity:Float = 400;
    var char:String;

    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);
        acceleration.y = gravity;
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
            animation.addByPrefix('double', 'double', 12, true);

            animation.play('idle');
            scale.set(0.65, 0.65);
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

        if (isJumping && velocity.y == 0)
        {
            isJumping = false;
            canDoubleJump = false;
        }
        else if (isJumping && char == "Sonic" && !canDoubleJump)
        {
            canDoubleJump = true;
        }

        super.update(elapsed);
    }

    private function turn(direction:String)
    {
        turning = true;
        animation.play('turn');
        var timer:FlxTimer = new FlxTimer();
        timer.start(0.2, function(timer:FlxTimer) {
            turning = false;
            if (direction == "left") {
                x -= speed;
                flipX = true;
            } else if (direction == "right") {
                x += speed;
                flipX = false;
            }
            animation.play('run');
        });
    }

    private function jump()
    {
        if (!isJumping)
        {
            isJumping = true;
            velocity.y = -75;
            animation.play('jump');
        }
        else if (char == "Sonic" && canDoubleJump)
        {
            canDoubleJump = false;
            velocity.y = -15;
            velocity.x += flipX ? -100 : 100; 
            animation.play('double');
        }
    }

    private function movement()
    {
        if (PlayState.instance.talking || turning)
            return;

        var isMoving:Bool = false;

        if (FlxG.keys.pressed.LEFT)
        {
            if (!flipX) {
                turn("left");
            } else {
                x -= speed;
                isMoving = true;
            }
        }
        else if (FlxG.keys.pressed.RIGHT)
        {
            if (flipX) {
                turn("right");
            } else {
                x += speed;
                isMoving = true;
            }
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

        if (FlxG.keys.justPressed.Z)
        {
            jump();
        }

        if (!turning && !isJumping) {
            animation.play(isMoving ? 'run' : 'idle');
        }
    }
}