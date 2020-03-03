<Cabbage>
;Echolift Prototype Version 1.0.0
form caption("Echolift") size(300, 300), pluginid("7899")
#define KNOB1 outlinecolour(48,54,44,255) trackercolour(235,228,218,230), trackerthickness (0.2), style ("normal"), trackeroutsideradius(1), trackerinsideradius (0.01), colour(210, 215, 211, 255), textcolour(235,228,218,230), popuptext(0)
image bounds(0, 0, 300, 400), colour(41,40,43), file("echolift-bg.png")


{

; DELAY

rslider bounds(10, 100, 80, 80), channel("Time"), text("TIME"), range(0.01, 3, 1, 1, 0.001)  $KNOB1, trackercolour (250,115,73), outlinecolour(250,115,73,100)
rslider bounds(10, 200, 80, 80), channel("Repeat"), text("REPEAT"), range(0.1, 0.9, 0.4, 1, 0.001),  $KNOB1, trackercolour(247, 202, 24), trackercolour (250,115,73), outlinecolour(250,115,73,100)

; WINDOW

rslider bounds(100, 100, 80, 80), channel("LiftSize"), text("LIFT SIZE"), range(0.001, 1, 0.26, 1, 0.001)  $KNOB1, trackercolour(255, 255, 255), outlinecolour(255,255,255,100)
rslider bounds(100, 200, 80, 80), channel("Stability"), text("STABILITY"), range(0.0, 8, 1, 1, 0.001)  $KNOB1,  trackercolour(255, 255, 255), outlinecolour(255,255,255,100)

; MIX
rslider bounds(200, 200, 80, 80), channel("Mix"), text("MIX"), range(0.00, 1, 0.5, 1, 0.001), identchannel ("mixident"), $KNOB1, trackercolour(97,138,183), outlinecolour(97,138,183, 100)
}

</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 -m0d --midi-key-oct=4 --midi-velocity-amp=5 --displays
</CsOptions>
<CsInstruments>
ksmps = 32
nchnls = 2
0dbfs = 1
seed 0

giRecBuf1L ftgen	0,0,131072,2,0 ; 3 seconds at 44.1 khz
giRecBuf1R ftgen	0,0,131072,2,0

opcode vardelay, aa, aakk ;audio in / audio out, delay time, feedback
	ainL, ainR, kDelayTime, kFeedback xin
	;mute for delay line to avoid noice when changing delay in realtime
    if changed:k(kDelayTime) == 1 then
        kDelayGain = 0
    endif

    ;delay method
    aDelayL vdelay ainL, kDelayTime*1000, 5001
    aDelayL = aDelayL*kDelayGain
    aDelayR vdelay ainR, kDelayTime*1000, 5001
    aDelayR = aDelayR*kDelayGain

    kDelayGain = kDelayGain<1 ? kDelayGain+.005 : 1
    ;add feedback
    aMixL = ainL+(aDelayL*kFeedback)
    aMixR=  ainR+(aDelayR*kFeedback)
	xout aMixL, aMixR

endop

instr 1

ktime chnget "Time"
krepeat chnget "Repeat"
kliftsize chnget "LiftSize"
kstability chnget "Stability"
kmix chnget "Mix"

itablelength = ftlen(giRecBuf1L)
imaxlength = itablelength/sr ; get table length in seconds
	ainL		inch     1               ; read audio from live input channel 1
    ainR		inch     2               ; read audio from live input channel 2

;	ainL    diskin "../../Repo/puremagnetik_plugins/testSounds/Guitar-06.aif",1,0,1


adelL, adelR vardelay ainL, ainR, ktime, krepeat

    isr = sr
	kndx = (1/(itablelength/isr)) ;speed calculation for phasor
	andx		phasor kndx
    tablew   adelL, andx, giRecBuf1L,1 ; write feedback loop to function table
    tablew   adelR, andx, giRecBuf1R,1

khold = randh(1, kstability*8)
ktri = abs(lfo(1, kstability))
kmod = kstability<0.5 ? ktri : khold ; if stability < 0.5 then tri lfo, otherwise sample & hold at increasing speed.

kplacement = imaxlength*kliftsize ;kplacement is a scaled version of kliftsize determined by imaxlength
kplacement = kplacement - (kplacement*kmod)
ksize = (kplacement + (imaxlength-kplacement)) * kliftsize + 0.01 ; window size starts from kplacement
kwindow = (kplacement + ksize) < imaxlength ? ksize : (imaxlength - ksize)+0.1 ; don't let kwindow go beyond total buffer
kloopend = kplacement + kwindow
kcrossfade = 0.04
kamp = 0.6

		;loop delay feedback buffer
		a1L flooper2 kamp, 1, kmod*kplacement, (kmod*kplacement)+kloopend, kcrossfade, giRecBuf1L
		a1R flooper2 kamp, 1, kmod*kplacement, (kmod*kplacement)+kloopend, kcrossfade, giRecBuf1R

arepL, arepR vardelay a1L, a1R, ktime*0.75, krepeat

amixL ntrpol ainL, arepL, kmix
amixR ntrpol ainR, arepR, kmix

outs amixL, amixR


endin
</CsInstruments>

<CsScore>

i1 0 500000

</CsScore>
</CsoundSynthesizer>
