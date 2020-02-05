<Cabbage>
;Parallel Prototype 1.0.0

form caption("Parallel") size(410, 511), pluginid("8110")
#define KNOB1 outlinecolour(30,30,30,50) trackercolour(30,30,30,220), trackerthickness (0.2), style ("normal"), trackeroutsideradius(1), trackerinsideradius (0.01), colour(30, 30, 30, 255), textcolour(183,183,183), popuptext(0)

image bounds(0, 0, 410, 511), colour(50,50,50), file("parallel-bg.png")

rslider bounds(10, 215, 80, 80),channel("Depth"), text("DEPTH"), range(0.001, 0.999, 0.55, 1, 0.001)  $KNOB1 ;, trackercolour(77,190,250, 250)
rslider bounds(110, 215, 80, 80),channel("Speed"), text("SPEED"), range(0.001, 0.999, 0.5, 1, 0.001)  $KNOB1 ;, trackercolour(77,190,250, 250)

combobox bounds(222, 295, 60, 20), channel("Wave"), text("TRI", "SQUARE", "SAW") colour(72,72,72,0), fontcolour (212, 216, 216)
rslider bounds(40, 330, 80, 80),channel("Shift"), text("SHIFT"), range(0.0, 1, 0.05, 1, 0.001) $KNOB1 ;, trackercolour(244,236,9,200)
rslider bounds(140, 330, 80, 80),channel("Offset"), text("OFFSET"), range(0.0, 1, 0.05, 1, 0.001) $KNOB1 ;, trackercolour(244,236,9,200)
rslider bounds(240, 330, 80, 80),channel("Mix"), text("MIX"), range(0, 1, 0.8, 1, 0.001) $KNOB1 ;, trackercolour(247,63,6, 180)
rslider bounds(340, 350, 60, 60),channel("Output"), text("OUTPUT"), range(0, 2, 1, 1, 0.001) $KNOB1 ;, trackercolour(247,63,6, 180)

</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 -m0d --displays
</CsOptions>
<CsInstruments>
ksmps = 64
nchnls = 2
0dbfs = 1

;giRecBuf1L ftgen	0,0,131072,2,0 ; 3 seconds at 44.1 khz
;giRecBuf1R ftgen	0,0,131072,2,0
;giwin ftgen 1, 0, 8192, 20, 2, 1  ;Hanning window
   
instr 1
kdelay chnget "Depth"
kwave chnget "Wave"
kdepth chnget "Speed"
ktone chnget "Tone"
koffset chnget "Offset"
kmix chnget "Mix"
kspeed scale kdelay, 5, 0.001
kshift chnget "Shift"
kout chnget "Output"
kdepth scale kdepth, 5, 0.01
koffset scale koffset, 2,0
ktone scale ktone, 10000, 200
kshift scale kshift, 1, 0
aspeed interp kspeed

;itablelength = ftlen(giRecBuf1L)
;imaxlength = itablelength/sr ; get table length in seconds
	ainL		inch     1               ; read audio from live input channel 1
    ainR		inch     2               ; read audio from live input channel 2
	
  ainL, ainR diskin "../../Repo/puremagnetik_plugins/testSounds/stereocheck.wav", 1, 0, 1

if kwave == 1 then
    kspeedmodl lfo 1, kdepth, 1
    kspeedmodr lfo 1, kdepth+kshift, 1
elseif kwave == 2 then
    kspeedmodl lfo 1, kdepth, 3
    kspeedmodr lfo 1, kdepth+kshift, 3
elseif kwave == 3 then
    kspeedmodl lfo 1, kdepth, 4
    kspeedmodr lfo 1, kdepth+kshift, 4
endif

kspeedmodlp portk, kspeedmodl, 0.05 ;smooth out lfos
kspeedmodrp portk, kspeedmodr, 0.05 

aspeedmodl interp kspeedmodlp ;convert lfos to a-rate
aspeedmodr interp kspeedmodrp
;mute for delay line to avoid noice when changing delay in realtime
    if changed:k(koffset) == 1 then
        kDelayGain = 0
    endif
   
    ;delay method 
    aDelSpeedl = aspeed*abs(aspeedmodl) ;speed is modulated by LFO
    aDelSpeedr = aspeed*abs(aspeedmodr) 
    aDelayL vdelay ainL, aDelSpeedl+(koffset*1000), 1001 ;and then controls delay time
    aDelayR vdelay ainR, aDelSpeedr+(koffset*1000), 1001 ;add offset time to delay time (everything in ms)
 
    kDelayGain = kDelayGain<1 ? kDelayGain+.0001 : 1
    ;add feedback
    aDelMixL = (ainL*0.5)+(aDelayL*kmix*0.5)
    aDelMixR = (ainR*0.5)+(aDelayR*kmix*0.5)


abalL balance aDelMixL, ainL
abalR balance aDelMixR, ainR
outs abalL*kout, abalR*kout



endin

</CsInstruments>

<CsScore>
i1 0 500000
</CsScore>
</CsoundSynthesizer>
