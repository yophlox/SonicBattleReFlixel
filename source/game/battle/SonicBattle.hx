package game.battle;

class SonicBattle extends BattleBase
{
    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);
        isPlayer = true;
        char = 'Sonic';
        speed = 3.5;
        characterAtlas = 'Sonic_Battle';
        loadCharacterAnimations();
    }
}
