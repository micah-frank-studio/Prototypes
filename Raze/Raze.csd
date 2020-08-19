<Cabbage>
;Raze Prototype Version 1.0.0
; Modulating Crossover Fuzz
form caption("Raze") size(285, 300), pluginid("4876")
#define KNOB1 outlinecolour(48,54,44,255) trackercolour(235,228,218,230), trackerthickness (0.2), style ("normal"), trackeroutsideradius(1), trackerinsideradius (0.01), colour(210, 215, 211, 255), textcolour(235,228,218,230)
image bounds(0, 0, 300, 400), colour(41,40,43), file("raze-bg.png")


{

; DELAY
combobox bounds(15, 80, 75, 20), channel("Mode"), text("TANGENT", "CHEBY"), colour(72,72,72,0), fontcolour (255, 255, 255) 
rslider bounds(10, 110, 80, 80), channel("Input"), text("INPUT"), range(0, 1, 0.5, 0.5, 0.001)  $KNOB1, trackercolour (0, 168, 255), outlinecolour(0, 168, 255, 100), popuptext(0)
rslider bounds(100, 110, 80, 80), channel("Amp"), text("AMP"), range(0, 1, 0.5, 1, 0.001)  $KNOB1, trackercolour (250,115,73), outlinecolour(250,115,73,100), popuptext(0)
rslider bounds(190, 110, 80, 80), channel("Xover"), text("XOVER"), range(80, 2000, 300, 0.5, 1),  $KNOB1, trackercolour (46, 213, 115), outlinecolour(46, 213, 115,100)
rslider bounds(10, 210, 80, 80), channel("Speed"), text("SPEED"), range(0, 1, 0.3, 0.7, 0.001)  $KNOB1, trackercolour(255, 255, 255), outlinecolour(255,255,255,100), popuptext(0)
rslider bounds(100, 210, 80, 80), channel("Amount"), text("AMOUNT"), range(0.0, 1, 0.1, 1, 0.001)  $KNOB1,  trackercolour(255, 255, 255), outlinecolour(255,255,255,100), popuptext(0)
rslider bounds(190, 210, 80, 80), channel("Blend"), text("BLEND"), range(0.0, 1, 0.7, 1, 0.001)  $KNOB1,  trackercolour(150, 150, 150), outlinecolour(150,150,150,100), popuptext(0)

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


gitan ftgen 0, 0, 1024, "tanh", -10, 10, 0

opcode chebmod, a, akkkkk
    ain, kamp, kamount, krate, kmode, kxover xin
    kmod lfo kamount, krate
    alowL, ahighL, abandL svfilter  ain, kxover-(kxover*kmod), 1 ;create a crossover for low end fuzz
   
    kpoly1 = kamp*0.01
    kpoly2 = kamp*0.01
    kpoly3 = kamp*0.07
    kpoly4 = kamp*0.1
    kpoly5 = kamp*0.12
    kpoly6 = kamp*0.36
    kpoly7 = kamp*0.4
    if kmode == 1 then
    ashape      chebyshevpoly  alowL, 0, kpoly1, kpoly2, kpoly3, kpoly4, kpoly5, kpoly6, kpoly7
    else
    ashape distort alowL, kamp*0.3, gitan
    endif
    amix = ashape + ahighL
    xout amix
endop

instr 1

kinput chnget "Input"
kamp chnget "Amp"
kmode chnget "Mode"
khz chnget "Speed"
kmod chnget "Amount"
kmix chnget "Mix"
kxover chnget "Xover"
kblend chnget "Blend"

ainL inch 1
ainR inch 2

khz scale khz, 100, 0.01
amixL chebmod ainL*kinput, kamp, kmod, khz, kmode, kxover
amixR chebmod ainR*kinput, kamp, kmod, khz, kmode, kxover

aL ntrpol ainL, amixL, kblend
aR ntrpol ainR, amixR, kblend

outs aL, aL
endin
</CsInstruments>

<CsScore>

i1 0 500000

</CsScore>
</CsoundSynthesizer>
