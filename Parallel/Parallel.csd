<Cabbage>
;Parallel Prototype 1.0.0

form caption("Parallel") size(300, 270), pluginid("8110")
#define KNOB1 outlinecolour(30,30,30,50) trackercolour(30,30,30,220), trackerthickness (0.2), style ("normal"), trackeroutsideradius(1), trackerinsideradius (0.01), colour(30, 30, 30, 255), textcolour(30,30,30,220), popuptext(0)

image bounds(0, 0, 300, 270), colour(50,50,50), file("parallel-bg.png")

rslider bounds(10, 115, 80, 80),channel("Depth"), text("DEPTH"), range(0.001, 0.999, 0.5, 1, 0.001)  $KNOB1 ;, trackercolour(77,190,250, 250)

combobox bounds(25, 200, 60, 20), channel("Wave"), text("TRI", "SQUARE", "SAW") colour(30,30,30,0), fontcolour (30,30,30,220)
rslider bounds(100, 115, 80, 80),channel("Split"), text("SPLIT"), range(0.0, 1, 0.05, 1, 0.001) $KNOB1 ;, trackercolour(244,236,9,200)
rslider bounds(190, 115, 80, 80),channel("Offset"), text("OFFSET"), range(0.0, 1, 0.05, 1, 0.001) $KNOB1 ;, trackercolour(244,236,9,200)


</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 -m0d
</CsOptions>
<CsInstruments>
ksmps = 64
nchnls = 2
0dbfs = 1

instr 1
kwave chnget "Wave"
kdepth chnget "Depth"
koffset chnget "Offset"
kshift chnget "Split"
koffset scale koffset, 2,0
kshift scale kshift, 0.5, 0

	ainL		inch     1               ; read audio from live input channel 1
    ainR		inch     2               ; read audio from live input channel 2
	
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
    kDelayGain = kDelayGain<1 ? kDelayGain+.0001 : 1
    ;delay method 
    aDelSpeedl = 5*abs(aspeedmodl) ;speed is modulated by LFO
    aDelSpeedr = 5*abs(aspeedmodr) 
    aDelayL vdelay ainL, aDelSpeedl+(koffset*1000), 1001 ;and then controls delay time
    aDelayR vdelay ainR, aDelSpeedr+(koffset*1000), 1001 ;add offset time to delay time (everything in ms)
    
 
    ;add feedback
    aDelMixL = (ainL*0.5)+(aDelayL*kDelayGain)
    aDelMixR = (ainR*0.5)+(aDelayR*kDelayGain)

abalL balance aDelMixL, ainL
abalR balance aDelMixR, ainR
outs abalL, abalR


endin

</CsInstruments>

<CsScore>
i1 0 500000
</CsScore>
</CsoundSynthesizer>
