<Cabbage>
form caption("Aysta") size(420, 200), colour(40, 45, 45), guiMode("queue"), pluginId("3978")
filebutton bounds(16, 12, 117, 40) populate("*.wav", "."), channel("loadfile"), text("LOAD"), file("gowanus.wav"), corners(0)
filebutton bounds(150, 12, 117, 40), channel("RecordMode"), mode("save"), text("RENDER", "RENDER"), corners(0)
button bounds(1000, 12, 117, 40), latched(0), text("RENDER", "RENDER"), channel("StopMode"), colour:0("245,0,200,200"), fontColour:0("245,245,245,200")

csoundoutput bounds(10, 70, 400, 100), colour("19,19,19"),fontColour(255, 255, 255)

</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 -midi-key-cps=4 --midi-velocity-amp=5

</CsOptions>
<CsInstruments>
; Initialize the global variables. 

ksmps = 64
nchnls = 2
0dbfs = 1
seed 0

;gimaxframes = 3 ;maximum # of frames to pull
gilen = 15 ; maximum length in seconds per frame
gi1 ftgen 1,0,8192,20,2,1 ;Hanning Window
giL init 0			
giR init 0		

opcode grainPlayer, aa, ii
	setksmps 1
	istart, iend xin
	imaxfreq = random(3, 20)
	kfreq = rspline(2, imaxfreq, 0.1, 0.3)
	kamp = rspline(0.1, 0.3, 0.1, 0.3)
	kgrsize = rspline(1.5, 1, 0.1, 0.3)    ;this works rspline(1, 0.8, 0.1, 0.3)
	irateShift = linrand(1) ;does it rateshift?
	kpitchrand = rspline(0.1, 2, 0.05, 0.2)
	ipsel = random(0.01, 2) ;select a pitch from -1 to 2 if it does not dynaically shift
	kpitch = random(0.2, 1) ;ipshift > 0.5 ? kpitchrand : ipsel ;does pitch change dynamically or stay static
	kprate= rspline(0.1, 2, 0.3, 0.1)
	ifun = gi1
	iolaps = 10 ;imaxgrsize*imaxfreq ; must be equal or greater to imaxfreq*imaxgrsize
	ips     = 1/iolaps
	kstart = k(istart)
	kend = k(iend)
	agrainL syncloop kamp, kfreq, kpitch, kgrsize, kprate, kstart, kstart+kend, giL, gi1, iolaps, istart
	agrainR syncloop kamp, kfreq, kpitch, kgrsize, kprate, kstart, kstart+kend, giR, gi1, iolaps, istart	
 	xout agrainL, agrainR

endop


instr seq, 1
    gSRecording = chnget:S("loadfile") ; pull the sample from file box
    Sfile, kfilechange cabbageGet "loadfile"
    loadNewSounds:
    giL ftgen 0, 0, 0, 1, gSRecording, 0, 0, 1
    giR ftgen 0, 0, 0, 1, gSRecording, 0, 0, 2
    rireturn
    if kfilechange == 1 then    
                 reinit loadNewSounds
    endif
        schedule 2, 0, 500000 ; initialize sequence w three parts
        schedule 2, 0, 500000
        ;schedule 2, 0, 500000
        ;schedule 2, 0, 500000
        krate = rspline(0.1, 1, 0.5, 0.2) 
        ktrig = metro(krate)              
            if ktrig > 0 then
                turnoff2 2, 1, 0 ; turnoff the oldest instance
            event "i", 2, 0, 500000
        endif
        
        //# bounce recorded audio
    gSSaveFile, kTrigRecord cabbageGetValue "RecordMode"
    schedkwhennamed kTrigRecord, 0, 1, 100, 0, 500000 ; trigger instr 11 (recorder) when render button is pressed
    gkStopButton, kTrigStop cabbageGetValue "StopMode"
    if kTrigStop > 0 then
    turnoff2 100, 0, 0
    cabbageSet kTrigStop, "RecordMode", sprintfk("bounds(%i, 12, 117, 40)", 150)
    cabbageSet kTrigStop, "StopMode", sprintfk("bounds(%i, 12, 117, 40)", 1000)
    endif
endin

instr 2 
    ilenms = round(linrand(1)) > 0 ? random(500,5000) : random(50, 500) ; select long or short durations in ms
    ilenS = ilenms*0.001
    ifilelength = filelen(gSRecording); get length in seconds of sample file
    istarttime = (ifilelength-ilenS)*(random(0,1)) ; get a random start point and subtract ilenS so it doesn't over-extend
	agrainL, agrainR grainPlayer istarttime, ilenS ; send file index and duration to grainplayer
	ahpL butterhp agrainL, 100		;filter out low freqs
	ahpR butterhp agrainR, 100
	kverbSend=rspline(0.1, 1, 0.1, 0.5)
	chnmix ahpL*kverbSend, "verbmixL"
	chnmix ahpR*kverbSend, "verbmixR"	
	outs ahpL, ahpR
endin


instr reverb, 3
	ainL chnget "verbmixL"
	ainR chnget "verbmixR"
	kfblvl=rspline(0.3, 0.99, 0.1, 2)
	kfc=rspline(1000, 16000, 0.1, 0.2)
	aRevL,aRevR reverbsc ainL, ainR, kfblvl, kfc
	
	outs aRevL, aRevR
	
	chnclear "verbmixL"
	chnclear "verbmixR"
	
endin

instr 100
cabbageSet "RecordMode", sprintf("bounds(%i, 12, 117, 40)", 1000)
cabbageSet "StopMode", sprintf("bounds(%i, 12, 117, 40)", 150)
prints "recording started\n"
allL, allR monitor
Sfilename strcat  gSSaveFile, ".wav"
fout Sfilename, 18, allL, allR 
endin

</CsInstruments>
<CsScore>
i1 0 500000
i3 0 500000
f 0 z
e
</CsScore>
</CsoundSynthesizer>