<Cabbage>
form caption("Randy") size(175, 100), colour(255, 255, 255), pluginid("1041")
button bounds(10, 10, 150, 50), latched(1), channel("Go"), text("GO!")
texteditor bounds(10, 58, 152, 24), channel("textEditor"), identchannel("textDisplay"), text("Generate a random word")
;label bounds(10, 58, 150, 50), channel("label1"), identchannel "textDisplay", colour(20, 20, 20), text("Generate a random word")

</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 -m0d 
</CsOptions>
<CsInstruments>
; Initialize the global variables. 
ksmps = 32
nchnls = 2
0dbfs = 1
seed 0

instr 1

kgo chnget "Go"
if changed(kgo) == 1 then
event "i", 2, 0, 0.5
endif

endin

instr 2
;; random word generator
icount init 0
iwordLength = random(2,4) ;chnget "wordLength" ; how long will the random word be (when this number is doubled)
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

//SMessage sprintfk "text(\"%s\") \n", Stitle
SMessage sprintfk "text(\"%s\")", Stitle
        chnset SMessage, "textDisplay"
        prints SMessage

endin

</CsInstruments>
<CsScore>
;starts instrument 1 and runs it for a week
i1 0 [60*60*24*7] 
</CsScore>
</CsoundSynthesizer>
