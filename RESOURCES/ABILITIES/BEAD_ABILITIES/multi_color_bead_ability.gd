extends BeadColorAbilityInfo

## Allows additional colors per bead with each stack
class_name MultiColorBeadAbility

## Allow multiple colors on a bead's sand color info, per stack
func apply_ability(application_target: Bead):
	while application_target.info.sand.colors.size() <= num_stacks:
		application_target.info.sand.add_color(SandMaterialInfo.SandColor.COLORLESS, false)
