; 	Beatfox - Csound Rhythm Generator
; 	by Micah Frank 2020
; 	www.micahfrank.com
;	https://github.com/micah-frank-studio	

<Cabbage>
;Beatfox Prototype 1.0.1
#define KNOB1  outlinecolour(255,255,255,50) trackercolour(255,255,255,220), trackerthickness (0.2), style ("normal"), trackeroutsideradius(1), trackerinsideradius (0.01), colour(0, 0, 0), textcolour(255,255,255)
form caption("Beatfox") size(500, 380), pluginid("4490")
image bounds(0, 0, 354, 345), colour(0, 0, 0) file("beatfox-bg.png")
nslider bounds(10, 98, 70, 50), channel("Amount"), text("HOW MANY?"), range(0, 10000, 10, 1, 1), textcolour(255, 255, 255), fontcolour(255, 255, 255), velocity(100)
rslider bounds(280, 20, 70, 70),channel("Steps"), text("STEPS"), range(4, 128, 16, 1, 1), $KNOB1
rslider bounds(210, 90, 70, 70),channel("MinBpm"), text("MIN BPM"), range(1, 400, 60, 1, 1), $KNOB1
rslider bounds(280, 90, 70, 70),channel("MaxBpm"), text("MAX BPM"), range(1, 400, 140, 1, 1), $KNOB1
rslider bounds(350, 20, 70, 70),channel("BD"), text("BD"), range(0, 1, 0.5, 1, 0.001), popuptext(0), $KNOB1
rslider bounds(420, 20, 70, 70),channel("DensBD"), text("DENSITY BD"), range(0, 1, 0.2, 1, 0.001), popuptext(0), $KNOB1
rslider bounds(350, 90, 70, 70),channel("SD1"), text("SD1"), range(0, 1, 0.5, 1, 0.001), popuptext(0), $KNOB1
rslider bounds(420, 90, 70, 70),channel("DensSD"), text("DENSITY SD1"), range(0, 1, 0.5, 1, 0.001), popuptext(0), $KNOB1
rslider bounds(350, 160, 70, 70),channel("SD2"), text("SD2"), range(0, 1, 0.5, 1, 0.001), popuptext(0), $KNOB1
rslider bounds(350, 230, 70, 70),channel("HH"), text("HH"), range(0, 1, 0.5, 1, 0.001), popuptext(0), $KNOB1
rslider bounds(420, 230, 70, 70),channel("DensHH"), text("DENSITY HH"), range(0, 1, 0.8, 1, 0.001), popuptext(0), $KNOB1
rslider bounds(350, 300, 70, 70),channel("OH"), text("OH"), range(0, 1, 0.5, 1, 0.001), popuptext(0), $KNOB1
button bounds(1000, 98, 100, 50), latched(0), channel("Stop"), text("STOP (at end of  current beat)"),identchannel("stopIdent"), fontcolour(255, 255, 255), colour:0(19, 19, 19, 255), colour:1(19, 19, 19, 255)
filebutton bounds(100, 98, 100, 50), channel("Directory"), text("RUN"),identchannel("dirIdent"), mode("directory"), fontcolour(255, 255, 255), colour:0(19, 19, 19, 255), colour:1(19, 19, 19, 255)
csoundoutput bounds(10, 166, 331, 370), colour("19,19,19"),fontcolour(255, 255, 255)
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

;;set mixer levels (0 to 0.9 on last parameter)
MixerSetLevel 2, 97, 0.8 ;kick
MixerSetLevel 3, 97, 0.8 ;snare 1
MixerSetLevel 4, 97, 0.6 ;snare 2 (tuned percussion)
MixerSetLevel 5, 97, 0.4 ;hat

;grid resolution
giMasterGridRes = 4 ;(2=8th notes, 4=16th notes, 8=32nd notes, etc)

girandomBPM init 0
gibpm init 0
giBeatsPerSec init 0

schedule 1, 0, 10000 ;prime globals
schedule 97, 0, 10000 ;prime mixer

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
gikicksustain random 0.5, 2.0
gikickfreq random 30, 80 ;kick freq
gikickres random 0, 0.5 ;kick resonance

;;kick attack values
giatkdur random 0.15, 0.005 ; kick attack duration
giatkfreq random 80, 200 ;kick attack freq
giatklvl random 0.4, 0.8 ;attack portion level

;;snare values generation
gisnarefreq random 100, 500
gioscfreq random 200, 1000 ;primary snare freq
gisnaredur random 0.05, 0.5 
gisnareatk random gisnaredur*0.25, 0.15 ;snare attack dur
gisnarefiltinit random 5000, 10000
gisnarefiltsus random 1000, 500
gisnareres random 0.2, 0.7
gisnpenvinit random gioscfreq, 10000 ; choose p env init from freq val
gisnpenvdur random gisnaredur*.25, gisnaredur ;pith env duration
giSnaremeth random 0.2, 0.9

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

MixerSend afilteredsig*chnget("BD"), 2, 97, 0

endin

instr snare1, 4
ifn  = gi1
irandomAmp=random(0.1, 0.5)*chnget("SD1")
kamp expseg irandomAmp, gisnaredur, 0.001
kampNoise expseg irandomAmp, gisnaredur*0.5, 0.001 ;make noise portion 1/2 length of snare
ksnpenv expseg gisnpenvinit, gisnpenvdur, 0.001 ; snare pitch envelope
asnare oscili kamp, gisnarefreq, ifn
kfiltenv expseg gisnarefiltinit, gisnareatk, gisnarefiltsus, gisnaredur-gisnareatk, gisnarefiltsus
anoise noise kampNoise, 0
afilteredsig moogvcf2 anoise + asnare, kfiltenv, gisnareres
MixerSend afilteredsig, 3, 97, 0


endin

instr snare2, 5
ifn  = gi1
irandomAmp=random(0.1, 0.5)*chnget("SD2")

iSnare2_rand1 random 0, 2
iSnare2_rand2 random 0, 1
iSnare2_rand3 random 0, 1

kamp expseg irandomAmp, gisnaredur*iSnare2_rand1, 0.001
ksnpenv expseg gisnpenvinit, gisnpenvdur*iSnare2_rand2, 0.001 ; snare pitch envelope
asig oscili kamp, gisnarefreq*iSnare2_rand3, ifn
asnare pluck kamp, gisnarefreq*iSnare2_rand1, gisnarefreq, 0, 3, giSnaremeth
kfiltenv expseg gisnarefiltinit, gisnareatk, gisnarefiltsus, gisnaredur-gisnareatk, gisnarefiltsus

afilteredsig moogvcf2 asig + asnare, kfiltenv, gisnareres

MixerSend afilteredsig, 4, 97, 0



endin

instr hats, 6
irandomAmp=random(0.1, 0.3)*chnget("HH")
;decide whether "closed" or "open" hat
iclosedOrOpen random 0,1
ihatdecay = iclosedOrOpen > 0.9 ? gihatsdecaylong : gihatsdecayshort
ifn  = gi5 ;noise 
kamp linseg irandomAmp, ihatdecay, 0.001
ahat1 oscili kamp, gihatsfreq1, ifn
ahat2 oscili kamp, gihatsfreq2, ifn

;SHOULD PROB CHANGE SAMPLE & HOLD DURS TO MATCH NOTE LENGTH!!!

if gihatmod > 0.5 then
	kmodfreq randomh 500, -600, 0.2, 3
	else
	kmodfreq = 1
endif

alow, ahigh, aband svfilter ahat1 + ahat2, gihatbpf + kmodfreq, 100 

MixerSend ahat1 + ahat2, 5, 97, 0


endin 

instr mixer, 97
;;mixer receive section

	amix MixerReceive 97, 0
	a1 limit amix, -0.6, 0.6 ;limit weird shit
	outs a1, a1
	MixerClear

endin


instr drumsSeq, 98
;densities

giKickdensity = 1-(chnget("DensBD"))
giSnaredensity = 1-(chnget("DensSD"))
giHatsdensity = 1-(chnget("DensHH"))


giKickdensity random 0.7,0.9  ;0 is more dense, 1 is less - default 0.7,0.9
giSnaredensity random 0.6,0.9  ;0 is more dense, 1 is less - default 0.6,0.9
giHatsdensity random 0.3,0.7  ;0 is more dense, 1 is less - default 0.3,0.7


iGridRes1 = giBeatsPerSec * giMasterGridRes
ktrig metro iGridRes1 ;metronome triggers 16th notes

if ktrig = 1 then
	;make random values for voice that decide against density value
	kKickDecider random 0, 1
	kSnare1Decider random 0, 1
	kSnare2Decider random 0, 1
	kHatDecider random 0, 1
	
	if kKickDecider > giKickdensity then
		event "i", 3, 0, iGridRes1
	endif
	
	if kSnare1Decider > giSnaredensity then
		event "i", 4, 0, iGridRes1		
	endif
	
	if kSnare2Decider > giSnaredensity then
		event "i", 5, 0, iGridRes1		
	endif
	
	if kHatDecider > giHatsdensity then
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
Sfilename strcat Sfilename,Stitle 
Sfilename strcat  Sfilename, ".wav"
fout Sfilename, 18, allL, allR 

endin


</CsInstruments>
<CsScore> 
</CsScore>
</CsoundSynthesizer>
