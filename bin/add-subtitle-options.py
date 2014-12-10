#!/usr/bin/env python
import sys
from tempfile import mkstemp
from shutil import move
from os import remove, close

if __name__ == '__main__':
	file_path = sys.argv[1]

	#Create temp file
	fh, abs_path = mkstemp()
	new_file = open(abs_path,'w')
	old_file = open(file_path)
	
	for line in old_file:
		if line == "Style: Default,Arial,16,&Hffffff,&Hffffff,&H0,&H0,0,0,0,1,1,0,2,10,10,10,0,0\r\n":
			# Change subtitle font here
			# Format: Name, Fontname, Fontsize, PrimaryColour, SecondaryColour, OutlineColour, BackColour, Bold, Italic, Underline, BorderStyle, Outline, Shadow, Alignment, MarginL, MarginR, MarginV, AlphaLevel, Encoding
			"Style: Default,Arial,16,&Hffffff,&Hffffff,&H0,&H0,0,0,0,1,1,0,2,10,10,10,0,0\r\n")
		elif line == '[Script Info]\r\n':
			# Set resolution
			new_file.write('[Script Info]\r\n')
			new_file.write('PlayResX: %s\r\n' % sys.argv[2])
			new_file.write('PlayResY: %s\r\n' % sys.argv[3])
		else:
			new_file.write(line)
	
	#close temp file
	new_file.close()
	close(fh)
	old_file.close()
	
	#Remove original file
	remove(file_path)
	
	#Move new file
	move(abs_path, file_path)