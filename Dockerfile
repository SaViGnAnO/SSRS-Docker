FROM advitec/mssql-server-windows-developer

LABEL  Name=SSRS2019 Version=0.0.1 maintainer="Brian Savignano"

ENV exe "https://download.microsoft.com/download/1/a/a/1aaa9177-3578-4931-b8f3-373b24f63342/SQLServerReportingServices.exe"

ENV sa_password="_" \
    attach_dbs="[]" \
    ACCEPT_EULA="_" \
    sa_password_path="C:\ProgramData\Docker\secrets\sa-password" \
    ssrs_user="_" \
    ssrs_password="_" \
    SSRS_edition="Dev" \
    ssrs_password_path="C:\ProgramData\Docker\secrets\ssrs-password"

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# make install files accessible
COPY start.ps1 /
COPY configureSSRS2019.ps1 /
COPY sqlstart.ps1 /
COPY newadmin.ps1 /

WORKDIR /

RUN  Invoke-WebRequest -Uri $env:exe -OutFile SQLServerReportingServices.exe ; \
    Start-Process -Wait -FilePath .\SQLServerReportingServices.exe -ArgumentList "/quiet", "/norestart", "/IAcceptLicenseTerms", "/Edition=$env:SSRS_edition" -PassThru -Verbose

CMD .\start -sa_password $env:sa_password -ACCEPT_EULA $env:ACCEPT_EULA -attach_dbs \"$env:attach_dbs\" -ssrs_user $env:ssrs_user -ssrs_password $env:ssrs_password -Verbose

