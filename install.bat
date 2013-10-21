REM If your Program Files directory is other than "C:\Program Files (x86)", apply this substitution everywhere in this file .

REM Delete any "larbac" directory in the Program Files
rd /s /q "C:\Program Files (x86)\larbac"
REM Create a "larbac" directory in the Program Files
md "C:\Program Files (x86)\larbac"

REM The next command looks for latex.exe in the Program Files directory and finds its absolute path. That information is then stored in a separate file (latex.txt) in the new "larbac" directory.
DIR "C:\Program Files (x86)\"latex.exe /B /P /S > "C:\Program Files (x86)\larbac\latex.txt"

REM The following commands do the same thing.
DIR "C:\Program Files (x86)\"makeindex.exe /B /P /S > "C:\Program Files (x86)\larbac\makeindex.txt"
DIR "C:\Program Files (x86)\"bibtex.exe /B /P /S > "C:\Program Files (x86)\larbac\bibtex.txt"
DIR "C:\Program Files (x86)\"dvips.exe /B /P /S > "C:\Program Files (x86)\larbac\dvips.txt"
DIR "C:\"ps2eps.pl /B /P /S > "C:\Program Files (x86)\larbac\ps2eps.txt"
DIR "C:\Program Files (x86)\"gswin32.exe /B /P /S > "C:\Program Files (x86)\larbac\gsview.txt"
DIR "C:\Program Files (x86)\"nconvert.exe /B /P /S > "C:\Program Files (x86)\larbac\nconvert.txt"
