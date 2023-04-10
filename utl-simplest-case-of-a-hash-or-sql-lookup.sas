%let pgm=utl-an-additional-algorithm-to-map-codes-to-decodes ;

An additional algorithm to map codes to decodes

github
https://tinyurl.com/ym86wje8
https://github.com/rogerjdeangelis/utl-an-additional-algorithm-to-map-codes-to-decodes

This is probably not the best method to map codes to decodes, but do expect it to be fast
once you have the macro variable. It is an additional tool.

related to
https://tinyurl.com/2bc5hsah
https://stackoverflow.com/questions/75562078/sas-fill-array-with-variable-end-with-date-some-dates-are-missing

/*                   _
(_)_ __  _ __  _   _| |_ ___
| | `_ \| `_ \| | | | __/ __|
| | | | | |_) | |_| | |_\__ \
|_|_| |_| .__/ \__,_|\__|___/
        |_|
*/

data codes;
  do code = 5 to 1 by -1;
    output;
  end;
run;quit;

data decodes;
  decode="AK";output;
  decode="AL";output;
  decode="CA";output;
  decode="GA";output;
  decode="VT";output;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/*                                        OUTPUT ONE TABLE                                                                */
/*                                        ----------------                                                                */
/* WORK.CODES obs=5  WORK.DECODES obs=5 |   WANT obs=5                                                                    */
/*                                      |                                                                                 */
/* Obs    CODE        Obs    DECODE     | CODE    DECODES                                                                 */
/*                                      |                                                                                 */
/*  1       5          1       AK       |   5       AK                                                                    */
/*  2       4          2       AL       |   4       AL                                                                    */
/*  3       3          3       CA       |   3       CA                                                                    */
/*  4       2          4       GA       |   2       GA                                                                    */
/*  5       1          5       VT       |   1       VT                                                                    */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*         _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __
/ __|/ _ \| | | | | __| |/ _ \| `_ \
\__ \ (_) | | |_| | |_| | (_) | | | |
|___/\___/|_|\__,_|\__|_|\___/|_| |_|

*/

%array(_decodes,data=decodes,var=decode) ;
%array(_codes,data=codes,var=code);

%put &_decodes3; /*---- CA ----*/
%put &_decodesn; /*---- 5  ----*/

data want;
   %do_over(_codes _decodes,phrase=%str(
         code    =  ?_codes     ;
         decodes =  "?_decodes" ;
         output ;
         ));
run;quit;

%arraydelete(_codes);
%arraydelete(_decodes);


/**************************************************************************************************************************/
/*                                                                                                                        */
/* Up to 40 obs from last table WORK.WANT total obs=5 10APR2023:15:41:50                                                  */
/*                                                                                                                        */
/* Obs    CODE    DECODES                                                                                                 */
/*                                                                                                                        */
/*  1       5       AK                                                                                                    */
/*  2       4       AL                                                                                                    */
/*  3       3       CA                                                                                                    */
/*  4       2       GA                                                                                                    */
/*  5       1       VT                                                                                                    */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
