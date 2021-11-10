for /f "delims=" %%a in ('dir/b *.txt') do (
for /f "tokens=1* delims=:" %%b in ('findstr /n .* "%%a"') do (
if "%%b"=="1" (echo %%a%%c>>"_%%a") else echo.%%c>>"_%%a"
)
del/q "%%a"
ren "_%%a" "%%a"
)
pause