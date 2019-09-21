extends KinematicBody2D
class_name Player
#Jump 
export var fallMultiplier = 2 
export var lowJumpMultiplier = 10 
export var jumpVelocity = 400 #Jump height
export var speed = 100
export var maxFallingSpeed = 1000;
export(String) var playerNumber = '1'
#Physics
var velocity = Vector2()
export var gravity = 8
var hp = 100
var isInBuilderMode = false
export var lookingVector = Vector2(1,0)
func get_input():
    #Applying gravity to player
    var newLookingVector = Vector2()
    velocity.y += gravity 
    if velocity.y > maxFallingSpeed:
        velocity.y = maxFallingSpeed
    #Jump Physics
    if velocity.y > 0: #Player is falling
        velocity += Vector2.UP * (-9.81) * (fallMultiplier) #Falling action is faster than jumping action | Like in mario

    elif velocity.y < 0 && Input.is_action_just_released("jump"+playerNumber): #Player is jumping 
        velocity += Vector2.UP * (-9.81) * (lowJumpMultiplier) #Jump Height depends on how long you will hold key

    if (Input.is_action_just_pressed("enableBuilder"+playerNumber)):
        isInBuilderMode = !isInBuilderMode
    if (!isInBuilderMode):
        if is_on_floor():
            if Input.is_action_just_pressed("jump"+playerNumber): 
                velocity = Vector2.UP * jumpVelocity #Normal Jump action
        if Input.is_action_pressed("right"+playerNumber):
            velocity.x = speed
            newLookingVector.x = 1
        elif Input.is_action_pressed("left"+playerNumber):
            velocity.x = -speed
            newLookingVector.x = -1
        else:
            velocity.x = 0
        if Input.is_action_pressed("up"+playerNumber):
            newLookingVector.y = -1
        elif Input.is_action_pressed("down"+playerNumber):
            newLookingVector.y = 1
        if newLookingVector.length() != 0:
            lookingVector = newLookingVector        
    velocity = move_and_slide(velocity, Vector2(0,-1))
    if Input.is_action_just_pressed('shoot'+playerNumber):
        $ProjectileSpawnPoint.shoot()
    

func _physics_process(delta):
    get_input()
    if hp<0:
        queue_free()
    var vp = get_viewport_rect().size
    if position.y < 0:
        position.y += vp.y
    if position.y > vp.y:
        position.y -= vp.y 
    if position.x < 0:
        position.x += vp.x
    if position.x > vp.x:
        position.x -= vp.x     
    
    
func hit():
    hp -= 5
    print("%s got hit, hp left %s"%[playerNumber, hp])