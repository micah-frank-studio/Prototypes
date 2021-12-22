<Cabbage>
;Darklands Lite

form caption("Darklands LE") size(300, 300), pluginid("9017")
#define KNOB1 outlinecolour(100,100,100) trackercolour(100,100,100,230), trackerthickness (0.2), style ("normal"), trackeroutsideradius(1), trackerinsideradius (0.01), colour(100, 100, 100, 100), textcolour(150,150,150,150), popuptext(0)
image bounds(0, 0, 300, 400), colour(40,40,40), file("darklandsLE-bg.png")


{
;rslider bounds(10, 200, 80, 80), channel("Freq"), text("FREQ"), range(0, 400, 200, 0.5, 1),  $KNOB1
rslider bounds(100, 100, 80, 80), channel("FM"), text("FM"), range(1, 1000, 100, 1, 1)  $KNOB1 
rslider bounds(100, 200, 80, 80), channel("Index"), text("INDEX"), range(1, 20, 1, 1, 1)  $KNOB1
rslider bounds(10, 435, 80, 80), channel("Onset"), text("ONSET"), range(0, 6, 1, 1, 0.001) $KNOB1 
rslider bounds(105, 435, 80, 80), channel("Trail"), text("TRAIL"), range(0, 6, 1, 1, 0.001) $KNOB1 
; MIX
;rslider bounds(200, 200, 80, 80), channel("Mix"), text("MIX"), range(0.00, 1, 0.5, 1, 0.001), identchannel ("mixident"), $KNOB1
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
;midi pitchbend
kpb init 0
midipitchbend kpb
koct =	p4+kpb					;add pitchbend values to octave-point-decimal value
kcps =	cpsoct(koct)				;convert octave-point-decimal value into Hz
iattack chnget "Onset"
irel  chnget "Trail"
kenv madsr iattack, 0.01, 1, irel
inote notnum 
kamp chnget "Amp"
kfc chnget "Freq"
kfm chnget "FM"
kndx chnget "Index"
kmix chnget "Mix"

iexp = giexptable
imx = 0.4

asig ModFM kenv*p5, kcps, kfm, kndx, -1, iexp, imx

outs asig, asig

endin
</CsInstruments>

<CsScore>

;i1 0 500000

</CsScore>
</CsoundSynthesizer>
