#!/bin/sh

# brew install ffmpeg --with-vpx --with-vorbis --with-libvorbis --with-vpx --with-vorbis --with-theora --with-libogg --with-libvorbis --with-gpl --with-version3 --with-nonfree --with-postproc --with-libaacplus --with-libass --with-libcelt --with-libfaac --with-libfdk-aac --with-libfreetype --with-libmp3lame --with-libopencore-amrnb --with-libopencore-amrwb --with-libopenjpeg --with-openssl --with-libopus --with-libschroedinger --with-libspeex --with-libtheora --with-libvo-aacenc --with-libvorbis --with-libvpx --with-libx264 --with-libxvid

TO_ENCODE='./source-to-encode/*'

SUBTITLE_DIR='./subtitles/'
POST_ENCODE_DIR='./source-post-encode/'
ENCODED_DIR='./encoded/'

for f in $TO_ENCODE
do

	base_file=$(basename "$f")
	base_filename="${base_file%.*}"

	echo "begin encoding $base_file"
	
	# echo "making ogg..."
	# ffmpeg -i $f -acodec libvorbis -ac 2 -ab 96k -ar 44100 -vb 6000k -vf scale=-1:1080 "${ENCODED_DIR}${base_filename}.ogv"

	# echo "making webm..."
	# ffmpeg -i $f -acodec libvorbis -ac 2 -ab 96k -ar 44100 -vb 6000k -vf scale=-1:1080 "${ENCODED_DIR}${base_filename}.webm"
	
	# echo "making 1080 mp4..."
	# ffmpeg -y -i $f -codec:v libx264 -preset slow -b:v 6000k -vf scale=-1:1080 -threads 0 -pass 1 -an -f mp4 /dev/null
	# ffmpeg -y -i $f -codec:v libx264 -preset slow -b:v 6000k -vf scale=-1:1080 -threads 0 -pass 2 -codec:a libfaac -b:a 128k -f mp4 "${ENCODED_DIR}${base_filename}_1080.mp4"

	# echo "making 720 mp4..."
	# ffmpeg -y -i $f -codec:v libx264 -preset slow -b:v 6000k -vf scale=-1:720 -threads 0 -pass 1 -an -f mp4 /dev/null
	# ffmpeg -y -i $f -codec:v libx264 -preset slow -b:v 6000k -vf scale=-1:720 -threads 0 -pass 2 -codec:a libfaac -b:a 128k -f mp4 "${ENCODED_DIR}${base_filename}_720.mp4"

	echo "making 720 mp4 subtitled..."
	ffmpeg -y -i $f -codec:v libx264 -preset slow -b:v 6000k -vf scale=-1:720 subtitles=${SUBTITLE_DIR}${base_filename}.srt -threads 0 -pass 1 -an -f mp4 /dev/null
	ffmpeg -y -i $f -codec:v libx264 -preset slow -b:v 6000k -vf scale=-1:720 subtitles=${SUBTITLE_DIR}${base_filename}.srt -threads 0 -pass 2 -codec:a libfaac -b:a 128k -f mp4 "${ENCODED_DIR}${base_filename}_720_s.mp4"

	echo "finished encoding $base_file"
	mv $f "${POST_ENCODE_DIR}${base_file}"
done