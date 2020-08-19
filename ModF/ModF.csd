<Cabbage>
;Raze Prototype Version 1.0.0
; Modulating Crossover Fuzz
form caption("Raze") size(300, 300), pluginid("9017")
#define KNOB1 outlinecolour(48,54,44,255) trackercolour(235,228,218,230), trackerthickness (0.2), style ("normal"), trackeroutsideradius(1), trackerinsideradius (0.01), colour(210, 215, 211, 255), textcolour(235,228,218,230), popuptext(0)
image bounds(0, 0, 300, 400), colour(41,40,43), file("raze-bg.png")


{

; DELAY

rslider bounds(10, 100, 80, 80), channel("amp"), text("Amp"), range(0, 1, 0.5, 0.5, 0.001)  $KNOB1, trackercolour (250,115,73), outlinecolour(250,115,73,100)
rslider bounds(10, 200, 80, 80), channel("freq"), text("Freq"), range(0, 400, 200, 0.5, 1),  $KNOB1, trackercolour(247, 202, 24), trackercolour (250,115,73), outlinecolour(250,115,73,100)

; WINDOW

rslider bounds(100, 100, 80, 80), channel("fm"), text("FM"), range(0, 1000, 100, 1, 1)  $KNOB1, trackercolour(255, 255, 255), outlinecolour(255,255,255,100)
rslider bounds(100, 200, 80, 80), channel("index"), text("INDEX"), range(0.0, 20, 1, 1, 1)  $KNOB1,  trackercolour(255, 255, 255), outlinecolour(255,255,255,100)

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

;giRecBuf1L ftgen	0,0,131072,2,0 ; 3 seconds at 44.1 khz
;giRecBuf1R ftgen	0,0,131072,2,0
giexptable ftgen 0,0,129,5,1,100,0.0001,29 

/* ar ModFM kamp,kfc,kfm,kndx,ifn1,ifn2,imax
   ifn1 is a sine wave
   ifn2 is an exponential between 0 and -imax
*/
opcode ModFM,a,kkkkiii

 kamp,kfc,kfm,kndx,isin,iexp,imx xin
 acar oscili kamp,kfc,isin,0.25
 acos oscili 1,kfm,isin,0.25
 amod table  -kndx*(acos-1)/imx,iexp,1
     xout acar*amod

endop 

instr 1

kamp chnget "amp"
kfc chnget "freq"
kfm chnget "fm"
kndx chnget "index"
kmix chnget "Mix"

iexp = giexptable
imx = 0.4

asig ModFM kamp, kfc, kfm, kndx, -1, iexp, imx
outs asig, asig
endin
</CsInstruments>

<CsScore>

i1 0 500000

</CsScore>
</CsoundSynthesizer>
