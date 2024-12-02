package states;

import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.input.mouse.FlxMouse;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
using StringTools;

class BattleState extends FlxState
{
    public static var instance:BattleState;

    override public function create()
    {
        instance = this;

        super.create();
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);
    }
}
