patches-own [colors  setup-colors  no-dmg-colors  dmg-colors new-color]
pokeballs-own [xspeed  yspeed]
globals [mouse-down-before dmg-taken-mew dmg-taken-enemy wat]


breed [trainers trainer]
breed [pokeballs pokeball]
breed [bushes bush]
breed [houses house]
breed [fences fence]
breed [corner-fences1 corner-fence1]
breed [corner-fences2 corner-fence2]



;12-28: James - Created the setup title screen
;1-7: James & Jaylan - Created figures that rotate on the title screen
to setup
  ca
  resize-world -200 200 -200 200 ;new code
  set-patch-size 1.665

  import-pcolors "Title Screen.png" ;Jaylan's idea to import the title screen from a screenshot
  ask patch 14 -73 [set plabel "Start"]

  set-default-shape bushes "grass"
  set-default-shape houses "house colonial"
  set-default-shape fences "fence"
  set-default-shape corner-fences1 "corner-fence1"
  set-default-shape corner-fences2 "corner-fence2"
  set-default-shape pokeballs "pokeball"
  create-figures
  reset-ticks
end

;1-3: Jaylan - created code for button to work
;1-11: James - allowed trainer to move to second world and back
;1-12: James - created the code for the buttons on the game-over and title screens to work
to go
  if max-pxcor = 200 [
    if mouse-down? and mouse-inside? and not mouse-down-before and ([pcolor] of patch mouse-xcor mouse-ycor = 3)
      [wild]
    if mouse-down? and mouse-inside? and not mouse-down-before and ([pcolor] of patch mouse-xcor mouse-ycor = 87)
      [setup]
    set mouse-down-before mouse-down?
    rotate
  ]

  if any? trainers with [pycor = max-pycor] [wild2]
  if any? trainers with [pycor = min-pycor] [wild]

  battle-screens

  tick
end

;1-7: James - made the figures and had them rotate on the title screen
to rotate
  ask turtles [
    if shape = "trainer" [set heading heading + 1]
    if shape = "pokeball" [set heading heading - 1]
  ]
end
to create-figures
  crt 1 [set shape "trainer" setxy -120 -73 set heading 0 set size 80]
  crt 1 [set shape "pokeball" setxy 120 -73 set heading 0 set size 80]
end




;:::::::::::::::::::GAMEPLAY:::::::::::::::::::;

;1-4: Jaylan - created base code for the world
;1-8: James - organized code and added the environment (houses, fence, bushes, etc.)
;1-10: James - changed world generator code to just import pcolors
to wild
  ca
  resize-world -20 20 -20 20
  set-patch-size 16.32
  import-pcolors "wild.png"
  make-grass
  make-houses
  make-trainer
  make-fences
  reset-ticks
end

;1-9: James - Made the houses, fences and bushes
;1-11: James - cleaned up the code (used one-of function instead of re-creating another house)
to make-houses
  crt 2 [
    set breed houses
    setxy -12 11
    set color 87
    set size 14.4]
  ask one-of houses [setxy 11 11 set color 128]
end
to make-grass
  ask patches with [pcolor = 65.5] [
    sprout 1 [
      set breed bushes
      set pcolor lime + .5
      set color green - 1.5
      set size 3.5 ] ]
  if any? turtles with [shape = "tree"][
    ask n-of 25 patches with [pcolor = 65.6] [
      sprout 1 [
        set breed bushes
        set color green - 1.5
        set size 3]
    ]
  ]
end
;1-11: James - cleaned up code to use create-trainer instead of sprout
to make-trainer
  create-trainers 1[
    ifelse any? turtles with [shape = "tree"]
    [setxy 0 -19 set shape "trainerback"]
    [setxy 0 19 set shape "trainerfd"]
    set size 3]
end
to make-fences
  let top-or-bottom-fences patches with [(pycor = max-pycor or pycor = min-pycor) and
                                         (pxcor != min-pxcor and pxcor != max-pxcor) and
                                         (remainder pxcor 2 = 0)]
  let the-side-fences patches with [(pxcor = max-pxcor or pxcor = min-pxcor) and
                                    (pycor != min-pycor and pycor != max-pycor) and
                                    (remainder pycor 2 = 0)]
  let the-corner-fences1 patches with [(pxcor = max-pxcor and pycor = max-pycor) or
                                      (pycor = min-pxcor and pxcor = min-pxcor )]
  let the-corner-fences2 patches with [(pxcor = min-pxcor and pycor = max-pycor) or
                                      (pycor = min-pxcor and pxcor = max-pxcor )]

 ask top-or-bottom-fences[
        sprout 1[
          set breed fences
          set color brown - 1
          set size 3
    ]
  ]
  ask fences [
    if pxcor <= 4 and pxcor >= -4 and pycor = max-pycor[die]]
  ask the-side-fences [
    sprout 1[
      set breed fences
      set shape "fence-side"
      set color brown - 1
      set size 3
    ]
  ]
  ask the-corner-fences1 [
    sprout 1[
      set breed corner-fences1
      set color brown - 1
      set size 3
      ifelse pxcor > 0
      [set heading 0]
      [set heading 180]
    ]
  ]
  ask the-corner-fences2 [
    sprout 1[
      set breed corner-fences2
      set color brown - 1
      set size 3
      ifelse pxcor > 0
      [set heading 180]
      [set heading 0]
    ]
  ]
end

;1-11: James - created the second world and everything in it
to wild2
  ca
  resize-world -20 20 -20 20
  set-patch-size 16.32
  import-pcolors "wild2.png"
  create-trees
  make-grass
  make-trainer
  reset-ticks
end
to create-trees
  let top/bottom-trees patches with [(pycor = max-pycor or pycor = min-pycor) and (remainder pxcor 4 = 0)]
  let side-trees patches with [(pxcor = max-pxcor or pxcor = min-pxcor) and (remainder pycor 4 = 0)]

  ask top/bottom-trees [
    sprout 1 [
      set shape "tree"
      set size 4.55
    ]
  ]
  ask side-trees [
    sprout 1[
      set shape "tree"
      set size 4.55
    ]
  ]
  ask turtles with [pxcor <= 4 and pxcor >= -4 and pycor = min-pycor][die]
end







;---------------------------------BATTLE SCREENS-------------------------------------;

;1-4: Jaylan - created the code for randomly encountering pokemon
;1-10: James - made battle-screens function to tie the different battle screens together
;       Placed the aura-sphere and mega-punch procedures in battle-screens instead of each battle screen functions
to battle-screens
if max-pxcor = 20 [
  if any? trainers with [pcolor = lime + .5] [
      let n (random 1000) + 1
      if n <= 20 [battle-screen-pikachu]
      if n > 20 and n <= 30 [battle-screen-snorlax]
      if n > 30 and n <= 40 [battle-screen-cyndaquil]
    ]
  ]
  ???
  if max-pxcor = 100[
    if?pikachu
    if????
    if?snorlax
    if?cyndaquil

    aura-sphere
    mega-punch
  ]
  if max-pxcor = 100 and any? turtles with [shape = "pokeball"] [ pokeball-motion ]
end

;1-10: Jaylan - created the attacks for the trainer's pokemon
to aura-sphere
  create-aura-sphere
  movement-aura-sphere
end
to create-aura-sphere
  if mouse-down? and mouse-inside? and not (any? turtles) and (mouse-xcor >= -83 and mouse-xcor <= -5)
                                                          and (mouse-ycor >= -60 and mouse-ycor <= -42 and [pcolor] of patch -50 -50 = 8.5)
  [ask patch -45 10 [
    sprout 1 [
      set shape "aura sphere"
      set size 30
      set color 86 ] ] ]
end
to movement-aura-sphere
  ask turtles with [shape = "aura sphere"] [
    if pycor < 70 [
      setxy (xcor + 18.5) (ycor + 12.5)
      set heading heading + 20 ] ]
  if any? turtles with [pycor > 70 and shape = "aura sphere"] [
    ask turtles [
      die ]
    take-dmg-enemy
    wait 1
    if not any? patches with [pcolor = red and pxcor = -10] [
      if [pcolor] of patch 46 91 = 15 and wat = 2 [SPIT]
      if [pcolor] of patch 46 91 = 15 and wat = 1 [DE-WEY]
      if [pcolor] of patch 59 86 = 98 [take-a-nap]
      if [pcolor] of patch 35 79 = 72 [create-ember]
      if [pcolor] of patch 42 85 = 45.5 [spawn-lightning-pikachu] ] ]
  movement-lightning-pikachu
  movement-ember
  take-dmg-mew
end
to mega-punch
  create-mega-punch
  movement-mega-punch
end
to create-mega-punch
if mouse-down? and mouse-inside? and not (any? turtles) and (mouse-xcor >= -83 and mouse-xcor <= -5)
                                                        and (mouse-ycor >= -84 and mouse-ycor <= -65 and [pcolor] of patch -50 -50 = 8.5)
  [ask patch 48 68 [
    sprout 1 [
      set shape "fist"
      set size 11
      set color 14
  ] ] ]
end
to movement-mega-punch
  ask turtles with [shape = "fist"] [
    if size < 53 [
      set size size + 13.5] ]
  if any? turtles with [size > 53 and shape = "fist"] [
    wait 0.1
    ask turtles [
      die ]
    take-dmg-enemy
    wait 1
    if not any? patches with [pcolor = red and pxcor = -10] [
      if [pcolor] of patch 46 91 = 15 and wat = 2 [SPIT]
      if [pcolor] of patch 46 91 = 15 and wat = 1 [DE-WEY]
      if [pcolor] of patch 59 86 = 98 [take-a-nap]
      if [pcolor] of patch 35 79 = 72 [create-ember]
      if [pcolor] of patch 42 85 = 45.5 [spawn-lightning-pikachu] ] ]
  movement-lightning-pikachu
  movement-ember
  take-dmg-mew
end

;1-10: Jaylan - created code for the pokemon to take damage.
to take-dmg-enemy
  ask patches with [pcolor = 45.5 or pcolor = 98 or pcolor = 105 or pcolor = 72] [
    set pcolor dmg-colors ]
  tick
  wait 0.25
  ask patches with [pcolor = 16] [
    set pcolor no-dmg-colors ]
  if dmg-taken-enemy < 10 [
    set dmg-taken-enemy 10]
  ask patches with [pxcor >= -78 and pxcor <= (-78 + dmg-taken-enemy) and pcolor >= 51 and pcolor <= 68] [
    set pcolor red ]
  set dmg-taken-enemy dmg-taken-enemy + ((random 2 + 1) * 10)
  tick
end

;1-11: Jaylan - Created code for mew to take damage
to take-dmg-mew
  if any? turtles with [(ycor = 10 or ycor = 2) and (shape = "lightning" or (shape = "ember" and size > 44))] [
    ask turtles [die]
    ask patches with [pcolor = 136] [
      set no-dmg-colors 136
      set dmg-colors 16 ]
    tick
    ask patches with [pcolor = 136] [
      set pcolor dmg-colors ]
    tick
    wait 0.25
    ask patches with [pcolor = 16] [
      set pcolor no-dmg-colors ]
    if dmg-taken-mew < 10 [
      set dmg-taken-mew 10]
    ask patches with [pxcor >= 10 and pxcor <= (10 + dmg-taken-mew) and pcolor >= 51 and pcolor <= 68] [
      set pcolor red ]
    set dmg-taken-mew dmg-taken-mew + ((random 2 + 1) * 10)
    tick
    wait 1
    ifelse [pcolor] of patch 79 -17 = 66.3
    [ask patch 75 -52 [set plabel "What will you do?" ]
     ask patch 75 -62 [set plabel "" ]
     ask patch 75 -72 [set plabel ""]]
    [game-over]

    tick
  ]
end



;::::::::::::::::::::::::::::PIKACHU::::::::::::::::::::::::::::;


;1-10: Jaylan - created battle screens for pikachu
;1-10: James - created the boucing and spinning animation for the pokeball
;1-10: Jaylan - modified code to store the previous x and y of the trainer
to battle-screen-pikachu
  ca
  resize-world -100 100 -100 100
  set-patch-size 3.3234
  import-pcolors "Trainer to Pikachu.png"

  ask patches [
    set plabel-color black ]

  ask patch -10 65 [
    set plabel "PIKACHU" ]
  ask patch 80 -5 [
    set plabel "MEW" ]
  ask patch 75 -52 [
    set plabel "A wild Pikachu" ]
  ask patch 75 -62 [
    set plabel "appeared!!!!" ]
  ask patch -32 -52 [
    set plabel "Aura Sphere" ]
  ask patch -32 -77 [
    set plabel "Mega Punch" ]

  reset-ticks
end
to if?pikachu
  if max-pxcor = 100 and [pcolor] of patch 42 85 = 45.5[

    ask patches with [pcolor > 41 and pcolor < 49] [
      set no-dmg-colors (45.5)
      set dmg-colors 16 ]

    if [plabel] of patch -10 65 = "PIKACHU" [

      ask patch -10 65 [
        set plabel " PIKACHU" ]

      tick
      wait 1

      ask patch 75 -52 [
        set plabel "Go Mew!!!!" ]
      ask patch 75 -62 [
        set plabel ""]

      tick
      wait 2

      import-pcolors "None to Pikachu.png"
   ask patch -98 40 [
        sprout 1 [
          set breed pokeballs
          set size 15
          set xspeed 3
          set yspeed 3] ] ]
    pokeball-motion
    if any? turtles with [xcor >= -50 and shape = "pokeball"] [
      ask turtles [die]
      import-pcolors "Mew to Pikachu.png"
      ask patch 75 -52 [
        set plabel "What will you do?" ] ]
    faint-pikachu
    tick
  ]
end
;1-10: Jaylan - created code for when the trainer wins the fight
to faint-pikachu
  if any? patches with [pxcor = -10 and pcolor = red] and ([pcolor] of patch 47 74 = 45.5) [
    ask patch 75 -52 [
      set plabel "Enemy Pikachu" ]
    ask patch 75 -62 [
      set plabel "has Fainted!" ]
    wait 0.5]
  tick

  if [plabel] of patch 75 -52 = "Enemy Pikachu" [
    wait 1
    wild]
end
;1-11: Jaylan - Created code for the pikachu to fight back
to spawn-lightning-pikachu
  ask patch -48 50 [
    sprout 1  [
      set shape "lightning"
      set size 30
      set color yellow ] ]
  ask patch 75 -52 [
    set plabel " Enemy Pikachu" ]
  ask patch 75 -62 [
    set plabel "used" ]
  ask patch 75 -72 [
    set plabel "Lightning Bolt!" ]
end
to movement-lightning-pikachu
  ask turtles with [shape = "lightning"] [
    if ycor > 10 [
      set ycor ycor - 5] ]
end


;::::::::::::::::::::::::::::SNORLAX::::::::::::::::::::::::::::;


;1-14: James - created code for snorlax battle screens
to battle-screen-snorlax
  ca
  resize-world -100 100 -100 100
  set-patch-size 3.3234
  import-pcolors "Trainer to Snorlax.png"

  ask patches [
    set plabel-color black ]

  ask patch -10 65 [
    set plabel "SNORLAX" ]
  ask patch 80 -5 [
    set plabel "MEW" ]
  ask patch 75 -52 [
    set plabel "A wild Snorlax" ]
  ask patch 75 -62 [
    set plabel "appeared!!!!" ]
  ask patch -32 -52 [
    set plabel "Aura Sphere" ]
  ask patch -32 -77 [
    set plabel "Mega Punch" ]

  reset-ticks
end
to if?snorlax
  if max-pxcor = 100 and [pcolor] of patch 59 86 = 98[

    ask patches with [pcolor = 98 or pcolor = 105] [
      set no-dmg-colors pcolor
      set dmg-colors 16 ]

    if [plabel] of patch -10 65 = "SNORLAX" [

      ask patch -10 65 [
        set plabel " SNORLAX" ]

      tick
      wait 1

      ask patch 75 -52 [
        set plabel "Go Mew!!!!" ]
      ask patch 75 -62 [
        set plabel ""]

      tick
      wait 2

      import-pcolors "None to Snorlax.png"
   ask patch -98 40 [
        sprout 1 [
          set breed pokeballs
          set size 15
          set xspeed 3
          set yspeed 3] ] ]
    pokeball-motion
    if any? turtles with [xcor >= -50 and shape = "pokeball"] [
      ask turtles [die]
      import-pcolors "Mew to Snorlax.png"
      ask patch 75 -52 [
        set plabel "What will you do?" ] ]

    faint-snorlax

    tick

  ]
end
to faint-snorlax
  if any? patches with [pxcor = -10 and pcolor = red] and ([pcolor] of patch 59 87 = 98) [
    ask patch 75 -52 [
      set plabel "Snorlax" ]
    ask patch 75 -62 [
      set plabel "Entered a" ]
    ask patch 75 -72 [
      set plabel "Deep Sleep"]
    wait 0.5]
  tick

  if [plabel] of patch 75 -52 = "Snorlax" [
    wait 1
    wild]
end
to take-a-nap
  ask patch 75 -52 [
    set plabel " Snorlax decided" ]
  ask patch 75 -62 [
    set plabel "to sleep" ]
  ask patch 75 -72 [
    set plabel ""]
  tick
  wait 2
  if [plabel] of patch 75 -52 != "What will you do?"[
     ask patch 75 -52 [set plabel "What will you do?" ]
     ask patch 75 -62 [set plabel "" ]
     ask patch 75 -72 [set plabel ""]]
end


;::::::::::::::::::::::::::::PIKACHU::::::::::::::::::::::::::::;


;1-14: James - edited code for cyndaquil
;1-14: Jaylan - created artwork for cyndaquil
to battle-screen-cyndaquil
  ca
  resize-world -100 100 -100 100
  set-patch-size 3.3234
  import-pcolors "Trainer to Cyndaquil.png"

  ask patches [
    set plabel-color black ]

  ask patch -10 65 [
    set plabel "CYNDAQUIL" ]
  ask patch 80 -5 [
    set plabel "MEW" ]
  ask patch 75 -52 [
    set plabel "A wild Cyndaquil" ]
  ask patch 75 -62 [
    set plabel "appeared!!!!" ]
  ask patch -32 -52 [
    set plabel "Aura Sphere" ]
  ask patch -32 -77 [
    set plabel "Mega Punch" ]

  reset-ticks
end

to if?cyndaquil
  if max-pxcor = 100 and [pcolor] of patch 35 79 = 72[

    ask patches with [pcolor = 72] [
      set no-dmg-colors pcolor
      set dmg-colors 16 ]

  if [plabel] of patch -10 65 = "CYNDAQUIL" [

      ask patch -10 65 [
        set plabel " CYNDAQUIL" ]

      tick
      wait 1

      ask patch 75 -52 [
        set plabel "Go Mew!!!!" ]
      ask patch 75 -62 [
        set plabel ""]

      tick
      wait 2

      import-pcolors "None to Cyndaquil.png"
   ask patch -98 40 [
        sprout 1 [
          set breed pokeballs
          set size 15
          set xspeed 3
          set yspeed 3] ] ]
    pokeball-motion
    if any? turtles with [xcor >= -50 and shape = "pokeball"] [
      ask turtles [die]
      import-pcolors "Mew to Cyndaquil.png"
      ask patch 75 -52 [
        set plabel "What will you do?" ] ]
    faint-cyndaquil
    tick
  ]
end
to faint-cyndaquil
  if any? patches with [pxcor = -10 and pcolor = red] and ([pcolor] of patch 35 79 = 72) [
    ask patch 75 -52 [
      set plabel "Cyndaquil" ]
    ask patch 75 -62 [
      set plabel "Has Fainted!" ]
    ask patch 75 -72 [
      set plabel ""]
    wait 0.5]
  tick

  if [plabel] of patch 75 -52 = "Cyndaquil" [
    wait 1
    wild]
end
;1-14: Jaylan - created code for ember attack
to create-ember
  ask patch -45 2[
    sprout 1 [
      set shape "ember"
      set size 11
      set color 14
  ] ]
  ask patch 75 -52 [
    set plabel " Enemy Cyandaquil" ]
  ask patch 75 -62 [
    set plabel "used" ]
  ask patch 75 -72 [
    set plabel "Ember!" ]
end
to movement-ember
  ask turtles with [shape = "ember"] [
    if size < 44 [
      set size size + 4] ]
end


;1-14: James - created code for easter egg
;1-14: **Jaylan** - created images for easter egg
to battle-screen-???
  ca
  resize-world -100 100 -100 100
  set-patch-size 3.3234
  import-pcolors "Trainer to ???.png"
  set wat 1

  ask patches [
    set plabel-color black ]

  ask patch -10 65 [
    set plabel "KNUCKLES" ]
  ask patch 80 -5 [
    set plabel "MEW" ]
  ask patch 75 -52 [
    set plabel "A wild Knuckles" ]
  ask patch 75 -62 [
    set plabel "appeared!!!!" ]
  ask patch -32 -52 [
    set plabel "Aura Sphere" ]
  ask patch -32 -77 [
    set plabel "Mega Punch" ]

  reset-ticks
end
to if????
  if max-pxcor = 100 and [pcolor] of patch 46 91 = 15 [

    ask patches with [pcolor > 41 and pcolor < 49] [
      set no-dmg-colors (45.5)
      set dmg-colors 16 ]

    if [plabel] of patch -10 65 = "KNUCKLES" [

      ask patch -10 65 [
        set plabel " KNUCKLES" ]

      tick
      wait 1

      ask patch 75 -52 [
        set plabel "Go Mew!!!!" ]
      ask patch 75 -62 [
        set plabel ""]

      tick
      wait 2

      import-pcolors "None to ???.png"
   ask patch -98 39 [
        sprout 1 [
          set breed pokeballs
          set size 15
          set xspeed 3
          set yspeed 3] ] ]
    pokeball-motion
    if any? turtles with [xcor >= -50 and shape = "pokeball"] [
      ask turtles [die]
      import-pcolors "Mew to ???.png"
      ask patch 75 -52 [
        set plabel "What will you do?" ] ]
    tick
  ]

end

to DE-WEY
  ask patch 75 -52 [
    set plabel " Enemy Knuckles" ]
  ask patch 75 -62 [
    set plabel "showed" ]
  ask patch 75 -72 [
    set plabel "DE WEY!" ]
  set wat 2
  tick
  wait 1.5
  ask patch 75 -52 [
    set plabel " What will you do?" ]
  ask patch 75 -62 [
    set plabel "" ]
  ask patch 75 -72 [
    set plabel "" ]
  tick
end

to SPIT
  ask patch 75 -52 [
    set plabel " Enemy Knuckles" ]
  ask patch 75 -62 [
    set plabel "spit on" ]
  ask patch 75 -72 [
    set plabel "the fake queen!" ]
  tick
  wait 2
  game-over
end



;::::::::::::::::::POKEBALL MOTIONS::::::::::::::::::;
;1-10: James - created code for the pokeball to bounce into the battle screens
to pokeball-motion
  ask pokeballs
  [motion
   gravity
   bounce]
    tick
end
to motion
  set xcor xcor + xspeed
  set ycor ycor + yspeed
  set heading heading + 15
end
to gravity
  set yspeed yspeed - 1
end
to bounce
  if ycor <= -14 [
    set yspeed -.7 * yspeed
  ]
end

;------------------------------------------------------------------------------------;



;:::::::::TRAINER MOVEMENT:::::::::;

;1-4: Jaylan - created shapes for the trainer and the movement mechanics
;1-5: James - modified code so the player not escape the world boundaries
;1-10: James - modified code to allow player to exit the world to the next through the gap in the fence
to moveright
  ask trainers [
    if shape != "trainerright" [
      set shape "trainerright"
      set heading 90]
    if shape = "trainerright" and [pcolor] of patch-ahead 1 != 64 and [pcolor] of patch-ahead 1 != 65.8 and [pcolor] of patch-ahead 1 != 86.2[
      set xcor (xcor + 1) ]
  ]
end
to moveback
  ask trainers [
    if shape != "trainerfd" [
      set shape "trainerfd"
      set heading 180]
    if shape = "trainerfd" and [pcolor] of patch-ahead 1 != 64 and [pcolor] of patch-ahead 1 != 65.8 and [pcolor] of patch-ahead 1 != 86.2[
      set ycor (ycor - 1) ]
  ]
end
to moveleft
  ask trainers [
    if shape != "trainerleft" [
      set shape "trainerleft"
      set heading 270]
    if shape = "trainerleft" and [pcolor] of patch-ahead 1 != 64 and [pcolor] of patch-ahead 1 != 65.8 and [pcolor] of patch-ahead 1 != 86.2[
      set xcor (xcor - 1) ]
  ]
end
to moveup
  ask trainers [
    if shape != "trainerback" [
      set shape "trainerback"
      set heading 0]
    if shape = "trainerback" and [pcolor] of patch-ahead 1 != 64 and [pcolor] of patch-ahead 1 != 65.8 and [pcolor] of patch-ahead 1 != 86.2[
      set ycor (ycor + 1) ]
  ]
end

to game-over
  ca
  resize-world -200 200 -200 200
  set-patch-size 1.665
  import-pcolors "game-over screen.png"
  ask patch 36 -88 [set plabel "RESTART?" set plabel-color black ]
  reset-ticks
end

to ???
  let n (random 10000000) + 1
  if n <= 1 [battle-screen-???]
end
@#$#@#$#@
GRAPHICS-WINDOW
5
10
665
671
-1
-1
3.3234
1
25
1
1
1
0
1
0
1
-100
100
-100
100
1
1
1
ticks
30.0

BUTTON
687
93
764
140
NIL
wild
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1074
148
1138
181
Right
moveright
NIL
1
T
OBSERVER
NIL
D
NIL
NIL
1

BUTTON
1013
180
1076
213
Back
moveback
NIL
1
T
OBSERVER
NIL
S
NIL
NIL
1

BUTTON
1013
116
1076
149
Up
MoveUp
NIL
1
T
OBSERVER
NIL
W
NIL
NIL
1

BUTTON
951
147
1014
180
Left
moveLeft
NIL
1
T
OBSERVER
NIL
A
NIL
NIL
1

BUTTON
687
196
820
246
NIL
battle-screen-pikachu
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
777
11
862
61
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
688
11
775
61
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
687
142
765
192
NIL
wild2
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
687
354
782
405
NIL
game-over
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
687
248
820
301
NIL
battle-screen-snorlax
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
687
304
817
352
NIL
battle-screen-cyndaquil
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

@#$#@#$#@
## WHAT IS IT?

This model is based on the game Pokemon where the player has the ability to move around the world and fight pokemon. However, in this version there are only 5 available pokemon in the wild and the player can only have one pokemon.

## HOW IT WORKS

The main feature the agents use in the model is their ability to detect other agents in the surrounding area or their position in the world. The trainer enters a fight if there are other pokemon in the area. The different buttons depend on the position of the mouse.

## HOW TO USE IT

First setup the model and press go to get the initiate the code. Then press the "start game" in the world to being playing. Using the "W" "A" "S" "D" keys on the keyboard move the player around the world. Depending on the section of the world, different pokemon have varying chances to spawn. Once encountering a pokemon, the player will enter a battle screen that can be interacted with using the mouse and various buttons. The buttons will be used for certain attacks and abilities. Meanwhile the comment section to the right of the buttons will commentate on the action. 

## THINGS TO NOTICE

-The fences and how they interlocks perfectly.
-The smooth animations of the battle screens, turtles (pokeball, trainer, etc), and the  
 buttons
-?? pokemon - limited edition special pokemon(?) can appear.


## EXTENDING THE MODEL

Suggested features include adding the ability to capture more pokemon and leveling up obtained pokemon. Fix the movements for the trainer, instead of using the keyboard to move the player around, utilize the mouse where the trainer will automatically move towards the patch clicked on. Once leaving the battle screen, have the trainer respawn where he left off.

## NETLOGO FEATURES

Utilized the "resize world" and "resize patches" commands to change the shape of the world and patches to  better suit the frames.

## RELATED MODELS

-Pokemon games by Nintendo
-Bouncing Ball Lab by Mr. Konstantinovich
-VR chat?

## CREDITS AND REFERENCES

BY: Jaylan Wu, James Chun (Team Racket)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

aura sphere
true
0
Rectangle -13345367 true false 30 120 45 180
Rectangle -13345367 true false 255 120 270 180
Rectangle -13345367 true false 120 255 180 270
Rectangle -13345367 true false 120 30 180 45
Rectangle -13345367 true false 45 90 60 120
Rectangle -13345367 true false 240 90 255 135
Rectangle -13345367 true false 240 165 255 210
Rectangle -13345367 true false 45 180 60 210
Rectangle -13345367 true false 90 240 120 255
Rectangle -13345367 true false 180 240 210 255
Rectangle -13345367 true false 165 45 210 60
Rectangle -13345367 true false 90 45 135 60
Rectangle -13345367 true false 60 75 75 90
Rectangle -13345367 true false 75 60 90 75
Rectangle -13345367 true false 210 60 225 75
Rectangle -13345367 true false 225 75 240 90
Rectangle -13345367 true false 225 210 240 225
Rectangle -13345367 true false 210 225 210 240
Rectangle -13345367 true false 210 225 225 240
Rectangle -13345367 true false 75 225 90 240
Rectangle -13345367 true false 60 210 75 225
Rectangle -7500403 true true 60 120 240 180
Rectangle -7500403 true true 75 90 225 120
Rectangle -7500403 true true 75 180 225 210
Rectangle -7500403 true true 90 75 210 90
Rectangle -7500403 true true 90 210 210 225
Rectangle -7500403 true true 105 225 195 240
Rectangle -7500403 true true 105 60 195 75
Rectangle -7500403 true true 135 45 165 60
Rectangle -7500403 true true 135 240 165 255
Rectangle -7500403 true true 45 150 60 150
Rectangle -7500403 true true 45 135 60 165
Rectangle -7500403 true true 240 135 255 165
Rectangle -7500403 true true 60 105 75 120
Rectangle -7500403 true true 225 105 240 105
Rectangle -7500403 true true 225 105 240 120
Rectangle -7500403 true true 60 180 75 195
Rectangle -7500403 true true 225 180 240 195
Rectangle -13345367 true false 45 165 60 210
Rectangle -13345367 true false 60 75 75 105
Rectangle -13345367 true false 75 60 90 90
Rectangle -13345367 true false 90 45 105 75
Rectangle -13345367 true false 195 45 210 75
Rectangle -13345367 true false 210 60 225 90
Rectangle -13345367 true false 225 75 240 105
Rectangle -13345367 true false 45 105 60 135
Rectangle -13345367 true false 60 195 75 225
Rectangle -13345367 true false 75 210 90 240
Rectangle -13345367 true false 90 225 105 255
Rectangle -13345367 true false 120 240 135 270
Rectangle -13345367 true false 165 240 180 270
Rectangle -13345367 true false 195 225 210 255
Rectangle -13345367 true false 210 210 225 240
Rectangle -13345367 true false 225 195 240 225

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

building store
false
0
Rectangle -7500403 true true 30 45 45 240
Rectangle -16777216 false false 30 45 45 165
Rectangle -7500403 true true 15 165 285 255
Rectangle -16777216 true false 120 195 180 255
Line -7500403 true 150 195 150 255
Rectangle -16777216 true false 30 180 105 240
Rectangle -16777216 true false 195 180 270 240
Line -16777216 false 0 165 300 165
Polygon -7500403 true true 0 165 45 135 60 90 240 90 255 135 300 165
Rectangle -7500403 true true 0 0 75 45
Rectangle -16777216 false false 0 0 75 45

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

corner-fence1
true
4
Rectangle -6459832 true false 90 90 120 210
Rectangle -7500403 true false 75 90 90 210
Rectangle -1184463 true true 120 90 135 210
Rectangle -1184463 true true 90 75 120 90
Rectangle -1184463 true true 90 210 120 225
Rectangle -1184463 true true 135 270 165 285
Rectangle -1184463 true true 120 225 135 270
Rectangle -6459832 true false 135 225 165 270
Rectangle -6459832 true false 45 105 165 135
Rectangle -6459832 true false 90 90 120 210
Rectangle -6459832 true false 45 165 165 195
Rectangle -1184463 true true 165 225 180 270
Rectangle -1184463 true true 120 90 135 210
Rectangle -1184463 true true 75 90 90 210
Rectangle -7500403 true false 45 195 75 210
Rectangle -7500403 true false 75 210 90 225
Rectangle -7500403 true false 120 210 135 225
Rectangle -7500403 true false 105 225 120 240
Rectangle -6459832 true false 135 285 165 300
Rectangle -1184463 true true 135 195 165 225
Rectangle -7500403 true false 120 270 135 285

corner-fence2
true
4
Rectangle -1184463 true true 180 75 210 90
Rectangle -1184463 true true 180 210 210 225
Rectangle -1184463 true true 135 270 165 285
Rectangle -1184463 true true 120 225 135 270
Rectangle -6459832 true false 135 225 165 270
Rectangle -6459832 true false 135 105 255 135
Rectangle -6459832 true false 180 90 210 210
Rectangle -6459832 true false 135 165 255 195
Rectangle -1184463 true true 165 225 180 270
Rectangle -1184463 true true 210 90 225 210
Rectangle -1184463 true true 165 90 180 210
Rectangle -7500403 true false 225 195 255 210
Rectangle -7500403 true false 165 210 180 225
Rectangle -7500403 true false 210 210 225 225
Rectangle -7500403 true false 180 225 195 240
Rectangle -6459832 true false 135 285 165 300
Rectangle -1184463 true true 135 195 165 225
Rectangle -7500403 true false 120 270 135 285

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

ember
false
0
Polygon -7500403 true true 151 286 134 282 103 282 59 248 40 210 32 157 37 108 68 146 71 109 83 72 111 27 127 55 148 11 167 41 180 112 195 57 217 91 226 126 227 203 256 156 256 201 238 263 213 278 183 281
Polygon -955883 true false 126 284 91 251 85 212 91 168 103 132 118 153 125 181 135 141 151 96 185 161 195 203 193 253 164 286
Polygon -2674135 true false 155 284 172 268 172 243 162 224 148 201 130 233 131 260 135 282

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fence
false
4
Rectangle -6459832 true false 90 90 120 210
Rectangle -7500403 true false 75 90 90 210
Rectangle -1184463 true true 120 90 135 210
Rectangle -1184463 true true 90 75 120 90
Rectangle -1184463 true true 90 210 120 225
Rectangle -1184463 true true 180 210 210 225
Rectangle -1184463 true true 180 75 210 90
Rectangle -6459832 true false 180 90 210 210
Rectangle -6459832 true false 45 105 255 135
Rectangle -6459832 true false 90 90 120 210
Rectangle -6459832 true false 45 165 255 195
Rectangle -1184463 true true 165 90 180 210
Rectangle -1184463 true true 210 90 225 210
Rectangle -1184463 true true 120 90 135 210
Rectangle -1184463 true true 75 90 90 210
Rectangle -7500403 true false 45 195 75 210
Rectangle -7500403 true false 75 210 90 225
Rectangle -7500403 true false 135 195 165 210
Rectangle -7500403 true false 120 210 180 225
Rectangle -7500403 true false 210 210 225 225
Rectangle -7500403 true false 225 195 255 210

fence-side
false
4
Rectangle -6459832 true false 135 180 165 225
Rectangle -1184463 true true 120 75 135 120
Rectangle -1184463 true true 165 75 180 120
Rectangle -1184463 true true 135 60 165 75
Rectangle -1184463 true true 135 225 165 240
Rectangle -7500403 true false 120 120 135 180
Rectangle -7500403 true false 165 120 180 180
Rectangle -1184463 true true 135 120 165 135
Rectangle -1184463 true true 135 165 165 180
Rectangle -1184463 true true 120 180 135 225
Rectangle -1184463 true true 165 180 180 225
Rectangle -6459832 true false 135 75 165 120
Rectangle -6459832 true false 135 135 165 165
Rectangle -6459832 true false 135 240 165 255
Rectangle -6459832 true false 135 45 165 60

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

fist
false
0
Rectangle -16777216 true false 120 210 195 225
Rectangle -16777216 true false 180 90 195 210
Rectangle -16777216 true false 180 60 255 75
Rectangle -16777216 true false 120 45 195 60
Rectangle -16777216 true false 240 75 255 195
Rectangle -16777216 true false 180 195 255 210
Rectangle -16777216 true false 135 240 240 255
Rectangle -16777216 true false 135 225 150 255
Rectangle -16777216 true false 165 225 180 255
Rectangle -16777216 true false 225 210 240 240
Rectangle -16777216 true false 120 90 135 210
Rectangle -16777216 true false 60 105 75 210
Rectangle -16777216 true false 60 60 135 75
Rectangle -16777216 true false 15 75 75 90
Rectangle -16777216 true false 15 90 30 195
Rectangle -16777216 true false 15 180 75 195
Rectangle -16777216 true false 60 210 135 225
Rectangle -7500403 true true 30 90 60 180
Rectangle -7500403 true true 75 75 120 210
Rectangle -7500403 true true 135 60 180 210
Rectangle -7500403 true true 195 75 240 195
Rectangle -7500403 true true 210 225 210 225
Rectangle -7500403 true true 195 210 225 240
Rectangle -7500403 true true 180 225 195 240
Rectangle -7500403 true true 150 225 165 240
Rectangle -7500403 true true 60 90 75 105
Rectangle -7500403 true true 120 75 135 90
Rectangle -7500403 true true 180 75 195 90

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

flower budding
false
0
Polygon -7500403 true true 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Polygon -7500403 true true 189 233 219 188 249 173 279 188 234 218
Polygon -7500403 true true 180 255 150 210 105 210 75 240 135 240
Polygon -7500403 true true 180 150 180 120 165 97 135 84 128 121 147 148 165 165
Polygon -7500403 true true 170 155 131 163 175 167 196 136

grass
false
5
Polygon -10899396 true true 90 90 135 120 150 150 90 90
Polygon -10899396 true true 150 150 150 105 180 75 165 120 150 150

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

house colonial
false
0
Rectangle -7500403 true true 270 75 285 255
Rectangle -7500403 true true 45 135 270 255
Rectangle -16777216 true false 124 195 187 256
Rectangle -16777216 true false 60 195 105 240
Rectangle -16777216 true false 60 150 105 180
Rectangle -16777216 true false 210 150 255 180
Line -16777216 false 270 135 270 255
Polygon -16777216 true false 30 135 285 135 240 90 75 90
Line -16777216 false 30 135 285 135
Line -16777216 false 255 105 285 135
Line -7500403 true 154 195 154 255
Rectangle -16777216 true false 210 195 255 240
Rectangle -16777216 true false 135 150 180 180

house two story
false
0
Polygon -7500403 true true 2 180 227 180 152 150 32 150
Rectangle -7500403 true true 270 75 285 255
Rectangle -7500403 true true 75 135 270 255
Rectangle -16777216 true false 124 195 187 256
Rectangle -16777216 true false 210 195 255 240
Rectangle -16777216 true false 90 150 135 180
Rectangle -16777216 true false 210 150 255 180
Line -16777216 false 270 135 270 255
Rectangle -7500403 true true 15 180 75 255
Polygon -7500403 true true 60 135 285 135 240 90 105 90
Line -16777216 false 75 135 75 180
Rectangle -16777216 true false 30 195 93 240
Line -16777216 false 60 135 285 135
Line -16777216 false 255 105 285 135
Line -16777216 false 0 180 75 180
Line -7500403 true 60 195 60 240
Line -7500403 true 154 195 154 255

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

leaf 2
false
0
Rectangle -7500403 true true 144 218 156 298
Polygon -7500403 true true 150 263 133 276 102 276 58 242 35 176 33 139 43 114 54 123 62 87 75 53 94 30 104 39 120 9 155 31 180 68 191 56 216 85 235 125 240 173 250 165 248 205 225 247 200 271 176 275

lightning
false
0
Polygon -7500403 true true 120 135 90 195 135 195 105 300 225 165 180 165 210 105 165 105 195 0 75 135

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

pokeball
true
12
Rectangle -1 true false 135 135 150 150
Rectangle -1 true false 120 75 135 120
Rectangle -1 true false 105 90 150 105
Rectangle -1 true false 90 165 135 180
Rectangle -1 true false 105 180 150 195
Rectangle -1 true false 75 150 90 165
Rectangle -16777216 true false 120 45 180 60
Rectangle -16777216 true false 120 210 180 225
Rectangle -16777216 true false 90 195 120 210
Rectangle -16777216 true false 180 195 210 210
Rectangle -16777216 true false 180 60 210 75
Rectangle -16777216 true false 90 60 120 75
Rectangle -16777216 true false 75 75 90 105
Rectangle -16777216 true false 210 75 225 105
Rectangle -16777216 true false 210 165 225 195
Rectangle -16777216 true false 75 165 90 195
Rectangle -16777216 true false 60 105 75 165
Rectangle -16777216 true false 225 105 240 165
Rectangle -16777216 true false 90 150 135 165
Rectangle -16777216 true false 165 150 210 165
Rectangle -16777216 true false 135 165 165 180
Rectangle -16777216 true false 135 120 165 135
Rectangle -16777216 true false 75 135 90 150
Rectangle -16777216 true false 210 135 225 150
Rectangle -7500403 true false 120 195 180 210
Rectangle -7500403 true false 150 180 210 195
Rectangle -7500403 true false 165 165 210 180
Rectangle -7500403 true false 210 150 225 165
Rectangle -7500403 true false 90 180 105 195
Rectangle -7500403 true false 150 150 165 165
Rectangle -7500403 true false 135 150 150 165
Rectangle -7500403 true false 150 135 165 150
Rectangle -2674135 true false 75 105 120 135
Rectangle -2674135 true false 150 75 210 120
Rectangle -2674135 true false 120 60 180 75
Rectangle -2674135 true false 135 75 195 90
Rectangle -2674135 true false 165 105 225 135
Rectangle -2674135 true false 165 105 225 135
Rectangle -2674135 true false 180 120 210 150
Rectangle -2674135 true false 90 120 120 150
Rectangle -16777216 true false 120 120 135 150
Rectangle -2674135 true false 135 105 195 120
Rectangle -2674135 true false 90 75 120 90
Rectangle -2674135 true false 90 90 105 105

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

trainer
true
11
Rectangle -1 true false 135 135 165 165
Rectangle -16777216 true false 120 135 135 165
Rectangle -16777216 true false 165 135 180 165
Rectangle -1 true false 90 120 210 135
Rectangle -1 true false 90 135 120 165
Rectangle -1 true false 180 135 210 165
Rectangle -1 true false 105 165 195 180
Rectangle -1 true false 60 120 75 150
Rectangle -1 true false 75 135 90 150
Rectangle -1 true false 210 135 225 150
Rectangle -1 true false 225 120 240 150
Rectangle -16777216 true false 45 120 60 150
Rectangle -16777216 true false 60 150 90 180
Rectangle -16777216 true false 90 165 105 210
Rectangle -16777216 true false 105 180 210 210
Rectangle -16777216 true false 195 165 210 180
Rectangle -16777216 true false 210 150 240 180
Rectangle -16777216 true false 240 120 255 150
Rectangle -16777216 true false 90 120 90 135
Rectangle -16777216 true false 210 120 225 135
Rectangle -16777216 true false 60 105 240 120
Rectangle -16777216 true false 195 105 240 105
Rectangle -16777216 true false 195 90 240 105
Rectangle -16777216 true false 60 90 105 105
Rectangle -16777216 true false 75 60 90 90
Rectangle -16777216 true false 90 45 105 60
Rectangle -16777216 true false 210 60 225 90
Rectangle -16777216 true false 195 45 210 60
Rectangle -16777216 true false 105 30 195 45
Rectangle -7500403 true false 105 45 135 105
Rectangle -7500403 true false 90 60 105 90
Rectangle -7500403 true false 165 45 195 105
Rectangle -7500403 true false 135 45 165 90
Rectangle -7500403 true false 195 60 210 90
Rectangle -1 true false 135 90 165 105
Rectangle -1 true false 210 180 240 210
Rectangle -1 true false 60 180 90 210
Rectangle -16777216 true false 45 180 60 210
Rectangle -16777216 true false 60 210 105 225
Rectangle -16777216 true false 240 180 255 210
Rectangle -16777216 true false 195 210 240 225
Rectangle -7500403 true false 105 210 135 225
Rectangle -7500403 true false 165 210 195 225
Rectangle -7500403 true false 135 225 165 240
Rectangle -7500403 true false 90 240 135 255
Rectangle -7500403 true false 90 225 105 240
Rectangle -7500403 true false 165 240 210 255
Rectangle -7500403 true false 195 225 210 240
Rectangle -16777216 true false 75 225 90 255
Rectangle -16777216 true false 90 255 135 270
Rectangle -16777216 true false 135 240 165 255
Rectangle -16777216 true false 105 225 135 240
Rectangle -16777216 true false 135 210 165 225
Rectangle -16777216 true false 165 225 195 240
Rectangle -16777216 true false 165 255 210 270
Rectangle -16777216 true false 210 225 225 255
Rectangle -16777216 true false 75 120 90 135

trainerback
false
2
Rectangle -7500403 true false 105 60 195 135
Rectangle -7500403 true false 30 120 45 105
Rectangle -7500403 true false 90 75 105 120
Rectangle -7500403 true false 195 75 210 120
Rectangle -16777216 true false 75 75 90 150
Rectangle -16777216 true false 90 120 105 165
Rectangle -16777216 true false 210 75 225 150
Rectangle -16777216 true false 195 120 210 165
Rectangle -16777216 true false 90 60 105 75
Rectangle -16777216 true false 195 60 210 75
Rectangle -16777216 true false 105 45 195 60
Rectangle -16777216 true false 120 30 180 45
Rectangle -16777216 true false 105 135 195 165
Rectangle -16777216 true false 120 165 180 180
Rectangle -1 true false 60 135 75 165
Rectangle -1 true false 75 150 90 165
Rectangle -1 true false 90 165 120 180
Rectangle -1 true false 180 165 210 180
Rectangle -1 true false 225 135 240 165
Rectangle -1 true false 210 150 225 165
Rectangle -7500403 true false 120 180 180 195
Rectangle -16777216 true false 120 195 180 210
Rectangle -16777216 true false 60 165 90 195
Rectangle -16777216 true false 210 165 240 195
Rectangle -16777216 true false 90 180 120 195
Rectangle -16777216 true false 180 180 210 195
Rectangle -16777216 true false 75 195 105 225
Rectangle -16777216 true false 45 195 60 225
Rectangle -1 true false 60 195 75 225
Rectangle -16777216 true false 45 135 60 165
Rectangle -16777216 true false 60 105 75 135
Rectangle -16777216 true false 240 135 255 165
Rectangle -16777216 true false 225 105 240 135
Rectangle -16777216 true false 195 195 225 225
Rectangle -1 true false 225 195 240 225
Rectangle -16777216 true false 240 195 255 225
Rectangle -7500403 true false 120 225 180 240
Rectangle -7500403 true false 105 210 135 225
Rectangle -7500403 true false 165 210 195 225
Rectangle -7500403 true false 180 195 195 210
Rectangle -7500403 true false 105 195 120 210
Rectangle -1 true false 135 210 165 225
Rectangle -16777216 true false 60 225 120 240
Rectangle -16777216 true false 180 225 240 240
Rectangle -16777216 true false 105 240 195 255
Rectangle -7500403 true false 165 255 210 270
Rectangle -7500403 true false 90 255 135 270
Rectangle -7500403 true false 90 240 105 255
Rectangle -7500403 true false 195 240 210 255
Rectangle -16777216 true false 135 255 165 270
Rectangle -16777216 true false 90 270 135 285
Rectangle -16777216 true false 165 270 210 285
Rectangle -16777216 true false 210 240 225 270
Rectangle -16777216 true false 75 240 90 270

trainerfd
false
11
Rectangle -1 true false 135 135 165 165
Rectangle -16777216 true false 120 135 135 165
Rectangle -16777216 true false 165 135 180 165
Rectangle -1 true false 90 120 210 135
Rectangle -1 true false 90 135 120 165
Rectangle -1 true false 180 135 210 165
Rectangle -1 true false 105 165 195 180
Rectangle -1 true false 60 120 75 150
Rectangle -1 true false 75 135 90 150
Rectangle -1 true false 210 135 225 150
Rectangle -1 true false 225 120 240 150
Rectangle -16777216 true false 45 120 60 150
Rectangle -16777216 true false 60 150 90 180
Rectangle -16777216 true false 90 165 105 210
Rectangle -16777216 true false 105 180 210 210
Rectangle -16777216 true false 195 165 210 180
Rectangle -16777216 true false 210 150 240 180
Rectangle -16777216 true false 240 120 255 150
Rectangle -16777216 true false 90 120 90 135
Rectangle -16777216 true false 210 120 225 135
Rectangle -16777216 true false 60 105 240 120
Rectangle -16777216 true false 195 105 240 105
Rectangle -16777216 true false 195 90 240 105
Rectangle -16777216 true false 60 90 105 105
Rectangle -16777216 true false 75 60 90 90
Rectangle -16777216 true false 90 45 105 60
Rectangle -16777216 true false 210 60 225 90
Rectangle -16777216 true false 195 45 210 60
Rectangle -16777216 true false 105 30 195 45
Rectangle -7500403 true false 105 45 135 105
Rectangle -7500403 true false 90 60 105 90
Rectangle -7500403 true false 165 45 195 105
Rectangle -7500403 true false 135 45 165 90
Rectangle -7500403 true false 195 60 210 90
Rectangle -1 true false 135 90 165 105
Rectangle -1 true false 210 180 240 210
Rectangle -1 true false 60 180 90 210
Rectangle -16777216 true false 45 180 60 210
Rectangle -16777216 true false 60 210 105 225
Rectangle -16777216 true false 240 180 255 210
Rectangle -16777216 true false 195 210 240 225
Rectangle -7500403 true false 105 210 135 225
Rectangle -7500403 true false 165 210 195 225
Rectangle -7500403 true false 135 225 165 240
Rectangle -7500403 true false 90 240 135 255
Rectangle -7500403 true false 90 225 105 240
Rectangle -7500403 true false 165 240 210 255
Rectangle -7500403 true false 195 225 210 240
Rectangle -16777216 true false 75 225 90 255
Rectangle -16777216 true false 90 255 135 270
Rectangle -16777216 true false 135 240 165 255
Rectangle -16777216 true false 105 225 135 240
Rectangle -16777216 true false 135 210 165 225
Rectangle -16777216 true false 165 225 195 240
Rectangle -16777216 true false 165 255 210 270
Rectangle -16777216 true false 210 225 225 255
Rectangle -16777216 true false 75 120 90 135

trainerleft
false
6
Rectangle -7500403 true false 90 105 150 120
Rectangle -1 true false 60 90 120 105
Rectangle -1 true false 90 75 105 90
Rectangle -7500403 true false 120 45 135 105
Rectangle -7500403 true false 105 45 120 90
Rectangle -7500403 true false 90 60 105 75
Rectangle -7500403 true false 135 75 195 90
Rectangle -7500403 true false 135 60 210 75
Rectangle -7500403 true false 135 45 195 60
Rectangle -16777216 true false 105 120 120 150
Rectangle -1 true false 90 120 105 165
Rectangle -1 true false 120 120 150 180
Rectangle -1 true false 105 150 120 180
Rectangle -16777216 true false 165 90 165 135
Rectangle -16777216 true false 150 90 165 135
Rectangle -16777216 true false 135 90 150 105
Rectangle -16777216 true false 195 75 240 90
Rectangle -16777216 true false 210 60 225 75
Rectangle -16777216 true false 195 45 210 60
Rectangle -16777216 true false 105 30 195 45
Rectangle -16777216 true false 90 45 105 60
Rectangle -16777216 true false 60 75 90 90
Rectangle -16777216 true false 75 60 90 75
Rectangle -16777216 true false 45 90 60 105
Rectangle -16777216 true false 60 105 90 120
Rectangle -16777216 true false 75 120 90 165
Rectangle -16777216 true false 90 165 105 180
Rectangle -16777216 true false 105 180 180 195
Rectangle -16777216 true false 165 165 195 180
Rectangle -1 true false 165 120 195 165
Rectangle -1 true false 150 135 165 165
Rectangle -1 true false 150 165 165 180
Rectangle -16777216 true false 165 90 240 120
Rectangle -16777216 true false 195 120 225 150
Rectangle -16777216 true false 195 150 210 165
Rectangle -7500403 true false 195 165 210 225
Rectangle -7500403 true false 180 180 195 195
Rectangle -16777216 true false 210 165 225 225
Rectangle -16777216 true false 180 195 195 255
Rectangle -16777216 true false 195 225 210 240
Rectangle -16777216 true false 150 240 180 255
Rectangle -1 true false 120 255 180 270
Rectangle -1 true false 120 240 150 255
Rectangle -1 true false 150 210 180 240
Rectangle -16777216 true false 120 210 150 240
Rectangle -16777216 true false 120 195 180 210
Rectangle -16777216 true false 105 240 120 270
Rectangle -16777216 true false 120 270 180 285
Rectangle -16777216 true false 180 255 195 270

trainerright
false
4
Rectangle -7500403 true false 150 105 210 120
Rectangle -1 true false 180 90 240 105
Rectangle -1 true false 195 75 210 90
Rectangle -7500403 true false 165 45 180 105
Rectangle -7500403 true false 180 45 195 90
Rectangle -7500403 true false 195 60 210 75
Rectangle -7500403 true false 105 75 165 90
Rectangle -7500403 true false 90 60 165 75
Rectangle -7500403 true false 105 45 165 60
Rectangle -16777216 true false 180 120 195 150
Rectangle -1 true false 195 120 210 165
Rectangle -1 true false 150 120 180 180
Rectangle -1 true false 180 150 195 180
Rectangle -16777216 true false 135 90 135 135
Rectangle -16777216 true false 135 90 150 135
Rectangle -16777216 true false 150 90 165 105
Rectangle -16777216 true false 60 75 105 90
Rectangle -16777216 true false 75 60 90 75
Rectangle -16777216 true false 90 45 105 60
Rectangle -16777216 true false 105 30 195 45
Rectangle -16777216 true false 195 45 210 60
Rectangle -16777216 true false 210 75 240 90
Rectangle -16777216 true false 210 60 225 75
Rectangle -16777216 true false 240 90 255 105
Rectangle -16777216 true false 210 105 240 120
Rectangle -16777216 true false 210 120 225 165
Rectangle -16777216 true false 195 165 210 180
Rectangle -16777216 true false 120 180 195 195
Rectangle -16777216 true false 105 165 135 180
Rectangle -1 true false 105 120 135 165
Rectangle -1 true false 135 135 150 165
Rectangle -1 true false 135 165 150 180
Rectangle -16777216 true false 60 90 135 120
Rectangle -16777216 true false 75 120 105 150
Rectangle -16777216 true false 90 150 105 165
Rectangle -7500403 true false 90 165 105 225
Rectangle -16777216 true false 75 165 90 225
Rectangle -16777216 true false 105 195 120 255
Rectangle -16777216 true false 90 225 105 240
Rectangle -16777216 true false 120 240 150 255
Rectangle -1 true false 120 255 180 270
Rectangle -1 true false 150 240 180 255
Rectangle -1 true false 120 210 150 240
Rectangle -16777216 true false 150 210 180 240
Rectangle -16777216 true false 120 195 180 210
Rectangle -16777216 true false 180 240 195 270
Rectangle -16777216 true false 120 270 180 285
Rectangle -16777216 true false 105 255 120 270
Rectangle -7500403 true false 105 180 120 195

tree
false
0
Circle -10899396 true false 103 3 94
Rectangle -6459832 true false 120 180 180 285
Circle -10899396 true false 35 51 108
Circle -10899396 true false 131 41 127
Circle -10899396 true false 30 105 120
Circle -10899396 true false 134 89 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.0.2
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
