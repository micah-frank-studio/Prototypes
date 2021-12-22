; Spindle - Granular Composite Generator
; by Micah Frank 2021
; Attribution-NonCommercial 4.0 International (CC BY-NC 4.0)
; Attribution — You must give appropriate credit, provide a link to the license, and indicate if changes were made. You may do so in any reasonable manner, but not in any way that suggests the licensor endorses you or your use.
; NonCommercial — You may not use the material for commercial purposes.
; No additional restrictions — You may not apply legal terms or technological measures that legally restrict others from doing anything the license permits.


<Cabbage>
form caption("Spindle") size(390, 320), colour(37,54,63), guiMode("queue"), pluginId("SP91")
#define KNOB1 outlineColour(255,255,255,40) trackerColour(171,179,203), trackerInsideRadius (0.8), colour(210, 215, 211, 0), textColour(90,90,90, 200), textColour("171,179,203"), textBoxOutlineColour("200, 200, 200"), markerColour("171,179,203"), popupText(0)
filebutton bounds (10, 20, 100, 50), mode("directory"), channel("Samples"), text("SAMPLE FOLDER"),fontColour(255, 255, 255), colour:0(19, 19, 19, 255)
filebutton bounds(10, 80, 100, 50), channel("Output"), text("OUTPUT FOLDER"), mode("directory"), fontColour(255, 255, 255), colour:0(19, 19, 19, 255)
button bounds(280, 80, 100, 50), channel("Render"), text("RENDER"), fontColour(255, 255, 255), colour:0(19, 19, 19, 255), colour:1(200, 19, 19, 255)
nslider bounds (120,20,70,30), range(1,7000,5,0.5, 1), channel("CompositeTime"), text("Composite Time")
nslider bounds (200,20,70,30), range(1,1000,10,1, 1), channel("Generations"), text("Generations")
nslider bounds (120,80,70,30), range(0.5,10,1,1), channel("MinDur"), text("Min Sound Dur")
nslider bounds (200,80,70,30), range(1,10,5,1), channel("MaxDur"), text("Max Sound Dur")
label bounds(95,60,200,15), fontColour(200,30,30), text("Select a sample folder"), alpha(0), channel("SampleWarning")
label bounds(95,60,200,15), fontColour(200,30,30), text("Select an output folder"), alpha(0), channel("FolderWarning")
button bounds(280, 20, 100, 50), latched(1), channel("Binaural"), text("BINAURAL"), fontColour(255, 255, 255), colour:0(19, 19, 19, 255), colour:1(180, 180, 180, 255)
csoundoutput bounds(10, 140, 370, 170), colour("19,19,19"),fontColour(255, 255, 255)

</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 --midi-key-cps=4 --midi-velocity-amp=5 --displays
</CsOptions>
<CsInstruments>

ksmps = 64
nchnls = 2
0dbfs = 1
seed 0

gimaxsounds init 0 ;maximum # of sounds to pull
gilen init 0 ; maximum length in seconds per sound
giChangeSounds = 0 ; change sound palette after gilen (0=no, 1=yes)
gi1 ftgen 1,0,8192,20,2,1 ;Hanning Window
giL[] init 200 ;one alloc per channel/ftable
giR[] init 200

schedule "verb", 0, 500000
schedule "listener", 0, 500000
gkstop init 0
opcode grainPlayer, aa, i
	setksmps 1
	idur xin
	idx = int(linrand(gimaxsounds)) ; pick a random sample from the array
	igrsize = random(0.02, 1)
	ifreq = random(2, 10)
	kfreq = rspline(ifreq*0.5, ifreq, 0.1, 0.4)
	kgrsize = rspline(igrsize*0.5, igrsize, 0.1, 0.5)
	ipshift = linrand(1) ;does it dynamically pitch shift?
	igrainShift = linrand(1) ;does it grainshift?
	irateShift = linrand(1) ;does it rateshift?
	ipsel = random(-1, 1) ;select a pitch from -1 to 2 if it does not dynaically shift
	kpitchrand = rspline(0.2, 1, 0.1, 0.3)
	kpitch = ipshift > 0.7 ? kpitchrand : ipsel ;does pitch change dynamically or stay static
	kprate= rspline(0.5, 1, 0.3, 0.1)
	kprate = irateShift > 0.5 ? kprate : 1
	ifun = gi1
	iolaps =  1 + int(ifreq*igrsize) ;imaxfreq; must be equal or greater to imaxfreq*imaxgrsize 
	ips     = 1/iolaps
	ilength = ftlen(giL[idx])/sr ;length of sample in seconds
		kstart = ilength*(jspline(0.8, 0.1, 0.3))
	kend = kstart+((ilength-kstart)*jspline(1, 0.1, 0.3))
			agrainL syncloop 1, kfreq, kpitch, kgrsize, kprate*ips, kstart, kend, giL[idx], gi1, iolaps
			agrainR syncloop 1, kfreq, kpitch, kgrsize, kprate*ips, kstart, kend, giR[idx], gi1, iolaps				
	aoutL dcblock2 agrainL
	aoutR dcblock2 agrainR
 	xout aoutL, aoutR

endop

opcode varifilter, aa,aakki
	al, ar, kcf, kres, itype xin
	if itype < 1 then
	    kres limit kres, 0.001, 0.999
	    afl moogvcf2 ar, kcf, kres
	    afr moogvcf2 al, kcf, kres
	else 
        afl butterhp al, kcf
        afr butterhp ar, kcf
	endif
    
    xout afl, afr
endop

opcode pdelay, aa, aaakk
	al,ar, adelay, kfeedback, kfbpshift xin ; spectral pshift not used
	imaxdelay = 3; seconds
	;delay L
	alfoL lfo 0.05, 0.2 ; slightly mod the left delay time
	abuf1		delayr	imaxdelay
	atapL  deltap3    adelay +alfoL
	delayw  al+ (atapL * kfeedback)
	
	;delay R
	alfoR lfo 0.05, 0.1 ; slightly mod the right delay time
	abuf2		delayr	imaxdelay
	atapR  deltap3    adelay +alfoR
	delayw  ar + (atapR * kfeedback)
	xout atapL, atapR 
endop

opcode binaural, aa,aa
	ainL, ainR xin
	; Binaural Processing
  ; azimuthrange  -720, 720
  ;altitude range -40, 90
	isr = sr
	if (sr = 44100) then
	SfileL = "HRTF/hrtf-44100-left.dat"
	SfileR = "HRTF/hrtf-44100-right.dat"
	elseif (sr = 48000) then
	SfileL = "HRTF/hrtf-48000-left.dat"
	SfileR = "HRTF/hrtf-48000-right.dat"
	elseif (sr = 96000) then
	SfileL = "HRTF/hrtf-96000-left.dat"
	SfileR = "HRTF/hrtf-96000-right.dat"
	endif
	kazim = rspline(-720, 720, 0.01, 1)
	kalt = rspline(-40, 90, 0.01, 1)
	ahrtfL, ahrtfR hrtfmove2 ainL+ainR, kazim, kalt, SfileL, SfileR, 4, 9, isr
	xout ahrtfL, ahrtfR
endop

instr listener, 1

SampleFolder, kTrigger cabbageGetValue "Samples"
gSdir, kRun cabbageGetValue "Output"
kstrlen strlenk gSdir
gSFiles[] cabbageFindFiles kTrigger, SampleFolder, "files", "*.wav;*.aif"
kNumSamples = lenarray:k(gSFiles)
krender chnget "Render"
if changed(krender) == 1 && krender == 1 then
    if kNumSamples < 1 then ; if no samples are selected display message
        cabbageSet 1, "SampleWarning", "alpha", "1"
        cabbageSetValue "Render", 0, 1
    elseif kstrlen < 1 then ; if no output folder is selected display message
        cabbageSet krender, "SampleWarning", "alpha", "0"
        cabbageSet 1, "FolderWarning", "alpha", "1"
        cabbageSetValue "Render", 0, 1
    else
        cabbageSet krender, "SampleWarning", "alpha", "0"
        cabbageSet krender, "FolderWarning", "alpha", "0"
        ;cabbageSet krender, "Stop", "bounds(280, 80, 100, 50)"
        ;cabbageSet krender, "Go", "bounds(1000, 80, 100, 50)"
        schedkwhen krender, 0, 1, 2, 0, 500000
    endif
endif 

if changed(krender) == 1 && krender == 0 then
        turnoff2 2, 0, 0 ; turnoff timer
        turnoff2 3, 0, 0 ; turnoff sound engine
        turnoff2 6, 0, 0 ; turnoff recorder
    endif
     
endin

instr timer, 2
    prints "Timer initialized\n"
	koldtime init 0
	kiter init 0
	iiter chnget "Generations" ;how many sounds to generate?
	kelapsed times
	restart: ; pull a new group of sounds to process
	prints "Generating New Composite\n"
	gireverbmode = 1 ;1 = modulation of reverb params per sequence. 0 reverb setting is randomly chosen and stays static. 
	gimaxsounds = int(random(1,lenarray(gSFiles))) ;maximum # of sounds to pull
	gilen = random(chnget("MaxDur"), chnget("MinDur")) ; maximum length in seconds per sound
	giChangeSounds = 1 ; change sound palette after gilen (0=no, 1=yes)
	itime = chnget("CompositeTime"); how long is each sequence?
	giverbfc = random(0.1, 0.9)
	giverbfblvl = random(0.2, 0.7)
	schedule 3, 0, itime
	schedule 6, 0, itime ;recorder
	if kelapsed > itime + koldtime then
		turnoff2 3, 0, 0 ;turnoff sound engine
		turnoff2 6, 0, 0 ;turnoff recorder
	        if kiter < iiter then 
	            kiter += 1
	            koldtime = kelapsed
	            reinit restart
	        else
	            printks "Composite Ended\n", 0.2
                cabbageSetValue "Render", 0, 1 ; reset render state
	        endif
	    endif
 endin

instr 3
	idirsize=lenarray(gSFiles) ;number of files in dir
	iselection[] init idirsize
	knewsounds metro 1/gilen
	if knewsounds == 1 && giChangeSounds = 1 then ; replace sound selection index every gilen seconds
		reinit newSounds
	printks "new sounds selected \n", 0.4
	endif
	newSounds:
	icount init 0
		makenums: ; make an array of indexes to pull file from in the directory		
		if icount < gimaxsounds then
			irand = int(random(0, idirsize)) ;choose a random index # for the directory
			iselection[icount] = irand		;put the number in the array
			ichn filenchnls gSFiles[irand]
			if ichn = 2 then
				giL[icount] ftgen 0, 0, 0, 1, gSFiles[irand], 0, 0, 1
				giR[icount] ftgen 0, 0, 0, 1, gSFiles[irand], 0, 0, 2
			else
				giL[icount] ftgen 0, 0, 0, 1, gSFiles[irand], 0, 0, 1
				giR[icount] ftgen 0, 0, 0, 1, gSFiles[irand], 0, 0, 1
			endif
			icount+=1
			goto makenums
		endif
	rireturn
	imaxspeed=random(1, 10)
	kspeed=rspline(0.2, imaxspeed, 0.1, 0.3) ;create speed for metro
	ktrig=metro(kspeed)
	kdur1 = abs(rand(gilen))
	schedkwhennamed ktrig, 0, 0, "sound", 0, kdur1	
endin


instr sound, 4
	idur = p3
	agrainL, agrainR grainPlayer idur ; send file index and duration to grainplayer
	ahpL butterhp agrainL, 50		;filter out low freqs
	ahpR butterhp agrainR, 50
	kcf = rspline(0.1, 0.9, 0.1, 0.5)
	kcf = expcurve(kcf,50) ;add curve to normalized kcf
	kcf = scale(kcf, 20000, 5000); scale kcf to appropriate range
	kres = rspline(0, 0.1, 0.2, 0.5)
	itype=round(random(0,1)) ;high pass or low pass?
	afiltL, afiltR varifilter ahpL, ahpR, kcf, kres, itype
	kvolume = rspline(0.2, 0.7, 0.1, 0.3)
	idec = random(idur*0.2, idur*0.001) ; decay is a factor of total duration 
	isuslev = random(0.3, 1)
	kamp = expseg(0.001, 0.001, 1, idur-idec-0.01, isuslev, idec, 0.001)*kvolume ; linen(1, 0.1, idur-idec-0.05, idec)*kvolume ;apply envelope to overall volume to fade in/out quickly
	if chnget:k("Binaural") > 0 then
	    apanL1, apanR1 binaural afiltL, afiltR
	    apanL2 = 0
	    apanR2 = 0
	else 
	    kpan=rspline(0.2, 0.8, 0.1, 0.3)
	    apanL1, apanR1 pan2 afiltL, kpan
	    apanL2, apanR2 pan2 afiltR, kpan
	endif
	//DELAY
	kdelaySend=rspline(0.05, 0.3, 0.1, 0.5)
	adelay = abs(randi(1,0.1)+0.1);rspline(0.5, 2, 0.1, 0.3)
	kfeedback = rspline(0.0, 0.3, 0.05, 0.3)
	kfbpshift = rspline(0.1, 2, 0.1, 0.3)						//pitch shift not used b/c processor limits
	adelL, adelR pdelay (apanL1+apanL2)*kdelaySend, (apanR1+apanR2)*kdelaySend, adelay, kfeedback, kfbpshift
	amixL = adelL + apanL1 + apanL2
	amixR = adelR + apanR1 + apanR2
	//REVERB
	kverbSend= rspline(0.0, 0.8, 0.1, 0.5)
	chnmix amixL*kamp*kverbSend, "verbmixL"
	chnmix amixR*kamp*kverbSend, "verbmixR"
	
	outs amixL*kamp, amixR*kamp
	chnmix amixL*kamp, "DryL"
	chnmix amixR*kamp, "DryR"
endin

instr verb, 5
	ainL chnget "verbmixL"
	ainR chnget "verbmixR"
	if gireverbmode > 0 then
		kfblvl=rspline(0.3, 0.99, 0.1, 2)
		kfc = rspline(0.1, 0.9, 0.1, 0.2)
	else
		kfblvl=giverbfblvl
		kfc=giverbfc
	endif
	kfc = scale(kfc, 10000, 2000); scale kcf to appropriate range
	aRevL,aRevR reverbsc ainL, ainR, kfblvl, kfc

	
	outs aRevL, aRevR
	chnmix aRevL, "VerbOutL"
	chnmix aRevR, "VerbOutR"
	chnclear "verbmixL"
	chnclear "verbmixR"
	
endin

instr 6
    prints "========NEW RECORDER INSTANCE========\n"
    Sdir init "."
	Sdir=chnget:S("Output")
	;; random word generator
	icount init 0
	iwordLength random 2,4 ; how long will the random word be (when this number is doubled)
	iwordLength = int(iwordLength)
	StringAll =       "bcdfghjklmnpqrstvwxz"
	StringVowels =     "aeiouy"
	Stitle = ""
	cycle:
	if icount < iwordLength then 
	irandomLetter  random 1,20
	irandomVowel  random 1,6	
	Ssrc1 strsub StringAll, irandomLetter,irandomLetter+1
	Ssrc2 strsub StringVowels, irandomVowel,irandomVowel+1
	Ssrc1 strcat Ssrc1, Ssrc2 ; combine consonants and vowels
	Stitle strcat Stitle, Ssrc1 ;add to previous string iteration
                icount += 1
                goto cycle
endif

	aDL chnget "DryL"
	aDR chnget "DryR"
	aVL chnget "VerbOutL"
	aVR chnget "VerbOutR"
    
    amixL = aDL + aVL
    amixR = aDR + aVR
	;;file writing
    
    Sdir strcat Sdir, "/"
	Sfilename strcat Sdir, Stitle	
	Sfilename strcat  Sfilename, ".wav"
	fout Sfilename, 18, amixL, amixR
	
	chnclear "DryL"
	chnclear "DryR"
	chnclear "VerbOutL"
	chnclear "VerbOutR"

endin


</CsInstruments>
<CsScore>
f0 z
e
</CsScore>
</CsoundSynthesizer>
