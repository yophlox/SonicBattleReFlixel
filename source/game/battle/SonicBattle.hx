package game.battle;

class SonicBattle extends BattleBase
{
    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);
        isPlayer = true;
        scale.set(0.3,0.3);
        characterAtlas = 'Sonic_Battle';
        loadCharacterAnimations();
    }
}
