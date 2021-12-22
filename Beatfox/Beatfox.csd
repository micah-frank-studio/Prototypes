; 	Beatfox - Csound Rhythm Generator
; 	by Micah Frank 2020
; 	www.micahfrank.com
;	https://github.com/micah-frank-studio	

<Cabbage>
;Beatfox Prototype 1.0.1
#define KNOB1  outlineColour(255,255,255,50) trackerColour(255,255,255,220), trackerThickness (0.2), style ("normal"), trackerOutsideRadius(1), trackerInsideRadius (0.01), colour(0, 0, 0), textColour(255,255,255)
form caption("Beatfox") size(500, 320), pluginId("4490")
image bounds(0, 0, 500, 320), colour(0, 0, 0) file("beatfox-bg.png")
nslider bounds(10, 98, 70, 50), channel("Amount"), text("HOW MANY?"), range(0, 10000, 10, 1, 1), textColour(255, 255, 255), fontColour(255, 255, 255), velocity(100)
rslider bounds(280, 20, 70, 70),channel("Steps"), text("STEPS"), range(4, 128, 16, 1, 1), $KNOB1
rslider bounds(210, 90, 70, 70),channel("MinBpm"), text("MIN BPM"), range(1, 200, 80, 1, 1), $KNOB1
rslider bounds(280, 90, 70, 70),channel("MaxBpm"), text("MAX BPM"), range(1, 200, 140, 1, 1), $KNOB1
rslider bounds(350, 20, 70, 70),channel("LevelBD"), text("BD"), range(0, 1, 0.5, 1, 0.001), popupText(0), $KNOB1
rslider bounds(420, 20, 70, 70),channel("DensBD"), text("DENSITY BD"), range(0, 1, 0.2, 1, 0.001), popupText(0), $KNOB1
rslider bounds(350, 90, 70, 70),channel("LevelSD1"), text("SD1"), range(0, 1, 0.5, 1, 0.001), popupText(0), $KNOB1
rslider bounds(420, 90, 70, 70),channel("DensSD"), text("DENSITY SD1"), range(0, 1, 0.5, 1, 0.001), popupText(0), $KNOB1
rslider bounds(420, 160, 70, 70),channel("DensPerc"), text("DENSITY PERC"), range(0, 1, 0.5, 1, 0.001), popupText(0), $KNOB1
rslider bounds(350, 160, 70, 70),channel("LevelPerc"), text("PERC"), range(0, 1, 0.5, 1, 0.001), popupText(0), $KNOB1
rslider bounds(350, 230, 70, 70),channel("LevelHH"), text("HH"), range(0, 1, 0.5, 1, 0.001), popupText(0), $KNOB1
rslider bounds(420, 230, 70, 70),channel("DensHH"), text("DENSITY HH"), range(0, 1, 0.8, 1, 0.001), popupText(0), $KNOB1
button bounds(1000, 98, 100, 50), latched(0), channel("Stop"), text("STOP (at end of  current beat)"),identChannel("stopIdent"), fontColour(255, 255, 255), colour:0(19, 19, 19, 255), colour:1(19, 19, 19, 255)
filebutton bounds(100, 98, 100, 50), channel("Directory"), text("RUN"),identChannel("dirIdent"), mode("directory"), fontColour(255, 255, 255), colour:0(19, 19, 19, 255), colour:1(19, 19, 19, 255)
csoundoutput bounds(10, 166, 331, 150), colour("19,19,19"),fontColour(255, 255, 255)
</Cabbage>
 

<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 64
nchnls = 2
0dbfs = 1.0

seed 0 
;;function tables
gi1 ftgen 1,0,129,10,1 ;sine
gi2 ftgen 2,0,129,10,1,0,1,0,1,0,1,0,1 ;odd partials
gi3 ftgen 3, 0, 16384, 10, 1, 0 , .33, 0, .2 , 0, .14, 0 , .11, 0, .09 ;odd harmonics
gi4 ftgen 4, 0, 16384, 10, 0, .2, 0, .4, 0, .6, 0, .8, 0, 1, 0, .8, 0, .6, 0, .4, 0,.2 ; saw
gi5 ftgen 5,0,129,21,1 ;white noise
gi6 ftgen 6,0,257,9,.5,1,270,1.5,.33,90,2.5,.2,270,3.5,.143,90;sinoid
gi7 ftgen 7,0,129,9,.5,1,0 ;half sine
gi8 ftgen 8,0,129,7,1,64,1,0,-1,64,-1 ;square wave
gi9 ftgen 9,0,129,7,-1,128,1 ;actually natural
gi10 ftgen     0, 0, 2^10, 10, 1, 0, -1/9, 0, 1/25, 0, -1/49, 0, 1/81
gi11 ftgen     0, 0, 2^10, 10, 1, 1, 1, 1, 1, 1, 1, 1, 1


;grid resolution
giMasterGridRes = 4 ;(2=8th notes, 4=16th notes, 8=32nd notes, etc)

girandomBPM init 0
gibpm init 0
giBeatsPerSec init 0

schedule 1, 0, 10000 ;prime globals

instr 1
gSdir chnget "Directory"
kstop chnget "Stop"
kstrlen strlenk gSdir

if (changed(gSdir)== 1) && (kstrlen != 0) then
    event "i", 2, 0, 500000
endif
    
    if kstop==1 then
        turnoff2 2, 0, 0
        SStopMessage = "bounds(1000, 98, 100, 50)"
        chnset SStopMessage, "stopIdent"
        SBlastMessage = "bounds(100, 98, 100, 50)"
        chnset SBlastMessage, "dirIdent"
        chnset "", "Directory"
    endif
endin

instr globals, 2
giGenerations chnget "Amount" ;define how many beats to generate
gicounter init 1
reset:
print gicounter
print giGenerations
if gicounter > giGenerations-1 then
        SStopMessage = "bounds(1000, 98, 100, 50)"
        chnset SStopMessage, "stopIdent"
        SBlastMessage = "bounds(100, 98, 100, 50)"
        chnset SBlastMessage, "dirIdent"
        chnset "", "Directory"
        ;prints "Beatfox ended \n"
	            turnoff
endif

prints "new sequence starting...\n"
girandomBPM random (chnget:i("MinBpm")), (chnget:i("MaxBpm")) ;define bpm range - min, max
gibpm = int(girandomBPM)
giBeatsPerSec = gibpm/60 ;quarter notes per sec
giBeatDuration = 60/gibpm ;quarter note length (in seconds)
giSteps = chnget("Steps") ;number of steps in sequence. 64 = 4 bars (in steps)
giSequenceLength = giBeatDuration*giSteps ; 4 bars (in seconds) 
;prints "sequence length is %f seconds\n", giSequenceLength

schedule 98, 0, giSequenceLength ;prime sequencer
schedule 100, 0, giSequenceLength ; prime recorder

ktime init 0
ktime timeinsts

    if ktime > giSequenceLength then ;reset when elapsed time is greater than steps
	    gicounter += 1 
	    SStopMessage = "bounds(100, 98, 100, 50)"
        chnset SStopMessage, "stopIdent"
        SBlastMessage = "bounds(1000, 98, 100, 50)"
        chnset SBlastMessage, "dirIdent"
	    reinit reset
	endif

;;kick values generation
giCounter init 0
gikicksustain random 0.15, 1.0
gikickfreq random 50, 80
gikickres random 0, 0.6

;;kick attack values
giattackfactor random 0.01, 0.25
giatkdur random gikicksustain*giattackfactor, 0.05 ;attack portion < 25% of sus
giatkfreq random 70, 100 
giatklvl random 0.9, 0.3

;;snare values generation
gisnarefreq random 60, 200
gipw random 0.01, 0.99 ;pulse width of snare vco2
gisnlev random 0.1, 0.5
gisnaredur random 0.4, 0.01 
gisnareatk random gisnaredur*0.1, gisnaredur*0.9
gisnarefiltinit random 60,200
gisnarefiltsus random  100, 600
gisnareres random 0.01, 0.7
gisnpenvinit random gisnarefreq, gisnarefreq+300 ; choose initial filt value from freq val
gisnpenvdur random gisnaredur*0.5, gisnaredur*0.01
giSnaremeth random 0.01, 0.5
ginoisetype random 0.1, 0.6
giSynthWaveSelect1 random 0,10.9

;; noco random values
;perc sustain waveform array and selection
gihasatk = round(random(0,1)) > 0 ? 1 : 0.001
gihasfilt = round(random(0,1)) > 0 ? 1 : 0.001 
gipercAtkSelect1 random 0,4
gipercArrayselect1 random 0,4
gimaxnocolen = 0.5 ;;maximum noco decay time
gipercfreq random 50, 1000 ; freq

ginocoatkfreq random 50, 400 ;perc attack freq - default 50, 400
ginocoatklvl random 0.01, 0.5 ;attack portion level - default 0.1, 0.5
ginocoFilterInit random 200, 3000
ginocoFilterEnd random 20, 1000


;;hats values generation
gihatsfreq1 random 100, 500
gihatsfreq2 random 1000, 10000
gihatsdecayshort random 0.01, 0.1
gihatsdecaylong random 0.4, 0.3

;does the hi-hat modulate?
gihatmod random 0,1
;pick hi-hat bpf freq
gihatbpf random 1000, 16000

endin

instr kick, 3

;;kick sustain
initpitch = 4
isuswave  = gi1 ;sine wave sus portion
kpenv expseg initpitch, giatkdur, 1, gikicksustain-giatkdur, 1  ;modulate sustain pitch for attack dur

kamp expseg 0.5, gikicksustain, 0.001

;;kick attack
iatkwave = gi8 ; attack wave
katkenv expseg giatklvl, giatkdur, 0.01 ;attack envelope

asus oscili kamp, gikickfreq*kpenv, isuswave
aatk oscili katkenv, giatkfreq, iatkwave

kfiltenv expseg 3000, gikicksustain, 20

afilteredsig moogvcf2 asus + aatk, kfiltenv, gikickres

akick = afilteredsig*(chnget("LevelBD"))

outs akick, akick

endin

instr snare1, 4
itablearray [] fillarray gi1,gi2,gi3,gi4,gi5,gi6,gi7,gi8,gi9, gi10, gi11

	
ifn = itablearray[giSynthWaveSelect1] ;waveform is static throughoutv

irandomAmp random 0.2, 0.5
irevAmp random 0.4, 0.1

kamp expseg irandomAmp, gisnaredur, 0.001
kampsn expseg irandomAmp, gisnaredur*0.5, 0.001 ;snare portion is half length

ksnpenv expseg gisnpenvinit, gisnpenvdur, gisnarefreq ; snare pitch envelope
asig vco2 kamp, ksnpenv, 4, gipw
asnare noise kampsn, ginoisetype
kfiltenv expseg gisnarefiltinit, gisnareatk, gisnarefiltsus, gisnaredur-gisnareatk, gisnarefiltsus

afilteredsig butterhp (asig + (asnare*gisnlev)), kfiltenv

afilteredsig clip afilteredsig, 1, gisnareres

asnare =  afilteredsig*(chnget("LevelSD1"))

outs asnare, asnare

endin

instr 5, perc
;params
gipercsustain random 0.01, gimaxnocolen ; generates sustain between 0.01 and max length set
gipercres random 0, 0.7 ; resonance. Careful!
ginitpitch random 0.01, gipercsustain ;pitch env init point (factor of gipercfreq 0.0 - 1.0)
giPDecayFactor random 0.9, 0.01 ;pitch decay (factor of gipercsustain 0.0 - 1.0)

;noco attack values
ginocoatkdur random 0.005, gipercsustain*0.25 ; perc attack duration. At most, half of total sustain

ipercSusArray[] fillarray gi1, gi4, gi5, gi6, gi7
ipercSelection1 = ipercSusArray[round(gipercArrayselect1)]

;perc attack waveform array and selection
ipercAtkArray[] fillarray gi1, gi4, gi5, gi6, gi7
ipercAtkSelection1 = ipercAtkArray[round(gipercAtkSelect1)]

;;perc sustain
isuswave  =  ipercSelection1 ;choose waveform
kpenv expseg ginitpitch, ginocoatkdur, 1, (gipercsustain-ginocoatkdur)*giPDecayFactor, 0.001  ;modulate pitch.

kamp expseg 0.5, gipercsustain, 0.001

;;perc attack
iatkwave = ipercAtkSelection1 ; attack wave
katkenv expseg ginocoatklvl, ginocoatkdur, 0.001 ;attack envelope

asus oscili kamp, gipercfreq, isuswave
aatk oscili katkenv, ginocoatkfreq, iatkwave

kfiltenv expseg ginocoFilterInit, gipercsustain*0.25, abs(ginocoFilterInit-(ginocoFilterEnd*gihasatk))
idelAmp random 0, 0.2
if gihasfilt == 1 then
    afilteredsig moogvcf2 asus+aatk, kfiltenv, gipercres
else
    afilteredsig = asus + aatk
endif
;anocoL, anocoR pan2 afilteredsig, 0.5+(gauss(0.5))
afilteredsig limit afilteredsig, -0.9, 0.9 ;limiter
aperc = afilteredsig*chnget("LevelPerc")
outs aperc, aperc
endin

instr hats, 6
gihatsdecayshort random 0.01, 0.4
irandomAmp random 0.1, 0.5
;decide wheather "closed" or "open" hat
iclosedOrOpen random 0,1
ihatdecay = iclosedOrOpen > 0.9 ? gihatsdecaylong : gihatsdecayshort
ifn  = gi8 ;square wave
kamp expseg irandomAmp, ihatdecay, 0.001
ahat1 vco2 kamp, gihatsfreq1, ifn
ahat2 oscili kamp, gihatsfreq2, ifn
irevAmp random 0.05, 0.3
idelAmp random 0.01, 0.5
abp butterhp ahat1 + ahat2, gihatbpf ;highpass filter hats

;chnmix abp, "drums"
ahat = abp*chnget("LevelHH")
outs ahat, ahat
endin 


instr drumsSeq, 98
;densities

gkKickdensity chnget "DensBD"
gkSnaredensity chnget "DensSD"
gkPercdensity chnget "DensPerc"
gkHatsdensity chnget "DensHH"



iGridRes1 = giBeatsPerSec * giMasterGridRes
ktrig metro iGridRes1 ;metronome triggers 16th notes

if ktrig = 1 then
	;make random values for voice that decide against density value
	kKickDecider random 0, 1
	kSnare1Decider random 0, 1
	kPercDecider random 0, 1
	kHatDecider random 0, 1
	
	if kKickDecider < gkKickdensity then
		event "i", 3, 0, iGridRes1
	endif
	
	if kSnare1Decider < gkSnaredensity then
		event "i", 4, 0, iGridRes1		
	endif
	
	if kPercDecider < gkPercdensity then
		event "i", 5, 0, iGridRes1		
	endif
	
	if kHatDecider < gkHatsdensity then
		event "i", 6, 0, 1		
	endif
	
endif	

endin

instr recorder, 100
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

allL, allR monitor

;;file writing
Sfilename sprintf "%ibpm-", gibpm
gSdir strcat gSdir, "/"
Sfilename strcat gSdir,Sfilename
Sfilename strcat Sfilename,Stitle 
Sfilename strcat  Sfilename, ".wav"
fout Sfilename, 18, allL, allR 

endin


</CsInstruments>
<CsScore> 
</CsScore>
</CsoundSynthesizer>
