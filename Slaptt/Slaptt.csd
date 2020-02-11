/*

PROROTYPE | Slaptt
by Micah Frank 2020		

*/

<Cabbage>
;Kickblast Version 1.0.1

form caption("Slaptt") size(354, 345), pluginid("1737")
image bounds(0, 0, 354, 345), colour(130, 204, 221) file("kickblast-bg.png")
;texteditor bounds(10, 10, 331, 40), channel("textEditor1"), text("PROTOTYPE | KICKBLAST /n MICAH FRANK 2020"), colour("19,19,19"),fontcolour("130, 204, 221")
nslider bounds(10, 98, 70, 50), channel("Amount"), text("HOW MANY?"), range(0, 127, 60, 1, 1), textcolour(19, 19, 19), fontcolour(250, 246, 149), velocity(100)
button bounds(390, 98, 100, 50), latched(0), channel("Stop"), text("STOP!"),identchannel("stopIdent"), fontcolour(250, 246, 149), colour:0(19, 19, 19, 255)
filebutton bounds(100, 98, 100, 50), channel("Directory"), text("BLAST!"),identchannel("blastIdent"), mode("directory"), fontcolour(250, 246, 149), colour:0(19, 19, 19, 255)
csoundoutput bounds(10, 166, 331, 170), colour("19,19,19"),fontcolour(250, 246, 149)
</Cabbage>
 
<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 -m0d 
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 128
nchnls = 1
0dbfs = 1.0


seed 0 
;;function tables
gi1 ftgen 1,0,129,10,1 ;sine
gi2 ftgen 2,0,129,10,1,0,1,0,1,0,1,0,1 ;odd partials
gi3 ftgen 3, 0, 16384, 10, 1, 0 , .33, 0, .2 , 0, .14, 0 , .11, 0, .09 ;odd harmonics
gi4 ftgen 4, 0, 16384, 10, 0, .2, 0, .4, 0, .6, 0, .8, 0, 1, 0, .8, 0, .6, 0, .4, 0,.2 ; saw
gi5 ftgen 5,0,129,21,1 ;white noise
gi6 ftgen 7,0,129,9,.5,1,0 ;half sine
gi7 ftgen     0, 0, 2^10, 10, 1, 0, -1/9, 0, 1/25, 0, -1/49, 0, 1/81

instr 1
gSdir chnget "Directory"
kstop chnget "Stop"
kstrlen strlenk gSdir

if (changed(gSdir)== 1) && (kstrlen != 0) then
    event "i", 2, 0, 300
endif
    
    if kstop==1 then
        turnoff2 2, 0, 0
        SStopMessage = "bounds(1000, 98, 100, 50)"
        chnset SStopMessage, "stopIdent"
        SBlastMessage = "bounds(100, 98, 100, 50)"
        chnset SBlastMessage, "blastIdent"
        chnset "", "Directory"
    endif  
endin

instr settings, 2
gicounter init 0
reset:

;; QUICK PARAMETERS

;kick sustain values
gikicksustain random 1, 0.01 ;generates kick btwn 0.5 & 2 sec long. Try long values (~4 sec) for some interesting results
gikickfreq random 50, 1000 ;kick freq
gikickres random 0, 0.3 ;kick resonance. Careful!
ginitpitch random 0.1, 3 ;pitch env init point (factor of gikickfreq 0.0 - 1.0)
giPDecayFactor random 0.01, 0.9 ;pitch decay (factor of gikicksustain 0.0 - 1.0)

;kick attack values
giatkdur random 0.005, gikicksustain ; kick attack duration - default 0.015, 0.005
giatkfreq random 50, 400 ;kick attack freq - default 50, 400
giatklvl random 0.01, 0.5 ;attack portion level - default 0.1, 0.5
giFilterInit random 200, 3000
giFilterEnd random 20, 1000
gSatrb strcpy "/slaptt-" ;file descriptor prefix (e.g. "long-", "kick-Jan12-" etc..)

prints "\n reset. new Slaptt generating...\n"
;prints "kick length is %f seconds\n", gikicksustain

giGenerations chnget "Amount" ;define how many kicks to generate
ktime init 0
ktime timeinsts 

if gicounter < giGenerations then
		if ktime > gikicksustain then ;reset when elapsed time is greater than steps
		schedule 98, 0, gikicksustain ;prime sequencer
		schedule 100, 0, gikicksustain ; prime recorder
		gicounter += 1
		reinit reset
		SStopMessage = "bounds(100, 98, 100, 50)"
        chnset SStopMessage, "stopIdent"
        SBlastMessage = "bounds(1000, 98, 100, 50)"
        chnset SBlastMessage, "blastIdent"
		endif
	else
	    SStopMessage = "bounds(1000, 98, 100, 50)"
        chnset SStopMessage, "stopIdent"
        SBlastMessage = "bounds(100, 98, 100, 50)"
        chnset SBlastMessage, "blastIdent"
        chnset "", "Directory"
        prints "Kickblast ended \n"
	    turnoff		
endif


endin

instr kick, 3

;kick sustain waveform array and selection
ihasatk = round(random(0,1)) > 0 ? 1 : 0.001
ikickSusArray[] fillarray gi1, gi2, gi3, gi4, gi5, gi6, gi7
ikickArrayselect1 random 0,6
iKickSelection1 = ikickSusArray[round(ikickArrayselect1)]

;kick attack waveform array and selection
ikickAtkArray[] fillarray gi1, gi2, gi3, gi4, gi5, gi6, gi7
ikickAtkSelect1 random 0,6
iKickAtkSelection1 = ikickAtkArray[round(ikickAtkSelect1)]

;;kick sustain
isuswave  =  iKickSelection1 ;choose waveform
kpenv expseg ginitpitch, giatkdur, 1, (gikicksustain-giatkdur)*giPDecayFactor, 0.01  ;modulate pitch.

kamp expseg 0.9, gikicksustain, 0.001

;;kick attack
iatkwave = iKickAtkSelection1 ; attack wave
katkenv expseg giatklvl, giatkdur, 0.01 ;attack envelope

asus oscili kamp, gikickfreq*kpenv, isuswave
aatk oscili katkenv, giatkfreq, iatkwave

kfiltenv expseg giFilterInit, gikicksustain*0.25, abs(giFilterInit-(giFilterEnd*ihasatk))

afilteredsig moogvcf2 asus+(aatk*ihasatk), kfiltenv, gikickres

a1 limit afilteredsig, -0.9, 0.9 ;limiter

chnset a1, "kickout"

endin


instr drumsSeq, 98
ktrig metro 1/gikicksustain

if ktrig = 1 then
		event "i", 3, 0, gikicksustain	
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

aout1 chnget "kickout"
outs aout1, aout1

;;file writing
Sfilepath strcat gSdir, gSatrb
Sfilename strcat Sfilepath, Stitle 
Sfilename strcat Sfilename, ".wav"
fout Sfilename, 18, aout1 ;24-bit wav
prints Sfilename

endin


</CsInstruments>
<CsScore> 
i1 0 500000
</CsScore>
</CsoundSynthesizer>