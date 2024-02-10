# Enemy Data Types

```typescript
type Enemy = {
	name: string;
	health: number;
	rangedDamage: number;
	meleeDamage: number;
	speed: number;
	isRanged: boolean;
	meleeAttackSpeed: number;
	meleeAttackRange: number;
	rangedAttackSpeed: number;
	rangedAttackRange: number;
	size: number;
}
```

# Spells Data Types
```typescript
type Spell = {
	id: string;
	name: string;
	type: string;
	maxDistance: number;
	cooldown: number;
	projectileSpeed: number;
	damage: number;
}
```
