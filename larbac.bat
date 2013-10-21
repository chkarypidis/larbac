REM larbac - A LaTeX{}-related batch converter
REM Author: Charalampos KARYPIDIS
REM v1.0  - 20131021
REM ch.karypidis@gmail.com
REM http://addictiveknowledge.blogspot.com/

@echo off
cls
title larbac - A LaTeX{}-related batch converter

REM We create variables (latex, makeindex, bibtex, ...) whose value is extracted from the corresponding .txt files. The latter are created during the installation process.
set /p latex= < "C:\Program Files (x86)\larbac\latex.txt"
set /p makeindex= < "C:\Program Files (x86)\larbac\makeindex.txt"
set /p bibtex= < "C:\Program Files (x86)\larbac\bibtex.txt"
set /p dvips= < "C:\Program Files (x86)\larbac\dvips.txt"
set /p ps2eps= < "C:\Program Files (x86)\larbac\ps2eps.txt"
set /p gswin32= < "C:\Program Files (x86)\larbac\gsview.txt"
set /p nconvert= < "C:\Program Files (x86)\larbac\nconvert.txt"

REM The five choices for conversion.
:start
ECHO.
echo 1 - tex2dvi
echo 2 - dvi2ps
echo 3 - tex2ps
echo 4 - ps2eps
echo 5 - tex2jpg
ECHO.

set /p choice=What do you want to convert? 

IF not '%choice%'=='' set choice=%choice:~0,1%
IF '%choice%' == '1' GOTO tex2dvi
IF '%choice%' == '2' GOTO div2ps
IF '%choice%' == '3' GOTO tex2ps
IF '%choice%' == '4' GOTO ps2eps
IF '%choice%' == '5' GOTO tex2jpg
ECHO %choice% is not a valid option. Choose from 1 to 5.
ECHO.
goto start


:tex2dvi
for /f "tokens=*" %%I in ('dir /b *.tex') do (
call "%latex%" "%%~I"
call "%bibtex%" "%CD%\%%~I"
call "%makeindex%" "%CD%\%%~I.idx"
call "%latex%" "%%~I"
call "%latex%" "%%~I"
)
GOTO cleanup


:div2ps
for /f "tokens=*" %%I in ('dir /b *.dvi') do (
call "%dvips%" "%%~I"
)
GOTO cleanup



:tex2ps
for /f "tokens=*" %%I in ('dir /b *.tex') do (
call "%latex%" "%%~I"
)
for /f "tokens=*" %%I in ('dir /b *.dvi') do (
call "%dvips%" "%%~I"
)
del "%CD%\*.dvi"
GOTO cleanup



:ps2eps 
for /f "tokens=*" %%I in ('dir /b *.ps') do (
call perl "%ps2eps%" -q -n -H -l -f "%%~I"
)
GOTO exit


:tex2jpg
for /f "tokens=*" %%I in ('dir /b *.tex') do (
call "%latex%" "%%~I"
)
for /f "tokens=*" %%I in ('dir /b *.dvi') do (
call "%dvips%" "%%~I"
)
for /f "tokens=*" %%I in ('dir /b *.ps') do (
call "%gswin32%" -dBATCH -dNOPAUSE -sDEVICE=jpeg -sOutputFile="%CD%\%%~I.jpg" -r600 "%%~I"
)
del "%CD%\*.dvi"
del "%CD%\*.ps"

REM If the user's choice is tex2jpg, this additional dialogue is shown, asking whether an automatic cropping is needed.
ECHO.
:autocropConfirmation
set /p autoformat=Would you like for the jpg files to become cropped automatically? (y/n)
IF not '%autoformat%'=='' set choice=%autoformat:~0,1%
IF '%autoformat%' == 'y' GOTO autocrop
IF '%autoformat%' == 'n' GOTO cleanup
ECHO %choice% is not a valid option. Choise between 'y' or 'n'.
ECHO.
goto autocropConfirmation

:autocrop
for /f "tokens=*" %%I in ('dir /b *.jpg') do (
call "%nconvert%" -quiet -npcd 1 -ctype grey -q 100 -corder inter -out jpeg -D -autocrop 0 255 255 255 "%%~I"
)
GOTO cleanup

REM After the conversion, a little bit of a clean-up to get rid of the auxiliary files. %CD% = current directory
:cleanup
del "%CD%\*.aux"
del "%CD%\*.blg"
del "%CD%\*.bbl"
del "%CD%\*.bib.bak"
del "%CD%\*.idx"
del "%CD%\*.ilg"
del "%CD%\*.ind"
del "%CD%\*.lof"
del "%CD%\*.log"
del "%CD%\*.lot"
del "%CD%\*.out"
del "%CD%\*.toc"


:exit
