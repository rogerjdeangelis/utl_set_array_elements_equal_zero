
Set all elements of an array to 0 without a loop and in a datastep (64bit)

     Could build a set of matrix operations

     WORKING CODE

        array ary[10] 8 (10*9);       * has to be a temporary array;
        %common_main(ary,10);         * create a common storage area to share with dosubl;

        rc=dosubl('
            %common_sub(ary,10);      * same storage are as mainline - more for doc and checking;
            %ary_zero(ary,10);        * this just zero's out all elements - could do other operations;
        ');

HAVE
====
    array ary[10] 8 (10*9);

    ary[01] = 9
    ary[02] = 9
    ary[03] = 9
    ary[04] = 9
    ary[05] = 9
    ary[06] = 9
    ary[07] = 9
    ary[08] = 9
    ary[09] = 9
    ary[10] = 9


WANT
====
    ary[01] = 0
    ary[02] = 0
    ary[03] = 0
    ary[04] = 0
    ary[05] = 0
    ary[06] = 0
    ary[07] = 0
    ary[08] = 0
    ary[09] = 0
    ary[10] = 0

*                _                _       _
 _ __ ___   __ _| | _____      __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \    / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/   | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|    \__,_|\__,_|\__\__,_|

;

   Hardcode

   array ary[10] 8 (10*9);

   This initiates an array with all 9 in all elements


*
 _ __   ___  _ __    _ __ ___   __ _  ___ _ __ ___
| '_ \ / _ \| '_ \  | '_ ` _ \ / _` |/ __| '__/ _ \
| | | | (_) | | | | | | | | | | (_| | (__| | | (_) |
|_| |_|\___/|_| |_| |_| |_| |_|\__,_|\___|_|  \___/

           _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __
/ __|/ _ \| | | | | __| |/ _ \| '_ \
\__ \ (_) | | |_| | |_| | (_) | | | |
|___/\___/|_|\__,_|\__|_|\___/|_| |_|

;

%symdel adAry / nowarn;
data _null_;
   array ary[10] 8 (10*9);
   adAry=put(addrlong(ary[1]),$hex40.);
   call symputx('adAry',adAry);
   put ary[10]=;
   rc=dosubl('
      data _null_;
         length adAry $40;
         adAry = input(symget("adAry"),$hex40.);
         call pokelong(repeat(put(0,rb8.),9),adAry,8*10,1);
      run;quit;
   ');
    put ary[10]=;
run;quit;

/* LOG

ARY10=9
NOTE: DATA statement used (Total process time):
ARY10=0
NOTE: DATA statement used (Total process time):

The SAS compiler should take advantage of the data _null_
and perhaps a special compiler directive(continue?)
and not recompile the datastep on each iteration?
Like what FCMP does. Restrictions and directives are needed.
*/

*                                           _       _   _
 _ __ ___   __ _  ___ _ __ ___    ___  ___ | |_   _| |_(_) ___  _ __
| '_ ` _ \ / _` |/ __| '__/ _ \  / __|/ _ \| | | | | __| |/ _ \| '_ \
| | | | | | (_| | (__| | | (_) | \__ \ (_) | | |_| | |_| | (_) | | | |
|_| |_| |_|\__,_|\___|_|  \___/  |___/\___/|_|\__,_|\__|_|\___/|_| |_|

;

* works;
%symdel ary adAry sze / nowarn;

%macro common_main(ary,sze);
   adAry=put(addrlong(&ary.[1]),$hex40.);
   call symputx('adAry',adAry);
   call symputx("sze",&sze);
%mend common_main;

%macro common_sub(ary,sze);
      data _null_;
         length adAry $40;
         adAry = input(symget("adAry"),$hex40.);
%mend common_sub;

* have the common storage so we can write other macro operations;
%macro ary_zero(ary,sze);
   call pokelong(repeat(put(0,rb8.),&sze.-1),adAry,8*symget("sze"),1);
   run;quit;
%mend ary_zero;

data _null_;
   array ary[10] 8 (10*9);
   put ary[1]= ary[5]= ary[10]=;
   %common_main(ary,10);
   rc=dosubl('
      %common_sub(ary,10);
      %ary_zero(ary,10);
   ');
   put ary[1]= ary[5]= ary[10]=;
run;quit;



1399  * works;
1400  %symdel ary adAry sze / nowarn;
1401  %macro common_main(ary,sze);
1402     adAry=put(addrlong(&ary.[1]),$hex40.);
1403     call symputx('adAry',adAry);
1404     call symputx("sze",&sze);
1405  %mend common_main;
1406  %macro common_sub(ary,sze);
1407        data _null_;
1408           length adAry $40;
1409           adAry = input(symget("adAry"),$hex40.);
1410  %mend common_sub;
1411  * have the common storage so we can write other macro operations;
1412  %macro ary_zero(ary,sze);
1413     call pokelong(repeat(put(0,rb8.),&sze.-1),adAry,8*symget("sze"),1);
1414     run;quit;
1415  %mend ary_zero;
1416  data _null_;
1417     array ary[10] 8 (10*9);
1418     put ary[1]= ary[5]= ary[10]=;
1419     %common_main(ary,10);
MLOGIC(COMMON_MAIN):  Beginning execution.
MLOGIC(COMMON_MAIN):  Parameter ARY has value ary
MLOGIC(COMMON_MAIN):  Parameter SZE has value 10
SYMBOLGEN:  Macro variable ARY resolves to ary
MPRINT(COMMON_MAIN):   adAry=put(addrlong(ary[1]),$hex40.);
MPRINT(COMMON_MAIN):   call symputx('adAry',adAry);
SYMBOLGEN:  Macro variable SZE resolves to 10
MPRINT(COMMON_MAIN):   call symputx("sze",10);
MLOGIC(COMMON_MAIN):  Ending execution.
1420     rc=dosubl('
1421        %common_sub(ary,10);
1422        %ary_zero(ary,10);
1423     ');
1424     put ary[1]= ary[5]= ary[10]=;
1425  run;



ARY1=9 ARY5=9 ARY10=9


MLOGIC(COMMON_SUB):  Beginning execution.
MLOGIC(COMMON_SUB):  Parameter ARY has value ary
MLOGIC(COMMON_SUB):  Parameter SZE has value 10
MPRINT(COMMON_SUB):   data _null_;
MPRINT(COMMON_SUB):   length adAry $40;
MPRINT(COMMON_SUB):   adAry = input(symget("adAry"),$hex40.);
MLOGIC(COMMON_SUB):  Ending execution.
MLOGIC(ARY_ZERO):  Beginning execution.
MLOGIC(ARY_ZERO):  Parameter ARY has value ary
MLOGIC(ARY_ZERO):  Parameter SZE has value 10
SYMBOLGEN:  Macro variable SZE resolves to 10
MPRINT(ARY_ZERO):   call pokelong(repeat(put(0,rb8.),10-1),adAry,8*symget("sze"),1);
MPRINT(ARY_ZERO):   run;
NOTE: Character values have been converted to numeric values at the places given by:
      (Line):(Column).
      0:57
NOTE: DATA statement used (Total process time):


MPRINT(ARY_ZERO):  quit;
MLOGIC(ARY_ZERO):  Ending execution.


ARY1=0 ARY5=0 ARY10=0


NOTE: DATA statement used (Total process time):



