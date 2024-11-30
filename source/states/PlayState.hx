package states;

import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import game.overworld.SonicOverworld;
import flixel.FlxSprite;
import backend.DialogueManager;
import flixel.FlxG;
import flixel.input.mouse.FlxMouse;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
using StringTools;

class PlayState extends FlxState
{
    var sonic:SonicOverworld;
    private var dialogueManager:DialogueManager;
    private var mouse:FlxMouse;
	public var talking:Bool = false;
    public static var instance:PlayState;
    var dialoguebox:FlxSprite;
    var sonicSpr:FlxSprite;
    var tailsSpr:FlxSprite;
    private var talkIndicator:FlxSprite;
    private var boxDefaultY:Float;

    override public function create()
    {
        instance = this;
		mouse = FlxG.mouse;

		dialogueManager = new DialogueManager("assets/data/dialogue/testdialogue");
		dialogueManager.setTextSpeed(2.0);

        sonic = new SonicOverworld(0, 0);
        add(sonic);

		/*
        #if desktop
        Modding.reload();
        #end
		*/

		sonicSpr = new FlxSprite(100, 435).loadGraphic(Paths.image('dialogue/chars/sonic/neutral'));
		sonicSpr.scale.set(2, 2);
		//sonicSpr.screenCenter(Y);
        sonicSpr.visible = false;
		add(sonicSpr);

        tailsSpr = new FlxSprite(300, 457).loadGraphic(Paths.image('dialogue/chars/tails/neutral'));
		tailsSpr.scale.set(2, 2);
		//sonicSpr.screenCenter(Y);
        tailsSpr.visible = false;
		add(tailsSpr);

        dialogueManager.addCharacter("sonic", sonicSpr);
        dialogueManager.addCharacter("tails", tailsSpr);

        dialoguebox = new FlxSprite(125).loadGraphic(Paths.image('dialogue/dialogueBox'));
        dialoguebox.scrollFactor.set(0, 0.18);
        dialoguebox.scale.set(3.1,3.1);
        dialoguebox.updateHitbox();
        dialoguebox.y = FlxG.height - dialoguebox.height - 40;
        boxDefaultY = dialoguebox.y;
        dialoguebox.antialiasing = false;
        dialoguebox.visible = false;
        add(dialoguebox);

        talkIndicator = new FlxSprite().loadGraphic(Paths.image('dialogue/talkIndicator'));
        talkIndicator.scale.set(2, 2);
        talkIndicator.visible = false;
        talkIndicator.flipX = true;
        talkIndicator.x = 110;
        talkIndicator.y = FlxG.height - dialoguebox.height - 100;
        add(talkIndicator);

		if (talking)
            showDialogue();

        super.create();
    }

    private function showDialogue():Void {
        add(dialogueManager.getDialogueFlxText());
        add(dialogueManager.getNameFlxText());
        dialogueManager.start();
        
        dialoguebox.visible = true;
        dialoguebox.y = FlxG.height + 50;
        FlxTween.tween(dialoguebox, {y: boxDefaultY}, 0.5, {ease: FlxEase.quartOut});
        
        sonicSpr.visible = true;
        sonicSpr.x = -100;
        FlxTween.tween(sonicSpr, {x: 100}, 0.6, {ease: FlxEase.quartOut});
        
        tailsSpr.visible = true;
        tailsSpr.x = FlxG.width + 100;
        FlxTween.tween(tailsSpr, {x: FlxG.width - tailsSpr.width - 500}, 0.6, {ease: FlxEase.quartOut});
        
        talkIndicator.visible = true;
        updateIndicatorPosition(dialogueManager.getCurrentSpeakerPosition());
    }

    private function hideDialogue():Void {
        remove(dialogueManager.getDialogueFlxText());
        remove(dialogueManager.getNameFlxText());
        talkIndicator.visible = false;
        
        FlxTween.tween(sonicSpr, {x: -100}, 0.5, {
            ease: FlxEase.quartIn,
            onComplete: function(_) {
                sonicSpr.visible = false;
            }
        });

        FlxTween.tween(tailsSpr, {x: FlxG.width + 100}, 0.5, {
            ease: FlxEase.quartIn,
            onComplete: function(_) {
                tailsSpr.visible = false;
            }
        });

        FlxTween.tween(dialoguebox, {y: FlxG.height + 50}, 0.5, {
            ease: FlxEase.quartIn,
            onComplete: function(_) {
                dialoguebox.visible = false;
            }
        });
    }

    private function updateIndicatorPosition(isRight:Bool):Void
    {
        var targetX = isRight ? FlxG.width - talkIndicator.width - 555 : 195;
        var targetY = dialoguebox.y + -25;
        if (isRight == true)
        {
            dialoguebox.flipX = false;
            talkIndicator.flipX = false;
        }    
        else
        {    
            dialoguebox.flipX = false;
            talkIndicator.flipX = true;
        }    
        FlxTween.tween(talkIndicator, {x: targetX, y: targetY}, 0.3, {ease: FlxEase.quartOut});
    }

    override public function update(elapsed:Float)
    {
        if (FlxG.keys.justPressed.SEVEN)
            if (Modding.trackedMods != [])
                FlxG.switchState(new ModsMenuState());
            else {
                Main.toast.create('No Mods Installed!', 0xFFFFFF00, 'Please add mods to be able to access the menu!');
            }

		if (talking && FlxG.keys.justPressed.Z)
        {
            if (dialogueManager.isDialogueComplete())
            {
                talking = false;
                hideDialogue();
            }
            else
                dialogueManager.skipText();
        }

		if (FlxG.keys.justPressed.C)
        {
            talking = !talking;
            if (talking)
                showDialogue();
            else
                hideDialogue();
        }
		
		if (talking) {
            updateIndicatorPosition(dialogueManager.getCurrentSpeakerPosition());
        }

		dialogueManager.update(elapsed);

        super.update(elapsed);
    }
}
