#VidSmanger

Generates derivatives for every video in a folder.

1. `./bin/init.sh` (only needs to be run once. sets up folder structure and installs brew and ffmpeg)
* Add source videos to `source-to-encode/`
* Optionally add .srt subtitle files to the `subtitles` directory. The filenames must match, as in: `subtitles/<filename>.srt` and `source-to-encode/<filename>.vidformat`
* `./bin/encode.sh`

Encoded videos will save to `encoded/`. Source videos will be moved to `source-post-encode/` once their derivatives have been generated. Subtitle files will remain in the subtitles directory.

If you've already installed ffmpeg via brew and get codec errors, `brew uninstall ffmpeg` and `./bin/init.sh`.

##Output Format

VidSmanger outputs videos in the following format: `<original_filename>_<scaled_height>_<subtitles>.<file_type>`

##Subtitle Burn-In

To enable subtitling, run `encode.sh` with the `-s` flag as so: `./bin/encode.sh -s`.

If you provide a .srt file for a video, VidSmanger makes a _s.mp4 for every size where the subtitles will be burned-in. If you don't provide an .srt, VidSmanger copies the un-subtitled video to _s.mp4 for consistency. (this might not be the best thing long-term?).

See `bin/add-subtitle-options.py` for customization of subtitle options (font, position, etc). It currently uses the CooperHewitt font so you should [install that](http://uh8yh30l48rpize52xh0q1o6i.wpengine.netdna-cdn.com/wp-content/uploads/fonts/CooperHewitt-OTF-public.zip) if you don't have it already.
