/*	
	Grainstation-C
	by Micah Frank 2020
	www.micahfrank.com
	https://github.com/micah.frank.studio	
*/

<Cabbage>
; Version 1.0.0
form caption("Grainstation-C") size(778, 715), pluginid("8209")
#define KNOB1 outlinecolour(48,54,44,50), trackercolour(86,240,196), trackerthickness (0.2), style ("normal"), trackeroutsideradius(1), trackerinsideradius (0.01), colour(210, 215, 211, 255), textcolour(50,50,50), popuptext(0)
#define KNOB2 outlinecolour(48,54,44,50), trackercolour(108, 92, 232, 255), trackerthickness (0.2), style ("normal"), trackeroutsideradius(1), trackerinsideradius (0.01), colour(210, 215, 211, 255), textcolour(50,50,50), popuptext(0)

image bounds(0, 0, 778, 715), file("grainstationc-bg.png")
signaldisplay bounds(0, 70, 778, 40), colour(0,0,0), backgroundcolour(42, 43, 43,0), displaytype("waveform"), signalvariable("adisplaymain"), zoom(-1)
;signaldisplay bounds(30, 88, 120, 40), colour(86,240,196), backgroundcolour(42, 43, 43,0), displaytype("waveform"), signalvariable("adisplay1"), zoom(-1)
;signaldisplay bounds(230, 88, 120, 40), colour(108, 92, 232), backgroundcolour(42, 43, 43,0), displaytype("waveform"), signalvariable("adisplay2"), zoom(-1)
;signaldisplay bounds(430, 88, 120, 40), colour(7,132,227), backgroundcolour(42, 43, 43,0), displaytype("waveform"), signalvariable("adisplay3"), zoom(-1)
;signaldisplay bounds(630, 88, 120, 40), colour(255, 119, 119, 255), backgroundcolour(42, 43, 43,0), displaytype("waveform"), signalvariable("adisplay4"), zoom(-1)

;CHANNEL 1
filebutton bounds(38, 138, 100, 20), populate(), text("SOURCE", "SOURCE"),identchannel("sourceIdent1"), file("samples/xpander_pad.wav"), channel("file1"),imgfile("On", "fileButton.png")imgfile("Off", "fileButton.png"), imgfile("On", "fileButton.png")imgfile("Off", "fileButton.png") fontcolour:0(48, 54, 44, 255)
rslider bounds(14, 172, 70, 70), channel("Pitch1"), text("PITCH"), range(-2, 2, 0.35, 1, 0.001)  $KNOB1 ;, trackercolour(77,190,250, 250)
rslider bounds(94, 174, 70, 70), channel("Stretch1"), text("STRETCH"), range(0.01, 2, 0.287, 1, 0.001) $KNOB1 
rslider bounds(14, 254, 70, 70), channel("Density1"), text("DENSITY"), range(2, 32, 8, 1, 0.001) $KNOB1 
rslider bounds(94, 254, 70, 70), channel("Size1"), text("SIZE"), range(0.1, 1, 0.43, 1, 0.001) $KNOB1
combobox bounds(24, 344, 50, 20), channel("Type1"), items("LPF", "HPF"), colour(50,50,50,0),fontcolour(7,132,227)
rslider bounds(14, 372, 70, 70), channel("Filter1"), text("FREQ"), range(200, 9000, 4000, 0.5, 0.001) $KNOB1 trackercolour(7,132,227)
rslider bounds(94, 372, 70, 70), channel("Time1"), text("TIME"), range(0.001, 2, 0.25, 1, 0.001) $KNOB2 
rslider bounds(14, 452, 70, 70), channel("Feedbk1"), text("FEEDBK"), range(0.001, 0.99, 0.25, 1, 0.001) $KNOB2 
rslider bounds(94, 452, 70, 70), channel("Pshift1"), text("PSHIFT"), range(0.001, 1, 0.25, 1, 0.001) $KNOB2
rslider bounds(94, 532, 70, 70), channel("Amount1"), text("AMOUNT"), range(0.001, 0.7, 0.65, 1, 0.001) $KNOB2 
rslider bounds(14, 620, 70, 70), channel("Reverb1"), text("REVERB"), range(0, 1, 0.25, 1, 0.001) $KNOB1 trackercolour(255, 119, 119, 255) trackerinsideradius(0.01) trackerthickness(0.2)
rslider bounds(94, 620, 70, 70), channel("Volume1"), text("VOLUME"), range(0, 0.3, 0.12, 1, 0.001) $KNOB1 colour(210, 215, 211, 255) outlinecolour(48, 54, 44, 50) popuptext("0") style("normal") textcolour(50, 50, 50, 255) trackercolour(50, 50, 50, 255) trackerinsideradius(0.01) trackerthickness(0.2)

;CHANNEL 2
filebutton bounds(238, 138, 100, 20), populate(), text("SOURCE", "SOURCE"),identchannel("sourceIdent2"), file("samples/bowbounce.wav"), channel("file2"),imgfile("On", "fileButton.png")imgfile("Off", "fileButton.png"), imgfile("On", "fileButton.png")imgfile("Off", "fileButton.png") fontcolour:0(48, 54, 44, 255)
rslider bounds(214, 172, 70, 70), channel("Pitch2"), text("PITCH"), range(-2, 2, -0.1, 1, 0.001)  $KNOB1 ;, trackercolour(77,190,250, 250)
rslider bounds(294, 174, 70, 70), channel("Stretch2"), text("STRETCH"), range(0.01, 2, 0.3, 1, 0.001) $KNOB1 
rslider bounds(214, 254, 70, 70), channel("Density2"), text("DENSITY"), range(2, 32, 28, 1, 0.001) $KNOB1 
rslider bounds(294, 254, 70, 70), channel("Size2"), text("SIZE"), range(0.1, 1, 0.83, 1, 0.001) $KNOB1
combobox bounds(224, 344, 50, 20), channel("Type2"), items("LPF", "HPF"), colour(50,50,50,0),fontcolour(7,132,227)
rslider bounds(214, 372, 70, 70), channel("Filter2"), text("FREQ"), range(200, 9000, 3080, 0.5, 0.001) $KNOB1 trackercolour(7,132,227)
rslider bounds(294, 372, 70, 70), channel("Time2"), text("TIME"), range(0.001, 2, 0.9, 1, 0.001) $KNOB2 
rslider bounds(214, 452, 70, 70), channel("Feedbk2"), text("FEEDBK"), range(0.001, 0.99, 0.25, 1, 0.001) $KNOB2 
rslider bounds(294, 452, 70, 70), channel("Pshift2"), text("PSHIFT"), range(0.001, 1, 0.25, 1, 0.001) $KNOB2
rslider bounds(294, 532, 70, 70), channel("Amount2"), text("AMOUNT"), range(0.001, 0.7, 0.25, 1, 0.001) $KNOB2 
rslider bounds(214, 620, 70, 70), channel("Reverb2"), text("REVERB"), range(0, 1, 0.4, 1, 0.001) $KNOB1 trackercolour(255, 119, 119, 255) trackerinsideradius(0.01) trackerthickness(0.2)
rslider bounds(294, 620, 70, 70), channel("Volume2"), text("VOLUME"), range(0, 0.3, 0.09, 1, 0.001) $KNOB1 colour(210, 215, 211, 255) outlinecolour(48, 54, 44, 50) popuptext("0") style("normal") textcolour(50, 50, 50, 255) trackercolour(50, 50, 50, 255) trackerinsideradius(0.01) trackerthickness(0.2)
;keyboard bounds(8, 0, 381, 95)

;CHANNEL 3
filebutton bounds(438, 138, 100, 20), populate(), text("SOURCE", "SOURCE"),identchannel("sourceIdent3"), file("samples/ice.wav"), channel("file3"),imgfile("On", "fileButton.png")imgfile("Off", "fileButton.png"), imgfile("On", "fileButton.png")imgfile("Off", "fileButton.png") fontcolour:0(48, 54, 44, 255)
rslider bounds(414, 172, 70, 70), channel("Pitch3"), text("PITCH"), range(-2, 2, 0.17, 1, 0.001)  $KNOB1 ;, trackercolour(77,190,250, 250)
rslider bounds(494, 174, 70, 70), channel("Stretch3"), text("STRETCH"), range(0.01, 2, 1.56, 1, 0.001) $KNOB1 
rslider bounds(414, 254, 70, 70), channel("Density3"), text("DENSITY"), range(2, 32, 25, 1, 0.001) $KNOB1 
rslider bounds(494, 254, 70, 70), channel("Size3"), text("SIZE"), range(0.1, 1, 0.5, 1, 0.001) $KNOB1
combobox bounds(424, 344, 50, 20), channel("Type3"), items("LPF", "HPF"), colour(50,50,50,0),fontcolour(7,132,227)
rslider bounds(414, 372, 70, 70), channel("Filter3"), text("FREQ"), range(200, 9000, 4000, 0.5, 0.001) $KNOB1 trackercolour(7,132,227)
rslider bounds(494, 372, 70, 70), channel("Time3"), text("TIME"), range(0.001, 2, 0.25, 1, 0.001) $KNOB2 
rslider bounds(414, 452, 70, 70), channel("Feedbk3"), text("FEEDBK"), range(0.001, 0.99, 0.25, 1, 0.001) $KNOB2 
rslider bounds(494, 452, 70, 70), channel("Pshift3"), text("PSHIFT"), range(0.001, 1, 0.25, 1, 0.001) $KNOB2
rslider bounds(494, 532, 70, 70), channel("Amount3"), text("AMOUNT"), range(0.001, 0.7, 0.25, 1, 0.001) $KNOB2 
rslider bounds(414, 620, 70, 70), channel("Reverb3"), text("REVERB"), range(0, 1, 0.4, 1, 0.001) $KNOB1 trackercolour(255, 119, 119, 255) trackerinsideradius(0.01) trackerthickness(0.2)
rslider bounds(494, 620, 70, 70), channel("Volume3"), text("VOLUME"), range(0, 0.3, 0.09, 1, 0.001) $KNOB1 colour(210, 215, 211, 255) outlinecolour(48, 54, 44, 50) popuptext("0") style("normal") textcolour(50, 50, 50, 255) trackercolour(50, 50, 50, 255) trackerinsideradius(0.01) trackerthickness(0.2)

;CHANNEL 4
filebutton bounds(638, 138, 100, 20), populate(), text("SOURCE", "SOURCE"),identchannel("sourceIdent4"), file("samples/kik10.aif"), channel("file4"),imgfile("On", "fileButton.png")imgfile("Off", "fileButton.png"), imgfile("On", "fileButton.png")imgfile("Off", "fileButton.png") fontcolour:0(48, 54, 44, 255)
rslider bounds(614, 172, 70, 70), channel("Pitch4"), text("PITCH"), range(-2, 2, 0.22, 1, 0.001)  $KNOB1 ;, trackercolour(77,190,250, 250)
rslider bounds(694, 174, 70, 70), channel("Stretch4"), text("STRETCH"), range(0.01, 2, 1.7, 1, 0.001) $KNOB1 
rslider bounds(614, 254, 70, 70), channel("Density4"), text("DENSITY"), range(2, 32, 22, 1, 0.001) $KNOB1 
rslider bounds(694, 254, 70, 70), channel("Size4"), text("SIZE"), range(0.1, 1, 0.39, 1, 0.001) $KNOB1
combobox bounds(624, 344, 50, 20), channel("Type4"), items("LPF", "HPF"), colour(50,50,50,0),fontcolour(7,132,227)
rslider bounds(614, 372, 70, 70), channel("Filter4"), text("FREQ"), range(200, 9000, 4000, 0.5, 0.001) $KNOB1 trackercolour(7,132,227)
rslider bounds(694, 372, 70, 70), channel("Time4"), text("TIME"), range(0.001, 2, 0.25, 1, 0.001) $KNOB2 
rslider bounds(614, 452, 70, 70), channel("Feedbk4"), text("FEEDBK"), range(0.001, 0.99, 0.25, 1, 0.001) $KNOB2 
rslider bounds(694, 452, 70, 70), channel("Pshift4"), text("PSHIFT"), range(0.001, 1, 0.25, 1, 0.001) $KNOB2
rslider bounds(694, 532, 70, 70), channel("Amount4"), text("AMOUNT"), range(0.001, 0.7, 0.25, 1, 0.001) $KNOB2 
rslider bounds(614, 620, 70, 70), channel("Reverb4"), text("REVERB"), range(0, 1, 0.035, 1, 0.001) $KNOB1 trackercolour(255, 119, 119, 255) trackerinsideradius(0.01) trackerthickness(0.2)
rslider bounds(694, 620, 70, 70), channel("Volume4"), text("VOLUME"), range(0, 0.3, 0.2, 1, 0.001) $KNOB1 colour(210, 215, 211, 255) outlinecolour(48, 54, 44, 50) popuptext("0") style("normal") textcolour(50, 50, 50, 255) trackercolour(50, 50, 50, 255) trackerinsideradius(0.01) trackerthickness(0.2)
;keyboard bounds(10, 10, 100, 160), identchannel("widgetIdent")
;filebutton bounds(10, 10, 75, 15), channel("button1"), text("Save"), populate("*.snaps"), mode ("snapshot")

</Cabbage>
<CsoundSynthesizer>
<CsOptions>

-n -d -+rtmidi=NULL -M0 -m0d --midi-key-oct=4 --midi-velocity-amp=5 --displays

</CsOptions>
<CsInstruments>
sr = 48000
ksmps = 64
nchnls = 2
0dbfs  = 1

/* 

Config options 
See this video for a quick explanation 
https://www.dropbox.com/s/im1vivrjv98isub/Grainstation-C_config.mp4?dl=0

*/

giwin ftgen 1, 0, 8192, 20, 2, 1  ;Hanning window
giwindow = 1024

opcode pitchdelay, aa, aakkk ;audio in / audio out, delay time, feedback, delay mix, pitchShift
	ainL, ainR, kdelay, kfeedback, kfbpshift xin
	
	imaxdelay = 3; seconds
	alfoL lfo 0.05, 0.2 ; slightly mod the left delay time
	abuf1		delayr	imaxdelay
	atapL  deltap3    kdelay+alfoL
	delayw ainL + (atapL * kfeedback)
	fftinL  pvsanal   atapL, giwindow, giwindow/4, giwindow, 1 ; analyse it
	ftpsL  pvscale   fftinL, kfbpshift, 1, 2          ; transpose it keeping formants
	atpsL  pvsynth   ftpsL                     ; resynthesis
	
	
	;delay R
	alfoR lfo 0.05, 0.1 ; slightly mod the right delay time
	abuf2		delayr	imaxdelay
	atapR  deltap3    kdelay+alfoR
	delayw  ainR + (atapR * kfeedback)
	fftinR  pvsanal   atapR, giwindow, giwindow/4, giwindow, 1
	ftpsR  pvscale   fftinR, kfbpshift, 1, 2          
	atpsR  pvsynth   ftpsR                    
	
	atapL = atapL + atapR*0.02 ;introduce a little xmodulation
	atapR = atapR + atapL*0.07
	
	kpitchMix = 0.5 ; pitch mix disabled, can add on later in opcode argument
	;mix between pitched and unpitched delays
	kinvctrl = abs (kpitchMix -1)
	amixL = atapL*kinvctrl + atpsL*kpitchMix
	amixR = atapR*kinvctrl + atpsR*kpitchMix
	
	xout amixL, amixR
endop

opcode showwaveform, a, a
    asig xin
    kdisprel linsegr 1, 1, 1, 0.3, 0  
    adisplay limit asig, -0.8, 0.8
    adisplay = adisplay*kdisprel
    xout adisplay
endop

opcode pathshorten,0,SS
    Schan, Sident xin
    SFile chnget Schan
    printf "%s\n", k(1), SFile
    kpos  strrindexk SFile, "/"  ;look for the rightmost '/'
    Snam   strsubk    SFile, kpos+1, -1    ;extract the substring
    SMessage sprintfk "text(\"%s\") ", Snam
    chnset SMessage, Sident
endop

instr 1

  klev1 chnget "Volume1"
  kdens1 chnget "Density1"
  kgrsize1 chnget "Size1"
  kpitch1 chnget "Pitch1"
  kstr1 chnget "Stretch1"
  ifiltType1 chnget "Type1"
  kfilt1 chnget "Filter1"
  ktime1 chnget "Time1"
  kfdbk1 chnget "Feebbk1"
  kdelpshift1 chnget "Pshift1"
  kdelsend1 chnget "Amount1"
  kverbsend1 chnget "Reverb1"
  
  klev2 chnget "Volume2"
  kdens2 chnget "Density2"
  kgrsize2 chnget "Size2"
  kpitch2 chnget "Pitch2"
  kstr2 chnget "Stretch2"
  ifiltType2 chnget "Type2"
  kfilt2 chnget "Filter2"
  ktime2 chnget "Time2"
  kfdbk2 chnget "Feebbk2"
  kdelpshift2 chnget "Pshift2"
  kdelsend2 chnget "Amount2"
  kverbsend2 chnget "Reverb2"

  klev3 chnget "Volume3"
  kdens3 chnget "Density3"
  kgrsize3 chnget "Size3"
  kpitch3 chnget "Pitch3"
  kstr3 chnget "Stretch3"
  ifiltType3 chnget "Type3"
  kfilt3 chnget "Filter3"
  ktime3 chnget "Time3"
  kfdbk3 chnget "Feebbk3"
  kdelpshift3 chnget "Pshift3"
  kdelsend3 chnget "Amount3"
  kverbsend3 chnget "Reverb3"

  klev4 chnget "Volume4"
  kdens4 chnget "Density4"
  kgrsize4 chnget "Size4"
  kpitch4 chnget "Pitch4"
  kstr4 chnget "Stretch4"
  ifiltType4 chnget "Type4"
  kfilt4 chnget "Filter4"
  ktime4 chnget "Time4"
  kfdbk4 chnget "Feebbk4"
  kdelpshift4 chnget "Pshift4"
  kdelsend4 chnget "Amount4"
  kverbsend4 chnget "Reverb4"
        
;;Path to sound files
Sfile1 chnget "file1"
Sfile2 chnget "file2"
Sfile3 chnget "file3"
Sfile4 chnget "file4"

; index file names to integers
strset 0, Sfile1
strset 1, Sfile2
strset 2, Sfile3
strset 3, Sfile4

kpb init 0
midipitchbend kpb
koct =	p4+kpb					;add pitchbend values to octave-point-decimal value
kcps =	cpsoct(koct)				;convert octave-point-decimal value into Hz
ibase = 60 ;chnget "RootNote" ; middle C
kspeed	=	kcps/cpsmidinn(ibase)
iamp=p5
kenv=madsr(0.001, 0, 1, 1)
ichncount init 0	
	giL[] init 4 ;one alloc per channel/ftable
	giR[] init 4
	iFileArrLen = lenarray(giL)	
	icount init 0
	loadsounds:
	if icount < iFileArrLen then
		Sname strget icount
		ichn filenchnls Sname ;get number of channels. if mono then load up chn 1 twice.
		if ichn = 2 then
			giL[icount] ftgen 0, 0, 0, 1, Sname, 0, 0, 1
			giR[icount] ftgen 0, 0, 0, 1, Sname, 0, 0, 2
			;prints "is stereo \n"
		else 
			giL[icount] ftgen 0, 0, 0, 1, Sname, 0, 0, 1	
			giR[icount] ftgen 0, 0, 0, 1, Sname, 0, 0, 1
		endif
		icount +=1
		goto loadsounds
	endif
	    iolaps  = 2
	    ips     = 1/iolaps
       
        a1L syncloop klev1*kenv, kdens1, kspeed*kpitch1, kgrsize1, ips*kstr1, 0, ftlen(giL[0])/sr, giL[0], 1, iolaps
		a1R syncloop klev1*kenv, kdens1, kspeed*kpitch1, kgrsize1, ips*kstr1, 0, ftlen(giL[0])/sr, giL[0], 1, iolaps
		
		a2L syncloop klev2*kenv, kdens2, kspeed*kpitch2, kgrsize2, ips*kstr2, 0, ftlen(giL[1])/sr, giL[1], 1, iolaps
		a2R syncloop klev2*kenv, kdens2, kspeed*kpitch2, kgrsize2, ips*kstr2, 0, ftlen(giL[1])/sr, giL[1], 1, iolaps
		
		a3L syncloop klev3*kenv, kdens3, kspeed*kpitch3, kgrsize3, ips*kstr3, 0, ftlen(giL[2])/sr, giL[2], 1, iolaps
		a3R syncloop klev3*kenv, kdens3, kspeed*kpitch3, kgrsize3, ips*kstr3, 0, ftlen(giL[2])/sr, giL[2], 1, iolaps
		
		a4L syncloop klev4*kenv, kdens4, kspeed*kpitch4, kgrsize4, ips*kstr4, 0, ftlen(giL[3])/sr, giL[3], 1, iolaps
		a4R syncloop klev4*kenv, kdens4, kspeed*kpitch4, kgrsize4, ips*kstr4, 0, ftlen(giL[3])/sr, giL[3], 1, iolaps


  	kq = 0
  	alow1L, ahigh1L, aband1L svfilter a1L, kfilt1, 1
  	alow1R, ahigh1R, aband1R svfilter a1R, kfilt1, 1
  
    alow2L, ahigh2L, aband2L svfilter a2L, kfilt2, 1
  	alow2R, ahigh2R, aband2R svfilter a2R, kfilt2, 1
  
    alow3L, ahigh3L, aband3L svfilter a3L, kfilt3, 1
  	alow3R, ahigh3R, aband3R svfilter a3R, kfilt3, 1
  
    alow4L, ahigh4L, aband4L svfilter a4L, kfilt4, 1
  	alow4R, ahigh4R, aband4R svfilter a4R, kfilt4, 1
  	  	 
  	; put filters in array for controller selection and scale by klev value  
  	aFilt1L[] init 2
	aFilt1R[] init 2
	aFilt2L[] init 2
	aFilt2R[] init 2
	aFilt3L[] init 2
	aFilt3R[] init 2
	aFilt4L[] init 2
	aFilt4R[] init 2
  	aFilt1L[0] = alow1L
  	aFilt1L[1] = ahigh1L
  	aFilt1R[0] = alow1R
  	aFilt1R[1] = ahigh1R
  	aFilt2L[0] = alow2L
  	aFilt2L[1] = ahigh2L
  	aFilt2R[0] = alow2R
  	aFilt2R[1] = ahigh2R
  	aFilt3L[0] = alow3L
  	aFilt3L[1] = ahigh3L
  	aFilt3R[0] = alow3R
  	aFilt3R[1] = ahigh3R
  	aFilt4L[0] = alow4L
  	aFilt4L[1] = ahigh4L
  	aFilt4R[0] = alow4R
  	aFilt4R[1] = ahigh4R
 		
 		;;send filter out to delay opcode, returns on "adel..."
 	adel1L, adel1R pitchdelay aFilt1L[ifiltType1-1]*kdelsend1, aFilt1R[ifiltType1-1]*kdelsend1, ktime1, kfdbk1, kdelpshift1
    adel2L, adel2R pitchdelay aFilt2L[ifiltType2-1]*kdelsend2, aFilt2R[ifiltType2-1]*kdelsend2, ktime2, kfdbk2, kdelpshift2
  	adel3L, adel3R pitchdelay aFilt3L[ifiltType3-1]*kdelsend3, aFilt3R[ifiltType3-1]*kdelsend3, ktime3, kfdbk3, kdelpshift3
  	adel4L, adel4R pitchdelay aFilt4L[ifiltType4-1]*kdelsend4, aFilt4R[ifiltType4-1]*kdelsend4, ktime4, kfdbk4, kdelpshift4
  	 ;;mix  delay and dry (post filter) sigs
  	
    asig1L ntrpol aFilt1L[ifiltType1-1], adel1L, kdelsend1
  	asig1R ntrpol aFilt1R[ifiltType1-1], adel1R, kdelsend1 
  
    asig2L ntrpol aFilt2L[ifiltType2-1], adel2L, kdelsend2
  	asig2R ntrpol aFilt2R[ifiltType2-1], adel2R, kdelsend2 
    
    asig3L ntrpol aFilt3L[ifiltType3-1], adel3L, kdelsend3
  	asig3R ntrpol aFilt3R[ifiltType3-1], adel3R, kdelsend3 
  
    asig4L ntrpol aFilt4L[ifiltType4-1], adel4L, kdelsend4
  	asig4R ntrpol aFilt4R[ifiltType4-1], adel4R, kdelsend4 
    	
  chnmix asig1L*kverbsend1, "verbmixL"
  chnmix asig1R*kverbsend1, "verbmixR"
  chnmix asig2L*kverbsend2, "verbmixL"
  chnmix asig2R*kverbsend2, "verbmixR"
  chnmix asig3L*kverbsend3, "verbmixL"
  chnmix asig3R*kverbsend3, "verbmixR"
  chnmix asig4L*kverbsend4, "verbmixL"
  chnmix asig4R*kverbsend4, "verbmixR"
  
  chnmix asig1L, "mixL"
  chnmix asig1R, "mixR"
  chnmix asig2L, "mixL"
  chnmix asig2R, "mixR"
  chnmix asig3L, "mixL"
  chnmix asig3R, "mixR"
  chnmix asig4L, "mixL"
  chnmix asig4R, "mixR"
  
  
  ;adisplay1 showwaveform asig1L
  ;display adisplay1, 0.1, 1
  
  ;adisplay2 showwaveform asig2L
  ;display adisplay2, 0.1, 1
  
  ;adisplay3 showwaveform asig3L
  ;display adisplay3, 0.1, 1
  
  ;adisplay4 showwaveform asig4L
  ;display adisplay4, 0.1, 1
  
  
endin

instr reverb, 98
ainL chnget "verbmixL"
ainR chnget "verbmixR"
aRevL, aRevR freeverb ainL, ainR, 0.9, 0.5 
chnmix aRevL, "mixL"
chnmix aRevR, "mixR"

endin

instr mixer, 99	

amixL chnget "mixL"
amixR chnget "mixR"
outs amixL, amixR

 adisplaymain showwaveform amixL
 display adisplaymain, 0.1, 1
  
chnclear "verbmixL"
chnclear "verbmixR"
chnclear "mixL"
chnclear "mixR"

pathshorten "file1", "sourceIdent1"
pathshorten "file2", "sourceIdent2"
pathshorten "file3", "sourceIdent3"
pathshorten "file4", "sourceIdent4"
endin

</CsInstruments>
<CsScore>
i 98 	0		500000
i 99 	0		500000

e
 </CsScore>
</CsoundSynthesizer>