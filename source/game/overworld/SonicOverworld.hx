package game.overworld;

class SonicOverworld extends OverworldBase
{
    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);
        isLeader = true;
        characterAtlas = 'Sonic_Battle';
        loadCharacterAnimations();
    }
}
