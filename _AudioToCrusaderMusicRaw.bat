@echo off
cd /D "%~dp0"
mkdir "rawOut"

set /p audioFileExtension="File extension of audio files: "
for /r %%f in (*.%audioFileExtension%) do (
	ffmpeg.exe -i "%%~nf.%audioFileExtension%" -f s16le -c:a pcm_s16le -ar 22050 -ac 2 "rawOut\%%~nf.raw"
)
pause