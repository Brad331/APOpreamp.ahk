global TargetFile := "C:\Program Files\EqualizerAPO\config\DynamiQ-master\Gain.txt" ;The script will write to this config file.
global Gain := 0                                        ;Initialize integer 'Gain' with value 0.
WriteConfig()                                           ;Apply the initialized value.
CoordMode, ToolTip                                      ;Set the ToolTip to Coordinate Mode to make it show at an absolute position on the screen.
                                                        ;Adding the $ before the hotkey to prevent looping when the hotkey sends itself.
$Volume_Up::                                            ;When Volume Up is pressed,
    SoundGet, SystemVolume                              ;Find out what the current system volume is.
    if (SystemVolume = 100) {                           ;If System Volume is maxed out but Gain is not,
        if (Gain < 50) {
            Gain++                                      ;Increase the Gain by 1dB,
            WriteConfig()                               ;And write that into the config using the WriteConfig function,
        }
        ShowGain()                                      ;Use the ShowGain function to display the Gain value in a ToolTip.
    }
    else {                                              ;But if System Volume is not maxed out,
        Send {Volume_Up}                                ;Increase System Volume normally.
    }
    return                                              ;End of this hotkey.
$Volume_Down::                                          ;When Volume Down is pressed,
    if (Gain > 0) {                                     ;If the Gain is not already 0,
        Gain--                                          ;Decrease the Gain by 1dB,
        WriteConfig()                                   ;And write that into the config using the WriteConfig function.
        ShowGain()                                      ;Use the ShowGain function to display the Gain value in a ToolTip.
    }
    else {                                              ;Otherwise (if Gain is already 0),
        Send {Volume_Down}                              ;Decrease System Volume normally.
    }
    return                                              ;End of this hotkey.

ShowGain() {
    ToolTip, Gain: %Gain%, 124, 80                      ;Show the Gain value in a ToolTip on the screen's top-left corner.
    SetTimer, RemoveToolTip, -1000                      ;Set a 1000ms timer for the ToolTip.
    return
    RemoveToolTip:                                      ;Auto-disappear the ToolTip.
    ToolTip
    return
}

WriteConfig() {                                         ;The function 'WriteConfig' takes care of writing changes to the config file.
    FileDelete, %TargetFile%.tmp.txt                    ;Delete the old config file in preparation for rewrite.
    FileAppend, Preamp: %Gain% dB, %TargetFile%.tmp.txt ;Write to a Temp File first,
    FileCopy, %TargetFile%.tmp.txt, %TargetFile%, 1     ;Then overwrite the Target File with the Temp File,
}                                                       ;To make the volume adjustment process smoother and reduce popping noises.
