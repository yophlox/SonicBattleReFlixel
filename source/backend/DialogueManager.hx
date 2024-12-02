package backend;

import flixel.text.FlxText;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import hscript.Parser;
import hscript.Interp;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
using StringTools;

typedef DialogueLine = {
    character:String,
    text:String,
    expression:String,
    ?onRight:Bool
}

class DialogueManager
{
    private var dialogueFlxText:FlxText;
    private var dialogues:Array<DialogueLine>;
    private var currentLine:Int;
    private var characters:Map<String, FlxSprite>;
    private var textSpeed:Float = 0.05;
    private var currentText:String = "";
    private var targetText:String = "";
    private var textTimer:Float = 0;
    private var textSpeedMultiplier:Float = 1.0;
    private static var playerName:String = "MC";
    private var dialogueFile:String;
    private var parser:Parser;
    private var interp:Interp;
    private var lastExpression:String = "";
    private var characterPositions:Map<String, Bool> = new Map<String, Bool>();

    public function new(dialogueFile:String)
    {
        this.dialogueFile = dialogueFile;
        dialogues = [];
        currentLine = 0;

        dialogueFlxText = new FlxText(150, FlxG.height - 150, FlxG.width - 450, "");
        dialogueFlxText.setFormat("assets/fonts/Sonic Battle In-game Font.ttf", 18, FlxColor.BLACK, LEFT, null);

        characters = new Map<String, FlxSprite>();
        parser = new Parser();
        interp = new Interp();
        setupInterpreter();
    }

    private function setupInterpreter():Void
    {
        interp.variables.set("showDialogue", showDialogue);
        interp.variables.set("setCharacterExpression", setCharacterExpression);
        interp.variables.set("setCharacterPosition", setCharacterPosition);
        interp.variables.set("playerName", playerName);
    }

    private function parseDialogueFile(dialogueFile:String):Array<DialogueLine>
    {
        try {
            var script = openfl.Assets.getText(dialogueFile);
            if (script == null || script == "") {
                return [];
            }
            var program = parser.parseString(script);
            interp.execute(program);
            return dialogues;
        } catch (e:Dynamic) {
            return [];
        }
    }

    public function start():Void
    {
        dialogues = [];
        currentLine = 0;
        dialogues = parseDialogueFile(dialogueFile + ".hx");
        if (dialogues.length > 0) {
            updateDialogue();
        }
    }

    private function showDialogue(character:String, text:String):Void
    {
        targetText = text;
        currentText = "";
        textTimer = 0;
        
        var position = characterPositions.exists(character) ? characterPositions.get(character) : false;
        
        dialogues.push({
            character: character,
            text: text,
            expression: lastExpression,
            onRight: position
        });
    }

    private function setCharacterExpression(character:String, expression:String, ?onRight:Bool = false):Void
    {
        lastExpression = expression;
        showCharacter(character, expression);
    }

    private function updateDialogue():Void
    {
        if (currentLine < dialogues.length)
        {
            var line = dialogues[currentLine];
            targetText = line.text;
            currentText = "";
            textTimer = 0;
            showCharacter(line.character, line.expression, characterPositions.get(line.character.toLowerCase()));
            currentLine++;
        }
    }

    public static function setPlayerName(name:String):Void
    {
        playerName = name;
    }

    public function update(elapsed:Float):Void
    {
        if (targetText == null) return;
        
        if (currentText.length < targetText.length)
        {
            textTimer += elapsed * textSpeedMultiplier;
            while (textTimer >= textSpeed)
            {
                currentText += targetText.charAt(currentText.length);
                textTimer -= textSpeed;
            }
            dialogueFlxText.text = currentText;
        }
    }

    public function skipText():Void
    {
        if (targetText == null) return;
        
        if (currentText.length < targetText.length)
        {
            currentText = targetText;
            dialogueFlxText.text = currentText;
        }
        else if (!isDialogueComplete())
        {
            updateDialogue();
        }
    }

    private function showCharacter(character:String, expression:String, ?onRight:Bool = null):Void
    {
        var charAbbr = character.toLowerCase();

        if (characters.exists(charAbbr))
        {
            var sprite = characters[charAbbr];
            sprite.visible = true;
            
            var storedPosition = characterPositions.get(charAbbr);
            if (storedPosition != null) {
                sprite.x = storedPosition ? FlxG.width - sprite.width - 500 : 100;
                sprite.flipX = storedPosition;
            }
            
            var expressionPath = 'assets/images/dialogue/chars/${charAbbr}/${expression}.png';
            var neutralPath = 'assets/images/dialogue/chars/${charAbbr}/neutral.png';
            var newPath = openfl.Assets.exists(expressionPath) ? expressionPath : neutralPath;
            
            var originalScale = sprite.scale.x;
            FlxTween.tween(sprite.scale, {x: 0}, 0.3, {
                ease: FlxEase.quartIn,
                onComplete: function(_) {
                    sprite.loadGraphic(newPath);
                    FlxTween.tween(sprite.scale, {x: originalScale}, 0.3, {
                        ease: FlxEase.quartOut
                    });
                }
            });
        }
    }

    private function setCharacterPosition(character:String, position:String):Void
    {
        var onRight = position.toLowerCase() == "right";
        characterPositions.set(character, onRight);
        
        if (characters.exists(character))
        {
            var sprite = characters[character];
            sprite.flipX = onRight;
            sprite.x = onRight ? FlxG.width - sprite.width - 300 : 100;
        }
    }

    public function addCharacter(name:String, sprite:FlxSprite):Void
    {
        characters.set(name, sprite);
        sprite.visible = false;
    }

    public function isDialogueComplete():Bool
    {
        return currentLine >= dialogues.length;
    }

    public function getDialogueFlxText():FlxText
    {
        return dialogueFlxText;
    }

    public function setTextSpeed(speed:Float):Void
    {
        textSpeedMultiplier = speed;
    }

    public function destroy()
    {
        dialogueFlxText.destroy();
    }
    
    public function getCurrentSpeakerPosition():Bool {
        if (currentLine <= 0 || dialogues.length == 0) return false;
        
        var currentDialogue = dialogues[currentLine - 1];
        return characterPositions.get(currentDialogue.character.toLowerCase());
    }
}