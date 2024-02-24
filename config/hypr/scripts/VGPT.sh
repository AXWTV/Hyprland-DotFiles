
#!/bin/sh
# still in progress...
#txt="$(vtt)"
#
#if [[ $txt == *"system"* ]]; then
#  tgpt -s "$txt" | \
#  piper --model  ~/.local/share/vtt/english/en_US-libritts_r-medium.onnx --speaker 0 --output-raw  | \
#  aplay -r 22050 -f S16_LE -t raw -
#else
#  tgpt -q "answer under 100 words, $txt" | \
#  piper --model  ~/.local/share/vtt/english/en_US-libritts_r-medium.onnx --speaker 0 --output-raw  | \
#  aplay -r 22050 -f S16_LE -t raw -
#fi


killall aplay
# Define variables for file paths
AUDIO_FILE=~/.cache/audio.wav
TRANSCRIPT_FILE=~/.cache/transcript.txt
MODEL_PATH=~/.local/share/vtt/english/vosk-model-small-en-us-0.15

# Record audio for 4 seconds
ffmpeg -y -f alsa -i default -acodec pcm_s16le -ac 1 -ar 44100 -t 4 $AUDIO_FILE >/dev/null 2>&1

# Transcribe the audio file
vosk-transcriber -m $MODEL_PATH -i $AUDIO_FILE -o $TRANSCRIPT_FILE >/dev/null 2>&1


txt=$(cat $TRANSCRIPT_FILE)
tgpt -q "answer under 100 words, $txt" | \
piper --model ~/.local/share/vtt/english/en_US-libritts_r-medium.onnx --speaker 0 --output-raw | \
aplay -r 22050 -f S16_LE -t raw -

