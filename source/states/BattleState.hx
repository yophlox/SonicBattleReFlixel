package states;

import depth.objects.*;
import flixel.FlxState;
import flixel.FlxG;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;
import zero.flixel.depth.DepthGroup;
import zero.flixel.depth.DepthCamera;
import game.battle.SonicBattle;

class BattleState extends FlxState {

	var depth_camera:DepthCamera;
	var depth_group:DepthGroup;
	var last_mouse_x:Float;
	var last_mouse_y:Float;

	override function create() {
		FlxG.mouse.useSystemCursor = true;
		bgColor = 0xff32343C;
		depth_group = new DepthGroup();

		add(depth_camera = new DepthCamera(0, 0, 3));
		add(new DotGrid());
		add(new MouseFollower(depth_camera));
		add(depth_group);

		depth_group.add(new SonicBattle(FlxG.width/2 - 32, FlxG.height/2 - 32));
		depth_group.add(new Plane(FlxG.width/2 + 32, FlxG.height/2 + 32));
		depth_group.add(new StackSphere(FlxG.width/2 + 32, FlxG.height/2 - 32));
		depth_group.add(new StackCube(FlxG.width/2, FlxG.height/2));
		new PlaneCube(FlxG.width/2 - 32, FlxG.height/2 + 32, depth_group);
	}

	override function update(dt:Float) {
		super.update(dt);
		depth_group.depth_sort();

		if (FlxG.mouse.justPressed) {
			last_mouse_x = FlxG.mouse.screenX;
			last_mouse_y = FlxG.mouse.screenY;
		}

		if (FlxG.mouse.pressed) {
			depth_camera.set_delta((last_mouse_x - FlxG.mouse.screenX) / 8, (FlxG.mouse.screenY - last_mouse_y) / 16);
		} else {
			depth_camera.set_delta(0, 0);
		}

		last_mouse_x = FlxG.mouse.screenX;
		last_mouse_y = FlxG.mouse.screenY;

		if (FlxG.keys.justPressed.SEVEN)
			FlxG.switchState(new states.PlayState());
	}

}