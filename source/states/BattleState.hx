package states;

import flixel.FlxState;
import flixel.FlxG;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;
import game.battle.SonicBattle;

class BattleState extends FlxState {
	var player:SonicBattle;
	var opp:SonicBattle;

	override function create() 
	{

		player = new SonicBattle(0,0);
		player.isPlayer = true;
		add(player);
		
		opp = new SonicBattle(0,0);
		opp.isPlayer = false;
		add(opp);
		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}

}