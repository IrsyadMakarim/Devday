extends RigidBody2D

var hit = false
const GRENADE_DAMAGE = 50
const GRENADE_TIME = 2
const EXPLOSION_WAIT_TIME = 0.48
var explosion_wait_timer = 0
var grenade_timer = 0
var blast_area
var rigid_shape
var explosion_particles
var exploded = false

signal grenade_exploded

func _ready():
	blast_area = $Blast_Area
	explosion_particles = $AnimationPlayer
	connect("grenade_exploded",self,"update_grenade")

func _process(delta):
#	if exploded == false:
		if grenade_timer < GRENADE_TIME:
			grenade_timer += delta
			return
		else:
			if explosion_wait_timer <= 0:
				explosion_particles.play("Explosion")
				var bodies = blast_area.get_overlapping_bodies()
				$Sprite.hide()
				mode = RigidBody.MODE_STATIC
				for body in bodies:
					if body.has_method("handle_hit"):
						body.handle_hit(GRENADE_DAMAGE)
					if body.has_method("player_hit"):
						body.player_hit(GRENADE_DAMAGE - 15)
				GrenadeAudio.position = position
				GrenadeAudio.play()
#				exploded = true
#				emit_signal("grenade_exploded")
			if explosion_wait_timer < EXPLOSION_WAIT_TIME:
				explosion_wait_timer += delta
				
				if explosion_wait_timer >= EXPLOSION_WAIT_TIME:
					queue_free()

func _on_DirectHit_body_entered(body):
	if "Enemy" in body.name or "Shooter" in body.name:
		explosion_particles.play("Explosion")
		$Sprite.hide()
#		exploded = true
#		emit_signal("grenade_exploded")
		var bodies = blast_area.get_overlapping_bodies()
		for body in bodies:
			if body.has_method("handle_hit"):
				body.handle_hit(GRENADE_DAMAGE)
		GrenadeAudio.position = position
		GrenadeAudio.play()
		queue_free()

func update_grenade():
	exploded = true
