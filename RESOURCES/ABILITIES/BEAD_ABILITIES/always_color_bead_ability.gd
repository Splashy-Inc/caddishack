extends BeadColorAbilityInfo

## Adds color to a bead by default, cannot stack multiple "always" abilities
class_name AlwaysColorBeadAbility

@export var color : SandMaterialInfo.SandColor

## Fill in the color on the bead
func apply_ability(application_target: Bead):
	application_target.info.sand.add_color(color)
