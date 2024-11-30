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
    expression:String
}

class DialogueManager
{
    private var dialogueFlxText:FlxText;
    private var nameFlxText:FlxText;
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
    private var rightSideSpeakers:Array<String> = ["mc", "player"];

    public function new(dialogueFile:String)
    {
        this.dialogueFile = dialogueFile;
        dialogues = [];
        currentLine = 0;

        dialogueFlxText = new FlxText(150, FlxG.height - 150, FlxG.width - 450, "");
        dialogueFlxText.setFormat("assets/fonts/Sonic Battle In-game Font.ttf", 18, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);

        nameFlxText = new FlxText(230, FlxG.height - 190, 200, "");
        nameFlxText.setFormat("assets/fonts/Sonic Battle In-game Font.ttf", 28, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
        nameFlxText.visible = false;

        characters = new Map<String, FlxSprite>();
        parser = new Parser();
        interp = new Interp();
        setupInterpreter();
    }

    private function setupInterpreter():Void
    {
        interp.variables.set("showDialogue", showDialogue);
        interp.variables.set("setCharacterExpression", setCharacterExpression);
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
        dialogues = parseDialogueFile(dialogueFile + ".hx");
        currentLine = 0;
        if (dialogues.length > 0) {
            updateDialogue();
        } else {
            return;
        }
    }

    private function showDialogue(character:String, text:String):Void
    {
        nameFlxText.text = character;
        targetText = text;
        currentText = "";
        textTimer = 0;
        
        dialogues.push({
            character: character,
            text: text,
            expression: lastExpression
        });
    }

    private function setCharacterExpression(character:String, expression:String):Void
    {
        lastExpression = expression;
        showCharacter(character, expression);
    }

    private function updateDialogue():Void
    {
        if (currentLine < dialogues.length)
        {
            var line = dialogues[currentLine];
            nameFlxText.text = switch (line.character) {
                case "sonic": "Sonic";
                default: line.character;
            }
            targetText = line.text;
            currentText = "";
            textTimer = 0;
            showCharacter(line.character, line.expression);
            currentLine++;
        }
        else
        {
            nameFlxText.text = "";
            dialogueFlxText.text = "";
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
        else
        {
            updateDialogue();
        }
    }

    private function showCharacter(character:String, expression:String):Void
    {
        for (char in characters.keys())
        {
            characters[char].visible = false;
        }

        var charAbbr = switch (character.toLowerCase()) {
            case "sonic": "sonic";
            default: character.toLowerCase();
        }

        if (characters.exists(charAbbr))
        {
            var sprite = characters[charAbbr];
            sprite.visible = true;
            
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

    public function getNameFlxText():FlxText
    {
        return nameFlxText;
    }

    public function setTextSpeed(speed:Float):Void
    {
        textSpeedMultiplier = speed;
    }

    public function destroy()
    {
        dialogueFlxText.destroy();
        nameFlxText.destroy();
    }
    
    public function getCurrentSpeakerPosition():Bool {
        if (currentLine <= 0 || currentLine > dialogues.length) return false;
        var currentSpeaker = dialogues[currentLine - 1].character.toLowerCase();
        return rightSideSpeakers.contains(currentSpeaker);
    }
}