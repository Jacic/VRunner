extends Node

var initted:bool = false
var bgmPlayPosition:float = 0	#used to pretend the BGM doesn't stop when reloading the tutorial/playscene
var activeLevel
var colors = [Color(1, 1, 1), Color(1, 0, 0), Color(0, 1, 0), Color(0, 0, 1),
	Color(1, 1, 0), Color(1, 0, 1), Color(0, 1, 1)]
var curColor:Color = Color(1, 1, 1)
var prevColor:Color = Color(1, 1, 1)
var colorTween = Tween.new()
var killzoneTween = Tween.new()

func initColors():
	if !initted:
		curColor = colors[0]
		colorTween.interpolate_property(self, "curColor", curColor, getRandomColor(), 2, Tween.TRANS_LINEAR, Tween.EASE_IN)
		colorTween.connect("tween_all_completed", self, "tweenEnd")
		add_child(colorTween)
		colorTween.start()
		killzoneTween.interpolate_property(self, "prevColor", prevColor, curColor, 2, Tween.TRANS_LINEAR, Tween.EASE_IN)
		killzoneTween.connect("tween_all_completed", self, "killzoneTweenEnd")
		add_child(killzoneTween)
		killzoneTween.start()
		initted = true

func tweenEnd():
	colorTween.interpolate_property(self, "curColor", curColor, getRandomColor(), 2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	colorTween.start()

func killzoneTweenEnd():
	killzoneTween.interpolate_property(self, "prevColor", prevColor, curColor, 2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	killzoneTween.start()

func getRandomColor():
	colors.erase(curColor)
	var pos = randi() % colors.size()
	var col = colors[pos]
	colors.append(curColor)
	
	return col
