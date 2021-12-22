/*

PROTOTYPE | Statics | 
by Micah Frank 2020		

*/

<Cabbage>
;Statics Prototype 1.0.1

form caption("Statics") size(354, 339), pluginId("5092")
image bounds(0, 0, 354, 339), colour(255, 255, 255) file("statics.png")
button bounds(20, 285, 55, 22), latched(1), text("LIKE", "UNLIKE"), channel("Like"),fontColour:0("0,0,0"), fontColour:1("0,0,0"), imgFile("off", "like.png"), imgFile("on", "unlike.png")
</Cabbage>
 
<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 -m0d --midi-key-cps=4 --midi-velocity-amp=5
</CsOptions>
<CsInstruments>

ksmps = 128
nchnls = 2
0dbfs = 1.0
massign 0, 1
allchannels[] init 6
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


opcode randoPan, aa, a
	ain xin
	kpan=gauss(0.5)
	asigL, asigR pan2 ain, 0.5+kpan
	xout asigL, asigR
endop

instr 1, voice1
ilike chnget "Like"
ifreq = p4 
irel = 0.05


if ilike < 1 then
ihum random 0, 1
gihum = ihum

ginoisesus=0.1-(gauss(0.1))
gisinsus=0.1-(gauss(0.1))
gipulsesus=0.1-(gauss(0.1))
gibeta random 0.2, 0.99
gidustdens random 1, 3
givcowave=round(random(1,4))
gifmwave=round(random(1,9))
gipulseFilter random 200, 5000
giresPulse random 0, 0.5 ; resonance. Careful!
gispulsemodulating = random(0,1)
gisinFilter random 200, 2000
giresSine random 0, 0.5; resonance. Careful!
gifmsus=0.2-(gauss(0.2))
gifmFilter random 200, 10000
giresFM random 0, 0.5; resonance. Careful!
ginoiseFilter random 100, 5000
ginoisefiltertype random 0, 1
gidustamp=linrand(0.3)
gitrempulse1=random(0,0.5)
gitrempulse2=random(0.01, 5)
gipulsemod1=random(0.01, 0.4)
gipulsemod2=random(0.001, 3)
gitremsin1=random(0,0.5)
gitremsin2=random(0.01, 5)
gimod=random(0.5, 10)
gindx=random(1, 3)
gitremfm1=random(0,0.5)
gitremfm2=random(0.01, 5)
else 
endif


gkdustamp madsr 0.005,0.001,gidustamp,irel 
gktrempulse=abs(lfo(gitrempulse1,gitrempulse2))
gkpulsemod=0.01+lfo(gipulsemod1,gipulsemod2) ; pulse mod 
gktremsin=abs(lfo(gitremsin1, gitremsin2))
gkmod=round(gimod)
gkndx=gindx
gktremfm=abs(lfo(gitremfm1,gitremfm2))

ksubenv linsegr 0.001,0.01,0.1,0.16,0.000 
ksubamp = gihum > 0.5 ? ksubenv : 0

knoiseamp madsr 0.005,0.2,ginoisesus,irel 

kfmamp madsr 0.005,0.2,gifmsus,irel 

ksinamp madsr 0.005,0.2,gisinsus,irel 

kpulseamp madsr 0.005,0.2,gipulsesus,irel 

kpmodamount=gispulsemodulating > 0.5 ? 1 : gkpulsemod ; is there pulse mod or is it static?
apulse vco2 (0.2-gktrempulse)*kpulseamp*p5, ifreq, 4, gkpulsemod
afilteredpulse moogvcf2 apulse, gipulseFilter, giresPulse
apulseL, apulseR randoPan afilteredpulse


asin oscili (0.2-gktremsin)*ksinamp*p5, ifreq, gi1
afilteredsin moogvcf2 asin, gisinFilter, giresSine
asinL, asinR randoPan afilteredsin


afm foscil (0.2-gktremfm)*kfmamp*p5, ifreq, 1, gkmod, gkndx, gifmwave
afilteredfm moogvcf2 afm, gifmFilter, giresFM
afmL, afmR randoPan afilteredfm

asub oscili ksubamp*p5, ifreq*0.25, gi1
anoise noise knoiseamp*0.1*p5, 0.0
afilterednoisehp butterhp anoise, ginoiseFilter, 0.1
afilterednoiselp butterlp anoise, ginoiseFilter, 0.1
afilterednoise = ginoisefiltertype >0.5 ? afilterednoisehp : afilterednoiselp
anoiseL, anoiseR randoPan afilterednoise

adust dust gkdustamp*0.5*p5, gidustdens

outs (asinL+afmL+asub+adust+anoiseL+apulseL), (asinR+afmR+asub+adust+anoiseR+apulseR)

endin
</CsInstruments>
<CsScore> 
</CsScore>
</CsoundSynthesizer>