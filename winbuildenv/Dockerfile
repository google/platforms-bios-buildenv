# Copyright 2021 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM mcr.microsoft.com/dotnet/framework/sdk:4.8-windowsservercore-ltsc2016

SHELL ["cmd", "/S", "/C"]

# Install Visual Studio tools. Make sure to include recommended components.
ADD https://aka.ms/vs/16/release/vs_buildtools.exe C:\\TEMP\\vs_buildtools.exe
# Error 3010 is "reboot required" and can be safely ignored.
RUN C:\\TEMP\\vs_buildtools.exe  --quiet --wait --norestart --nocache --installPath "C:\\BuildTools" --add Microsoft.VisualStudio.Workload.VCTools --includeRecommended || "IF %ERRORLEVEL%"=="3010" EXIT 0

# Install python
ADD https://www.python.org/ftp/python/3.9.6/python-3.9.6-amd64.exe C:\\TEMP\\python_install.exe
RUN C:\\TEMP\\python_install.exe /quiet InstallAllUsers=1 PrependPath=1 TargetDir="C:\\Python39"

# Install NASM
ADD https://www.nasm.us/pub/nasm/releasebuilds/2.15.05/win64/nasm-2.15.05-win64.zip C:\\TEMP\\nasm_install.zip
RUN powershell.exe -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('C:\\TEMP\\nasm_install.zip', 'C:\\'); }"

# Install IASL
ADD https://acpica.org/sites/acpica/files/iasl-win-20210730.zip C:\\TEMP\\iasl_install.zip
# Do not change this path. Some scripts expect this location.
RUN mkdir C:\\ASL
RUN powershell.exe -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('C:\\TEMP\\iasl_install.zip', 'C:\\ASL'); }"

# Install Perl
ADD https://strawberryperl.com/download/5.32.1.1/strawberry-perl-5.32.1.1-64bit-portable.zip C:\\TEMP\\perl_install.zip
RUN mkdir C:\\perl
RUN powershell.exe -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('C:\\TEMP\\perl_install.zip', 'C:\\perl'); }"

# Append these tools to the system path.
RUN setx path "%path%;C:\nasm-2.15.05;C:\ASL;C:\perl\perl\site\bin;C:\perl\perl\bin;C:\perl\c\bin"

RUN del /F/Q/S TEMP

# Entry point must be cmd. BAT scripts expect to change the global environment
# on the parent shell.
ENTRYPOINT ["C:\\BuildTools\\Common7\\Tools\\VsDevCmd.bat", "&&" ]
CMD ["cmd"]
