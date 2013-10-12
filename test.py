from tracker import *

t = Tracker(100, 255, 20, 255, 0, 100, 360, 240)

while t.display.isNotDone():
	if t.display.mouseLeft:
		break
	t.update()
	
	
