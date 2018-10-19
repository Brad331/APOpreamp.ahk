global TargetFile := "C:\Program Files\EqualizerAPO\config\BoostGain.txt"	;The script will create and write to this config file.
global Gain := 0															;Initialize integer 'Gain' with value 0.
WriteConfig()																;Apply the initialized value.
CoordMode, ToolTip                                                    		;Set the ToolTip to Coordinate Mode to make it show at an absolute position on the screen.

SC130::																		;When Volume Up is pressed,
    SoundGet, SystemVolume													;Find out what the current system volume is.
    if (SystemVolume = 100) {												;If System Volume is maxed out but Gain is not,
        if (Gain < 50) {
            Gain++															;Increase the Gain by 1dB.
            WriteConfig()													;Run the 'WriteConfig' function.
        }
        ShowGain()															;Use the ShowGain function to display the Gain value in a ToolTip.
    }
    else {																	;But if System Volume is not maxed out,
        Send {Volume_Up}													;Increase System Volume normally.
    }
    return																	;End of this hotkey.
SC12E::																		;When Volume Down is pressed,
    if (Gain > 0) {															;If the Gain can be decreased,
           Gain--															;Decrease the Gain by 1dB.
           ShowGain()														;Use the ShowGain function to display the Gain value in a ToolTip.
        WriteConfig()														;Run the 'WriteConfig' function.
    }
    else {																	;Otherwise (if Gain is at 0),
        Send {Volume_Down}													;Decrease System Volume normally.
    }
    return																	;End of this hotkey.

ShowGain() {
    ToolTip, Gain: %Gain%, 124, 80											;Show the Gain value in a ToolTip on the screen's top-left corner.
    SetTimer, RemoveToolTip, -1000											;Set a 1000ms timer for the ToolTip.
    return
    RemoveToolTip:															;Auto-disappear the ToolTip.
    ToolTip
    return
}

WriteConfig() {																;The function 'WriteConfig' takes care of writing changes to the config file.
    FileDelete, %TargetFile%.tmp.txt										;Delete the old config file in preparation for rewrite.
    FileAppend, Preamp: %Gain% dB, %TargetFile%.tmp.txt						;Write to a Temp File. This ensures the volume adjustment process is smooth and without popping noises.
    FileCopy, %TargetFile%.tmp.txt, %TargetFile%, 1							;Overwrite the Target File with the Temp File.
}
