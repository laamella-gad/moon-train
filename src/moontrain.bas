SHOW TITLE

    2 goto3000

INIT VARIABLES

    5 lv=54296:lw=54276:lf=54272:hf=54273:a3=54277:s3=54278:ph=54275:pl=54274:po=0
   20 v=53248:sp=1853:l=125:li=53:tr=1:m=100:n=150:bp=3000
   30 pokev+40,1:pokev+39,7:poke650,255
   40 poke2040,13:poke2041,15:poke2042,11:poke2043,11:gosub4000
   50 fora=0to62:readb:poke832+a,b:next
   60 fora=0to62:readb:poke960+a,b:next
   70 fora=0to62:readb:poke704+a,b:next
   80 pokev+23,3:pokev+29,3

MUSIC DATA

   90 data8,147,100,17,37,100,34,75,100,68,149,100
   91 data137,43,100,244,103,100,34,75,100,244,103,100,68,149,100,244,103,100
   92 data68,149,100,34,75,100,17,37,100,8,147,100,-1

SPRITE DATA

  100 data0,0,0,0,0,0,0,0,0,3,0,0,3,0,0,3,0,16,3,0,56,3,34,56,3,119,124,11,255,255
  110 data31,255,255,51,85
  120 data47,51,255,63,63,255,255,97,225,225,204,204,204,30,30,30,59,59,59,55,55
  130 data55,30,30,30,12,12,12
  140 data2,0,0,1,0,0,2,0,0,1,0,0,2,0,0,1,0,0,2,0,0,1,0,0,2,0,0,1,0,0,2,0,0,1,0,0
  150 data2,0,0,1,0,0,2,0,0,1,0,0,2,0,0,1,0,0,2,0,0,1,0,0,2,0,0
  160 data0,4,128,0,5,0,0,10,0,0,12,0,0,24,0,0,24,0,0,255,0,3,255,192,6,102,96
  170 data30,102,120,255,255,255,255,255,255,63,126,252,31,129,248,15,255,240,7
  180 data255,224,3,255,192,0,255,0,0,219,0,1,153,128,1,153,128
  430 print"{blu}{down}{rght}{rght}{rght}{rght}{rght}{rght}tryk space for start"
  440 geta$:ifa$<>" "then440
  450 gosub4000

START GAME

  455 print"{clr}"
  460 pokev+31,0:pokev+21,13
  470 x=200:y=175:pokev+0,x:pokev+1,y:pokev+5,60:pokev+7,60
  475 print"{home}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{rght}hi.sco. : 0     points : 0     liv : 5"
  476 print"{home}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{rght}hi.sco. ";hi
  480 fora=0to39:poke1864+a,160:next

MAIN LOOP

  490 geta$
  510 ifa$="h"thengosub900
  520 ifa$="b"thengosub700
  530 ifa$="n"thengosub750
  540 ifa$=" "thengosub800

MOVE ROCK

  560 pokesp,32:sp=sp+tr:pokesp,81
  570 ifsp>1861thenpokesp,32:sp=1824
  575 ifpeek(v+31)=1thengosub2100
  580 j=j+5:l=l+5:ifj>255thenj=5
  590 ifl>255thenl=5
  600 pokev+4,j:pokev+6,l
  610 ifm=jthenp=j:gosub1200
  620 ifn=lthenp=l:gosub1200
  630 ifj=150andl=150thenl=0
  690 goto490

LEFT

  700 x=x-7
  710 ifx<23thenx=25
  720 goto760

RIGHT

  750 x=x+7:ifx>255thenx=255:goto760
  760 pokev+0,x:pokev+1,y
  770 return

FIRE

  800 gosub2200
  805 pokev+2,x:pokev+3,y-37
  810 pokev+21,15
  815 forc=0to200:next
  820 pokev+2,x:pokev+3,y-74
  825 forc=0to200:next
  830 pokev+3,y-111
  831 ifx>j-17andx<j+13thenm=j:j=0:po=po+100:ifpo=bpthen1400
  832 ifx>l-17andx<l+13thenn=l:l=0:po=po+100
  834 pokev+21,15
  835 forc=0to200:next
  840 pokev+3,y-148
  845 forc=0to200:next
  850 pokev+3,y-37:pokev+21,13
  855 print"{home}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}points :";po:poke1982,li
  860 ifpo=bpthen1400
  870 return

JUMP

  900 gosub2300
  905 pokev+1,160
  907 ifpeek(v+31)=1thengosub2100
  910 f=f-2:iff<-80then930
  915 ifx+f<23thenf=0:x=255:goto940
  920 pokev+0,x+f:pokev+1,160:goto910
  930 x=x-80:f=0
  940 pokev+0,x:pokev+1,175
  950 po=po+100:goto855

TRY AGAIN

 1000 print"{home}{down}{down}{down}{down}{down}{down}{down}{down}{down}{rght}{rght}{rght}{rght}{rght}{rght}vil du pr0ve igen (j/n)"
 1010 geta$:ifa$=""then1010
 1020 ifa$="j"thenpokev+21,0:goto430
 1030 ifa$="n"thensys65126
 1040 goto1010

ALIEN FIRE

 1200 gosub2200
 1205 pokev+2,p-1:pokev+3,80
 1210 pokev+21,15
 1220 fora=0to200:next
 1230 pokev+3,117
 1240 fora=0to200:next
 1250 pokev+3,154
 1260 ifp>x-15andp<x+36thengosub2100
 1270 pokev+21,13
 1290 return

 BOOM

 1300 print"{home}{down}{down}{down}{down}{down}{down}{down}{down}{down}"tab(17)"M    N"
 1310 print:printtab(17)"CramtC"
 1320 print:printtab(17)"N    M"
 1330 fora=0to400:next
 1340 print"{home}{down}{down}{down}{down}{down}{down}{down}{down}{down}"tab(17)"      "
 1350 print:printtab(17)"      "
 1360 print:printtab(17)"      "
 1370 pokev+21,13:pokesp,32:sp=1861:pokesp,81:pokev+31,0
 1380 li=li-1:poke1982,li
 1385 ifli=48then1387
 1386 return

UPDATE HIGH SCORE

 1387 ifpo>hithenhi=po
 1388 print"{home}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{rght}hi.sco. :";hi
 1390 po=0:li=53:tr=1:goto1000

BONUS

 1400 bo=(po*(li-48))/2:ifbp=11000thenbp=40000:tr=2
 1405 ifbp=3000thenbp=11000
 1410 print"{home}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}bonus :";bo
 2010 fora=0to5:pokelv,15:pokelw,33:pokels,15:pokehf,16:pokelf,47:next
 2020 pokelw,0:pokels,0
 2030 q=q+1:print"{up}                                       "
 2040 ifq=20thenq=0:goto2050
 2045 goto1410
 2050 po=bo+po:li=53:pokesp,32:sp=1854:goto850

HIT ROCK?

 2100 fora=15to0step-1:pokelv,a:pokelw,129:pokels,15:pokehf,16:pokelf,47:next
 2110 pokelw,0:pokels,0
 2120 goto1300

FIRE SOUND

 2200 fora=0to15:pokelv,15:pokelw,129:pokehf,40:pokelf,200:pokea3,15:next
 2220 pokew2,0:pokelv,0
 2230 return

JUMP SOUND

 2300 fora=0to20:pokelv,15:pokelw,33:pokehf,40:pokelf,200:pokea3,15:next
 2310 pokelw,0:pokelv,0
 2320 return

TITLE SCREEN

 3000 poke53281,0:poke53280,7
 3010 print"{clr}{yel}{down}{down}{rght}{rght}{rght}MN{CBM-Y}{CBM-Y}MN{CBM-Y}{CBM-Y}M   N{CBM-Y}M    N{CBM-Y}M   MN{CBM-Y}{CBM-Y}M "
 3020 print"{rght}{rght}{rght}{CBM-N}   {CBM-N}   {CBM-N}  N   M  N   M  {CBM-N}   {CBM-N}"
 3030 print"{rght}{rght}{rght}{CBM-N}   {CBM-N}   {CBM-N}  {CBM-G}   {CBM-N}  {CBM-G}   {CBM-N}  {CBM-N}   {CBM-N}  {rvon}   {rvof}"
 3040 print"{rght}{rght}{rght}{CBM-N}   {CBM-M}   {CBM-M}  M   N  M   N  {CBM-M}   {CBM-M}"
 3050 print"{rght}{rght}{rght}N   NM   M  M{CBM-P}N    M{CBM-P}N   N    M"
 3060 print"{down}{rght}{rght}{rght}N{CBM-Y}P{CBM-Y}{CBM-Y}M  MN{CBM-Y}{CBM-Y}M   N{CBM-Y}{CBM-Y}M  Q  MN{CBM-Y}{CBM-Y}M"
 3070 print"{rght}{rght}{rght}  {CBM-N}      {CBM-G}  {CBM-N}   {CBM-G}  {CBM-N}      {CBM-G}  {CBM-N}"
 3080 print"{rght}{rght}{rght}{rght}{rght}{CBM-N}      {CBM-G}  N   L{CBM-P}{CBM-P}{SHIFT-@}  B   {CBM-G}{$a0}{$a0}{CBM-M}"
 3090 print"{rght}{rght}{rght}{rght}{rght}{CBM-N}      O{CBM-Y}{CBM-Y}M   {CBM-G}  {CBM-N}  B   {CBM-G}  {CBM-N}"
 3100 print"{rght}{rght}{rght}{rght}{rght}{CBM-N}     N   {CBM-N}  N    M B  N    M"
 3110 print"{lgrn}{down}{down}{rght}{rght}{rght}{rght}{rght}du er blevet lokomotivf0rer paa"
 3120 print"{down}{rght}{rght}{rght}{rght}{rght}maanen. du skyder ufo'erne med"
 3130 print"{down}{rght}{rght}{rght}{rght}{rght}space og hopper over stenene ved"
 3140 print"{down}{rght}{rght}{rght}{rght}{rght}at trykke tasten h."
 3150 goto5

SONG

 4000 pokelv,15:pokea3,9:pokeph,15:pokepl,15:pokes3,0:restore
 4010 readh3:ifh3=-1thenreturn
 4020 readl3:readd3
 4030 pokehf,h3:pokelf,l3:pokelw,33
 4040 fora=1tod3:next:pokelw,32
 4050 x=x+1:fora=0to50:next:goto4010
 4051 data8,147,100,17,37,100,34,75,100,68,149,100
 4052 data137,43,100,244,103,100,34,75,100,244,103,100,68,149,100,244,103,100
 4053 data68,149,100,34,75,100,17,37,100,8,147,100,-1,-1,-1

