@echo off
cd /D "%~dp0"
mkdir "wavOut"

for /r %%f in (*.raw) do (
	ffmpeg.exe -f s16le -ar 22050 -ac 2 -i "%%~nf.raw" "wavOut\%%~nf.wav"
)
pause