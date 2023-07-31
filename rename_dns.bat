@echo off
setlocal enabledelayedexpansion

set hostname=api
set domain=xyz.com

set MAX[sand]=127

set LOCATIONS=(dc)

set ENVS[dc]=(^
    sand^
    qa^
    uat^
    stag^
)

REM for %%l in %LOCATIONS% do (
    REM set LIST=!ENVS[%%l]!

    set LIST=%ENVS[dc]%
    for %%e in %LIST% do (

        if "%%e" == "sand" (
            set origprefix=appsand
        )

        for /l %%i in (1, 1, !MAX[%%e]!) do (
            if "%%e" == "sand" (
                dnscmd localhost /enumrecords %domain% %hostname%-%%e%%i >NUL
            )
            if errorlevel 1 (
                :: endpoint's domain hard-coded since we want to manage VMs IPs only on the xyz zone
                echo Record not exists, creating ...
            ) else (
                echo Record already exists, deleting and re-creating...
                dnscmd localhost /recorddelete %domain% %hostname%-%%e%%i CNAME /f
            )
            echo %hostname%-%%e%%i CNAME dc!origprefix!%%i.xyz.com.
            dnscmd localhost /recordadd %domain% %hostname%-%%e%%i CNAME dc!origprefix!%%i.xyz.com.
        )
    )
REM )
