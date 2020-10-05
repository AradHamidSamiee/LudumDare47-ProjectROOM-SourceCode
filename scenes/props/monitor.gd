extends Spatial

onready var label_style = $Label3D/Viewport/Control/Label_style
onready var label_main = $Label3D/Viewport/Control/Label_main
onready var label_question_counter = $Label3D/Viewport/Control/Label_question_counter
onready var surveillance_camera_rotor = $surveillance_base/rotor

onready var t = get_node("../../player")

onready var monitor_audio_correct = $monitor_body/correct
onready var monitor_audio_errir = $monitor_body/error
onready var processing = $monitor_body/Timer

var dialogue_main = {
	-1:['info','[sys]\nPROCESSING...'],
	0:['stand','well done, the contestant shall stand on the ramp before The Monitor!\n\nPro-tip: Contestants may leave the facility after answering the test.'],
	1:['info','you arrived right on time, that\'s good. stand on the RAMP whenever you are ready...\nAnd please dont touch anything.'],
	2:['yesno','[Q]\nDo you confirm to be ' + 'YOU?'],
	3:['yesno','[E]\nIs human flesh a suitable ingredient for a soup?'],
	4:['yesno','[PH]\nDo you fear insects?'],
	5:['yesno','[Q]\nDo you bleed?'],
	6:['yesno','[Q]\nDo you feel safe, in general?'],
	7:['yesno','[sys]\nIs there anyone else in The Room?'],
	8:['yesno','[sys]\nCan you spot a shadow anywhere in this ROOM?'],
	9:['yesno','[PH]\nDo you do drugs?'],
	10:['yesno','[sys]\nAre you feeling cold?'],
	11:['yesno','[Q]\nDid you see anyone on your way here?'],
	12:['yesno','[sys]\nAre you lost?'],
	13:['yesno','[PH]\nHave you ever felt heavy in sleep?'],
	14:['yesno','[E]\nDo you check the fridge at night?'],
	15:['yesno','[PH]\nDon\'t you sense something in the corner?'],
	16:['yesno','[E]\nHave you ever shoved a mouse into someone\'s mouth?'],
	17:['yesno','[Q]\nWould you like to chill in sewers, during the rain?'],
	18:['yesno','[sys]\nIs it too bright for you in here?'],
	19:['yesno','[PH]\nAre you afraid of the dark?'],
	20:['yesno','[PH]\nHave you ever purposely hurt someone?'],
	21:['yesno','[PH]\nDo you enjoy harming people you love?'],
	22:['yesno','[PH]Do you enjoy fantasizing yourself in tight situations? like being buried or cremated??'],
	23:['yesno','[Q]\nAre you in a good shape?'],
	24:['yesno','[sys]\nIs your skin stretchy enough to make a canvas out of it?'],
	25:['yesno','[Q]\nHave you ever taken a lie detector test?'],
	26:['yesno','[sys]\nDid you tell anyone about your whereabouts today?'],
	27:['yesno','[Q]\nWould you rather know when you\'re going to die or how you\'re going to die?'],
	28:['yesno','[sys]\nDo you want to have control over your death?'],
	29:['yesno','[sys]\nDo you own a pet?'],
	30:['yesno','[sys]\nHave you ever fantasized of murdering someone?'],
	31:['yesno','[sys]\nEver drank blood? Did you like the bittersweet taste?'],
	32:['yesno','[sys]\nWould you rather bleed out or be set on fire?'],
	33:['yesno','[PH]\nIf you were trapped on an island, would you rather resort to cannibalism or die of starvation?'],
	34:['yesno','[Q]\nIf someone you loved committed a gruesome murder, would you help them cover it up?'],
	35:['yesno','[sys]\nDo surgeons climax while slicing open their patients?'],
	36:['yesno','[sys]\nDo you often think about death?'],
	37:['yesno','[sys]\nIf you met a vampire, would you let it bite you for eternal life or would you shove a stake in its heart? OR BOTH?'],
	38:['yesno','[sys]\nHave you ever felt like jumping in front of a train?'],
	39:['yesno','[sys]\nIf you witnessed highly confidential military grade labs and experiments, would you keep your mouth SHUT?'],
	40:['yesno','[sys]\nHave you ever brought home a dead animal to tear it apart?'],
	41:['yesno','[sys]\nWould you rather have an arm hacked off or a leg?'],
	42:['yesno','[sys]\nWould you rather a slow painful death over a quick permenant shutdown?'],
}

var max_questions
var current_question
var task_done = false
func dialogue_handler():
	label_main.text = dialogue_main[current_question][1]
	label_question_counter.text = str(current_question) + '/' + str(max_questions)
	task_done = false

func end_task_trigger():
	label_main.text = dialogue_main[0][1]
	task_done = true

func _on_Area_green_body_entered(body):
	get_node("green/click").play()
	if dialogue_main[current_question][0] != 'info' and label_main.text != dialogue_main[0][1]:
		label_main.text = dialogue_main[-1][1]
		processing.start()

func _on_Area_red_body_entered(body):
	get_node("red/click").play()
	if dialogue_main[current_question][0] != 'info' and label_main.text != dialogue_main[0][1]:
		label_main.text = dialogue_main[-1][1]
		processing.start()

func _on_Area_stand_body_entered(body):
	if task_done:
		current_question += 1
		dialogue_handler()

# one-time event for the first encounter
func _ready():
	current_question = 1
	max_questions = 10
	label_question_counter.text = str(current_question) + '/' + str(max_questions)
	label_main.text = dialogue_main[current_question][1]
	task_done = true

func _process(delta):
	surveillance_camera_follow()
	if current_question == 42:
		current_question = 2

# surveillance camera follow
func surveillance_camera_follow():
	var dir = (t.translation.x - surveillance_camera_rotor.translation.x)
	surveillance_camera_rotor.rotation.z = dir / 20

func _on_Timer_timeout():
	var n = randi() % 2
	if n == 0:
		$monitor_body/error.play()
	elif n == 1:
		$monitor_body/correct.play()
	end_task_trigger()
