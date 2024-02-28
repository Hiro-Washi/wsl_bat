echo off
setlocal enabledelayedexpansion

:: 'usbipd list' コマンドの出力を一時ファイルにリダイレクト
usbipd list > tmp.txt

:: 一時ファイルを読み込み、目的のデバイスを検索
set "i_busid="
set "rs435i_busid="
set "rs455_busid="

for /f "tokens=1" %%i in ('type tmp.txt ^| findstr /C:"Integrated Camera"') do (
    set "i_busid=%%i"
)

for /f "tokens=1" %%i in ('type tmp.txt ^| findstr /C:"455"') do (
    set "rs455_busid=%%i"
)

::findICBusid
for /f "tokens=1" %%i in ('type tmp.txt ^| findstr /C:"435i"') do (
    set "rs435i_busid=%%i"
    goto :bindIC
)

:: busidが見つかったかどうかをチェックしてバインド
:bindIC
if defined i_busid (
    echo Binding device integrated camera with busid !i_busid!
    usbipd bind --busid !i_busid!
    usbipd attach --wsl --busid !i_busid!
) else (
    echo integrated camera not found.
)
if defined rs455_busid (
    echo Binding device 435i with busid !rs455_busid!
    usbipd bind --busid !rs455_busid!
    usbipd attach --wsl --busid !rs455_busid!
) else (
    echo rs455 Camera not found.
)
if defined rs435i_busid (
    echo Binding rs435i camera with busid !rs435i_busid!
    usbipd bind --busid !rs435i_busid!
    usbipd attach --wsl --busid !rs435i_busid!
) else (
    echo rs435i Camera not found.
)


:: 一時ファイルの削除
:done
del tmp.txt

usbipd list

endlocal
