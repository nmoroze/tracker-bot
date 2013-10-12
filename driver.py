from os import system as sys

def forward():
	sys("sudo aplay forward.wav")

def backward():
	sys("sudo aplay backward.wav")

def right():
	sys("sudo aplay right.wav")

def left():
	sys("sudo aplay left.wav")

def init():
	sys("sudo amixer cset numid=3 1")




