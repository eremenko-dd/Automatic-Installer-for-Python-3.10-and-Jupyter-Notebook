mkdir C:\Dev
mkdir C:\Dev\Jupyter
mkdir C:\Dev\Jupyter\dist
mkdir C:\Dev\Jupyter\dist\apps
mkdir C:\Dev\Jupyter\dist\conf
mkdir C:\Dev\Jupyter\dist\conf\backup
mkdir C:\Dev\Jupyter\dist\conf\ipython
mkdir C:\Dev\Jupyter\dist\conf\jupyter
mkdir C:\Dev\Jupyter\dist\conf\matplotlib
mkdir C:\Dev\Jupyter\dist\fonts
mkdir C:\Dev\Jupyter\projects
mkdir C:\Dev\Miniconda3
mkdir C:\Dev\Projects

@echo off
(
  echo @echo off
  echo set conf_path=%%~dp0\conf
  echo set JUPYTER_CONFIG_DIR=%%conf_path%%\jupyter
  echo set JUPYTER_DATA_DIR=%%conf_path%%\jupyter\data
  echo set JUPYTER_RUNTIME_DIR=%%conf_path%%\jupyter\data\runtime
  echo set IPYTHONDIR=%%conf_path%%\ipython
  echo set MPLCONFIGDIR=%%conf_path%%\matplotlib
  echo REM Matplotlib search FFMPEG in PATH variable only!
  echo set PATH=%%~dp0\apps\ffmpeg\bin;%%PATH%%
) > C:\Dev\Jupyter\dist\setenv.bat

@echo off
(
  echo @echo off
  echo call %%~dp0\setenv.bat
  echo call %%~dp0\pyenv3.7-win64\Scripts\jupyter-notebook.exe --notebook-dir=%%1
) > C:\Dev\Jupyter\dist\run_jupyter_notebook.bat

@echo off
(
  echo @echo off
  echo call %%~dp0\setenv.bat
  echo call %%~dp0\pyenv3.7-win64\Scripts\jupyter-lab.exe --notebook-dir=%%1
) > C:\Dev\Jupyter\dist\run_jupyter_lab.bat 

@echo off
(
  echo @echo off
  echo REM Enable extension in Jupyter Notebook.
  echo REM Example:
  echo REM enable_extension.bat widgetsnbextension
  echo call %%~dp0\setenv.bat
  echo call %%~dp0\pyenv3.7-win64\Scripts\jupyter-nbextension.exe enable %%1
)  > C:\Dev\Jupyter\dist\enable_extension.bat

@echo off
setlocal
REM Создание ярлыка для файла run_jupyter_notebook.bat
set "source=C:\Dev\Jupyter\dist\run_jupyter_notebook.bat"
set "destination=%userprofile%\Desktop\run_jupyter.lnk"
echo Creating shortcut...
powershell -Command "$WshShell = New-Object -ComObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%destination%'); $Shortcut.TargetPath = '%source%'; $Shortcut.WorkingDirectory = 'C:\Dev\Projects'; $Shortcut.Save()"
echo Shortcut created successfully.
endlocal

:: Function for Miniconda3 installation
@echo off
setlocal
set "INSTALLER_PATH=%TEMP%\Miniconda_Install.exe"
set "INSTALL_DIR=C:\Dev\Miniconda3"
set "INSTALL_TYPE=JustMe"
set "DOWNLOAD_URL=https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86_64.exe"
echo Downloading Miniconda3 installer...
powershell -Command "(New-Object Net.WebClient).DownloadFile('%DOWNLOAD_URL%', '%INSTALLER_PATH%')" >nul 2>nul
echo Installing Miniconda3...
start /wait "" "%INSTALLER_PATH%" /InstallationType=%INSTALL_TYPE% /S /D=%INSTALL_DIR%
del "%INSTALLER_PATH%"
echo Miniconda3 has been installed to %INSTALL_DIR%
endlocal

:: INSTALL Python
setlocal
@echo off
echo Installing Python 3 and pip...
set PYTHON_VERSION=3.10.0
set PYTHON_URL=https://www.python.org/ftp/python/%PYTHON_VERSION%/python-%PYTHON_VERSION%-amd64.exe
set PIP_URL=https://bootstrap.pypa.io/get-pip.py
set PYTHON_INSTALLER=python-%PYTHON_VERSION%-amd64.exe
set PIP_INSTALLER=get-pip.py
echo Downloading Python 3 installer from %PYTHON_URL%...
curl -L -o %PYTHON_INSTALLER% %PYTHON_URL%
echo Installing Python 3...
start /wait %PYTHON_INSTALLER% /quiet InstallAllUsers=1 PrependPath=1 Include_test=0
echo Installing pip...
curl -L -o %PIP_INSTALLER% %PIP_URL%
REM python %PIP_INSTALLER%
echo Cleaning up...
del %PYTHON_INSTALLER%
del %PIP_INSTALLER%
endlocal
echo Installing Python 3 and pip compleate.

:: Function for Python environment setup
echo Installing install numpy scipy matplotlib jupyter jupyterlab...
call C:\Dev\Miniconda3\Scripts\conda.exe create -p C:\Dev\Jupyter\dist\pyenv3.7-win64 --copy --yes python=3 conda
call C:\Dev\Jupyter\dist\pyenv3.7-win64\Scripts\activate
call pip --no-cache-dir install numpy scipy matplotlib jupyter jupyterlab
call conda.bat deactivate
echo Installing install numpy scipy matplotlib jupyter jupyterlab compleate.
exit /B 0
