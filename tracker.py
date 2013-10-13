from SimpleCV import *

class Tracker(object):
	"""Tracks color blobs"""
	def __init__(self, redLower, redUpper, greenLower, greenUpper, blueLower, blueUpper, width=30, height=20):
		super(Tracker, self).__init__()
		self.redLower = redLower
		self.redUpper = redUpper
		self.greenLower = greenLower
		self.greenUpper = greenUpper
		self.blueLower = blueLower
		self.blueUpper = blueUpper

		self.cam = Camera()
		self.display = Display((360, 240))
		self.highlight = (255, 204, 0)
		
		self.width = width
		self.height = height

		self.coordinates = []

	def update(self):
		self.coordinates = []
		img = self.cam.getImage().resize(self.width, self.height)
		for x in xrange(0, self.width):
			for y in xrange(0, self.height):
				red, green, blue = img[x, y]
				if(red>self.redLower and red<self.redUpper and 
						green>self.greenLower and green<self.greenUpper and
						blue>self.blueLower and blue<self.blueUpper):
					img[x, y] = self.highlight
				
					self.coordinates.append((x,y))

		pt = self.averagePoints()
		
		img[pt[0], pt[1]] = (255, 0, 0)
		img.save(self.display)
		

	def getDistance(self):
		return len(self.coordinates)

	def getErrorX(self):
		return self.averagePoints()[0] - self.width/2

	def getErrorY(self):
		return self.averagePoints()[1] - self.width/2

	def averagePoints(self):
		xSum = 0
		ySum = 0

		for x, y in self.coordinates:
			xSum += x
			ySum += y

		if len(self.coordinates)>0:
			return (xSum/len(self.coordinates), ySum/len(self.coordinates))
		else:
			return (self.width/2, self.height/2)
