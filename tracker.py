from imgproc import *

class Tracker(object):
	"""Tracks color blobs"""
	def __init__(self, redLower, redUpper, greenLower, greenUpper, blueLower, blueUpper, width=360, height=240):
		super(ClassName, self).__init__()
		self.redLower = redLower
		self.redUpper = redUpper
		self.greenLower = greenLower
		self.greenUpper = greenUpper
		self.blueLower = blueLower
		self.blueUpper = blueUpper

		self.cam = Camera(width, height)
		self.view = Viewer(width, height, "Color tracking display")
		self.highlight = (255, 204, 0)

		self.coordinates = []

	def update(self):
		img = self.cam.grabImage()
		for x in range(0, img.width):
			for y in range(0, img.height):
				red, green, blue = img[x, y]
				if(red>self.redLower and red<self.redUpper and 
						green>self.greenLower and green<self.greenUpper and
						blue>self.blueLower and blue<self.blueUpper):
					img[x, y] = self.highlight
					self.coordinates.append((x,y))

		self.view.displayImage(img)

	def getDistance(self):
		return len(self.coordinates)

	def getErrorX(self):
		return averagePoints()[0] - self.width/2

	def getErrorY(self):
		return averagePoints()[1] - self.width/2

	def averagePoints(self):
		xSum = 0
		ySum = 0

		for x, y in self.coordinates:
			xSum += x
			ySum += y

		if len(self.coordinates)>0:
			return (xSum/len(self.coordinates), ySum/len(self.coordinates))
		else:
			return (-1, -1)