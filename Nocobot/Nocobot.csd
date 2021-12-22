/*

PROTOTYPE | Nocobot | Glitch Percussion Generator
by Micah Frank 2020		

*/

<Cabbage>
;Nocobot Prototype 1.0.1

form caption("Nocobot") size(354, 345), pluginId("2901")
image bounds(0, 0, 354, 345), colour(255, 255, 255) file("nocobot-bg.png")
nslider bounds(10, 98, 70, 50), channel("Amount"), text("HOW MANY?"), range(0, 127, 60, 1, 1), textColour(19, 19, 19), fontColour(255, 255, 255), velocity(100)
rslider bounds(210, 90, 70, 70),channel("MaxLength"), text("MAX LENGTH"), range(0.01, 2, 0.5, 1, 0.01), outlineColour(30,30,30,50) trackerColour(0,0,0,220), trackerThickness (0.2), style ("normal"), trackerOutsideRadius(1), trackerInsideRadius (0.01), colour(0, 0, 0), textColour(0,0,0)
button bounds(390, 98, 100, 50), latched(0), channel("Stop"), text("STOP!"),identChannel("stopIdent"), fontColour(255, 255, 255), colour:0(19, 19, 19, 255)
filebutton bounds(100, 98, 100, 50), channel("Directory"), text("RUN"),identChannel("blastIdent"), mode("directory"), fontColour(255, 255, 255), colour:0(19, 19, 19, 255)
csoundoutput bounds(10, 166, 331, 170), colour("19,19,19"),fontColour(255, 255, 255)
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
gimaxlen chnget "MaxLength"
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

;perc sustain values
gipercsustain random 0.01, gimaxlen ; generates sustain between 0.01 and max length set
gipercfreq random 50, 300 ; freq
gipercres random 0, 0.3 ; resonance. Careful!
ginitpitch random 0.1, 1 ;pitch env init point (factor of gipercfreq 0.0 - 1.0)
giPDecayFactor random 0.01, 0.3 ;pitch decay (factor of gipercsustain 0.0 - 1.0)

;perc attack values
giatkdur random 0.005, gipercsustain*0.5 ; perc attack duration. At most, half of total sustain
giatkfreq random 50, 400 ;perc attack freq - default 50, 400
giatklvl random 0.01, 0.5 ;attack portion level - default 0.1, 0.5
giFilterInit random 200, 3000
giFilterEnd random 20, 1000
gSatrb strcpy "/nocobot-" ;file descriptor prefix (e.g. "long-", "perc-Jan12-" etc..)

prints "\n reset. new Noco generating...\n"
;prints "perc length is %f seconds\n", gipercsustain

giGenerations chnget "Amount" ;define how many percs to generate
ktime init 0
ktime timeinsts 

if gicounter < giGenerations then
		if ktime > gipercsustain then ;reset when elapsed time is greater than steps
		schedule 98, 0, gipercsustain ;prime sequencer
		schedule 100, 0, gipercsustain ; prime recorder
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
        prints "Nocobot ended \n"
	    turnoff		
endif


endin

instr perc, 3

;perc sustain waveform array and selection
ihasatk = round(random(0,1)) > 0 ? 1 : 0.001
ihasfilt = round(random(0,1)) > 0 ? 1 : 0.001 

ipercSusArray[] fillarray gi1, gi4, gi5, gi6, gi7
ipercArrayselect1 random 0,4
ipercSelection1 = ipercSusArray[round(ipercArrayselect1)]

;perc attack waveform array and selection
ipercAtkArray[] fillarray gi1, gi4, gi5, gi6, gi7
ipercAtkSelect1 random 0,4
ipercAtkSelection1 = ipercAtkArray[round(ipercAtkSelect1)]

;;perc sustain
isuswave  =  ipercSelection1 ;choose waveform
kpenv expseg ginitpitch, giatkdur, 1, (gipercsustain-giatkdur)*giPDecayFactor, 0.001  ;modulate pitch.

kamp expseg 0.9, gipercsustain, 0.001

;;perc attack
iatkwave = ipercAtkSelection1 ; attack wave
katkenv expseg giatklvl, giatkdur, 0.001 ;attack envelope

asus oscili kamp, gipercfreq*kpenv, isuswave
aatk oscili katkenv, giatkfreq, iatkwave

kfiltenv expseg giFilterInit, gipercsustain*0.25, abs(giFilterInit-(giFilterEnd*ihasatk))

if ihasfilt == 1 then
    afilteredsig moogvcf2 asus+aatk, kfiltenv, gipercres
else
    afilteredsig = asus + aatk
endif

a1 limit afilteredsig, -0.9, 0.9 ;limiter

chnset a1, "percout"

endin


instr drumsSeq, 98
ktrig metro 1/gipercsustain

if ktrig = 1 then
		event "i", 3, 0, gipercsustain	
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

aout1 chnget "percout"
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