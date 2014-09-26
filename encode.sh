#!/bin/sh

# brew install ffmpeg --with-vpx --with-vorbis --with-libvorbis --with-vpx --with-vorbis --with-theora --with-libogg --with-libvorbis --with-gpl --with-version3 --with-nonfree --with-postproc --with-libaacplus --with-libass --with-libcelt --with-libfaac --with-libfdk-aac --with-libfreetype --with-libmp3lame --with-libopencore-amrnb --with-libopencore-amrwb --with-libopenjpeg --with-openssl --with-libopus --with-libschroedinger --with-libspeex --with-libtheora --with-libvo-aacenc --with-libvorbis --with-libvpx --with-libx264 --with-libxvid

TO_ENCODE='./source-to-encode/*'

SUBTITLE_DIR='./subtitles/'
POST_ENCODE_DIR='./source-post-encode/'
ENCODED_DIR='./encoded/'

WIDTH_L=1920
HEIGHT_L=1080
FILTER_L="-filter:v \"scale=iw*min(${WIDTH_L}/iw\,${HEIGHT_L}/ih):ih*min(${WIDTH_L}/iw\,${HEIGHT_L}/ih), pad=${WIDTH_L}:${HEIGHT_L}:(${WIDTH_L}-iw*min(${WIDTH_L}/iw\,${HEIGHT_L}/ih))/2:(${HEIGHT_L}-ih*min(${WIDHT_L}/iw\,${HEIGHT_L}/ih))/2\""

WIDTH_M=1280
HEIGHT_M=720
FILTER_L="-filter:v \"scale=iw*min(${WIDTH_M}/iw\,${HEIGHT_M}/ih):ih*min(${WIDTH_M}/iw\,${HEIGHT_M}/ih), pad=${WIDTH_M}:${HEIGHT_M}:(${WIDTH_M}-iw*min(${WIDTH_M}/iw\,${HEIGHT_M}/ih))/2:(${HEIGHT_M}-ih*min(${WIDHT_M}/iw\,${HEIGHT_M}/ih))/2\""

for f in $TO_ENCODE
do

	base_file=$(basename "$f")
	base_filename="${base_file%.*}"

	echo "begin encoding $base_file"
	
	# echo "making ogg..."
	# ffmpeg -i $f -acodec libvorbis -ac 2 -ab 96k -ar 44100 -vb 6000k $FILTER_L "${ENCODED_DIR}${base_filename}.ogv"

	# echo "making webm..."
	# ffmpeg -i $f -acodec libvorbis -ac 2 -ab 96k -ar 44100 -vb 6000k $FILTER_L "${ENCODED_DIR}${base_filename}.webm"
	
	echo "making 1080 mp4..."
	ffmpeg -y -i $f -codec:v libx264 -preset slow -b:v 6000k $FILTER_L -threads 0 -pass 1 -an -f mp4 /dev/null
	ffmpeg -y -i $f -codec:v libx264 -preset slow -b:v 6000k $FILTER_L -threads 0 -pass 2 -codec:a libfaac -b:a 128k -f mp4 "${ENCODED_DIR}${base_filename}_1080.mp4"	

	echo "making 720 mp4..."
	ffmpeg -y -i $f -codec:v libx264 -preset slow -b:v 6000k $FILTER_M -threads 0 -pass 1 -an -f mp4 /dev/null
	ffmpeg -y -i $f -codec:v libx264 -preset slow -b:v 6000k $FILTER_M -threads 0 -pass 2 -codec:a libfaac -b:a 128k -f mp4 "${ENCODED_DIR}${base_filename}_720.mp4"

	# subtitles
	if [ ! -f ${SUBTITLE_DIR}${base_filename}.srt ]; then
		# no subtitle file. duplicate unsubbed file and add _s for consistency
		cp "${ENCODED_DIR}${base_filename}_720.mp4" "${ENCODED_DIR}${base_filename}_720_s.mp4"
		cp "${ENCODED_DIR}${base_filename}_1080.mp4" "${ENCODED_DIR}${base_filename}_1080_s.mp4"
	else
		# subtitle file exists. burn in subs.
		echo "making 1080 mp4 subtitled..."
		ffmpeg -y -i $f -codec:v libx264 -preset slow -b:v 6000k $FILTER_L -vf subtitles=${SUBTITLE_DIR}${base_filename}.srt -threads 0 -pass 1 -an -f mp4 /dev/null
		ffmpeg -y -i $f -codec:v libx264 -preset slow -b:v 6000k $FILTER_L -vf subtitles=${SUBTITLE_DIR}${base_filename}.srt -threads 0 -pass 2 -codec:a libfaac -b:a 128k -f mp4 "${ENCODED_DIR}${base_filename}_1080_s.mp4"

		echo "making 720 mp4 subtitled..."
		ffmpeg -y -i $f -codec:v libx264 -preset slow -b:v 6000k $FILTER_M -vf subtitles=${SUBTITLE_DIR}${base_filename}.srt -threads 0 -pass 1 -an -f mp4 /dev/null
		ffmpeg -y -i $f -codec:v libx264 -preset slow -b:v 6000k $FILTER_M -vf subtitles=${SUBTITLE_DIR}${base_filename}.srt -threads 0 -pass 2 -codec:a libfaac -b:a 128k -f mp4 "${ENCODED_DIR}${base_filename}_720_s.mp4"
	fi

	echo "finished encoding $base_file"
	mv $f "${POST_ENCODE_DIR}${base_file}"
done