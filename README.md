# utl-simplest-case-of-a-hash-or-sql-lookup
Which math students are taking art clsses
    %let pgm=utl-simplest-case-of-a-hash-or-sql-lookup ;

    Which math students are taking art clsses

     Four 5 solutions

          1. SAS hash
          2, WPS hash
          3. R SQL
          3. PYTHON SQL

    github
    https://tinyurl.com/4kphnk3n
    https://github.com/rogerjdeangelis/utl-simplest-case-of-a-hash-or-sql-lookup

    stackoverflow
    https://tinyurl.com/4xdnbp25
    https://stackoverflow.com/questions/75611565/replicating-a-v-look-up-step-in-sas-for-one-table

    Replicating a excel V look up step in SAS for one table

    /*                   _
    (_)_ __  _ __  _   _| |_
    | | `_ \| `_ \| | | | __|
    | | | | | |_) | |_| | |_
    |_|_| |_| .__/ \__,_|\__|
            |_|
    */

    libname sd1 "d:/sd1";

    data sd1.math;
    input student$;
    cards4;
    ALFRED
    ALICE
    BARBARA
    CAROL
    HENRY
    JAMES
    JANE
    ;;;;
    run;quit;


    data sd1.art;
    input student$;
    cards4;
    JAMES
    JANET
    JEFFREY
    ALFRED
    ALICE
    PHILIP
    ;;;;
    run;quit;

    /**************************************************************************************************************************/
    /*                                                                                                                        */
    /* SD1.MATH total obs=7   Up to 40 obs from last table SD1.ART total obs=6                                                */
    /*                                                                                                                        */
    /* Ehich students are taking both math and art                                                                            */
    /*                                                                                                                        */
    /*                                          |  RULES                                                                      */
    /*       MATH                 ART           |                                                                             */
    /*                                          |                                                                             */
    /* Obs    STUDENT         Obs    STUDENT    |  IN BOTH                                                                    */
    /*                                          |                                                                             */
    /*  1     ALFRED           1     JAMES      |  ALFRED                                                                     */
    /*  2     ALICE            2     JANET      |  ALICE                                                                      */
    /*  3     BARBARA          3     JEFFREY    |  JAMES                                                                      */
    /*  4     CAROL            4     ALFRED     |                                                                             */
    /*  5     HENRY            5     ALICE      |                                                                             */
    /*  6     JAMES            6     PHILIP     |                                                                             */
    /*  7     JANE                              |                                                                             */
    /*                                                                                                                        */
    /**************************************************************************************************************************/

    /*               _               _
     ___  __ _ ___  | |__   __ _ ___| |__
    / __|/ _` / __| | `_ \ / _` / __| `_ \
    \__ \ (_| \__ \ | | | | (_| \__ \ | | |
    |___/\__,_|___/ |_| |_|\__,_|___/_| |_|

    */

    data want_sas_hash;

       length student $8;

       if _N_ = 1 then do;
          dcl hash art(dataset : 'sd1.art');
          art.defineKey('student');
          art.defineData('student');
          art.definedone();
       end;

       set sd1.math;
      if art.check() eq 0;

    run;

    /*                    _               _
    __      ___ __  ___  | |__   __ _ ___| |__
    \ \ /\ / / `_ \/ __| | `_ \ / _` / __| `_ \
     \ V  V /| |_) \__ \ | | | | (_| \__ \ | | |
      \_/\_/ | .__/|___/ |_| |_|\__,_|___/_| |_|
             |_|
    */

    %utl_submit_wps64("

    libname sd1 'd:/sd1';

    data want_wps_hash;

       length student $8;

       if _N_ = 1 then do;
          dcl hash art(dataset : 'sd1.art');
          art.defineKey('student');
          art.defineData('student');
          art.definedone();
       end;

       set sd1.math;
      if art.check() eq 0;

    run;quit;

    proc print data=want_wps_hash;
    run;quit;
    ");

    /**************************************************************************************************************************/
    /*                                                                                                                        */
    /* The WPS System                                                                                                         */
    /*                                                                                                                        */
    /* Obs    STUDENT                                                                                                         */
    /*                                                                                                                        */
    /*  1     ALFRED                                                                                                          */
    /*  2     ALICE                                                                                                           */
    /*  3     JAMES                                                                                                           */
    /*                                                                                                                        */
    /**************************************************************************************************************************/

    /*                         _
     ___  __ _ ___   ___  __ _| |
    / __|/ _` / __| / __|/ _` | |
    \__ \ (_| \__ \ \__ \ (_| | |
    |___/\__,_|___/ |___/\__, |_|
                            |_|
    */

    /*---- you can force SAS to use a hash method ----*/

     proc sql;
      create
         table sas_sql as
      select
         math.student
      from
         sd1.math, sd1.art
      where
         math.student = art.student
    ;quit;

    /*___              _
    |  _ \   ___  __ _| |
    | |_) | / __|/ _` | |
    |  _ <  \__ \ (_| | |
    |_| \_\ |___/\__, |_|
                    |_|
    */

    %utlfkil(d:/xpt/want_r.xpt);

    %utl_submit_r64("
      library(haven);
      library(SASxport);
      library(sqldf);
      math<-read_sas('d:/sd1/math.sas7bdat');
      art <-read_sas('d:/sd1/art.sas7bdat');
      want_r<-sqldf('
          select
             math.student
          from
             math, art
          where
             math.student = art.student
      ');
      want_r;
      write.xport(want_r,file='d:/xpt/want_r.xpt');
    ");

    libname xpt xport 'd:/xpt/want_r.xpt';

    proc print data=xpt.want_r;
    run;quit;

    /*           _   _                             _
     _ __  _   _| |_| |__   ___  _ __    ___  __ _| |
    | `_ \| | | | __| `_ \ / _ \| `_ \  / __|/ _` | |
    | |_) | |_| | |_| | | | (_) | | | | \__ \ (_| | |
    | .__/ \__, |\__|_| |_|\___/|_| |_| |___/\__, |_|
    |_|    |___/                                |_|
    */


    proc datasets lib=work kill;
    run;quit;

    %utlfkil(d:/xpt/want.xpt);

    %utl_pybegin;
    parmcards4;
    from os import path
    import pandas as pd
    import xport
    import xport.v56
    import pyreadstat
    import numpy as np
    import pandas as pd
    from pandasql import sqldf
    mysql = lambda q: sqldf(q, globals())
    from pandasql import PandaSQL
    pdsql = PandaSQL(persist=True)
    sqlite3conn = next(pdsql.conn.gen).connection.connection
    sqlite3conn.enable_load_extension(True)
    sqlite3conn.load_extension('c:/temp/libsqlitefunctions.dll')
    mysql = lambda q: sqldf(q, globals())
    math, meta = pyreadstat.read_sas7bdat("d:/sd1/math.sas7bdat")
    art, meta = pyreadstat.read_sas7bdat("d:/sd1/art.sas7bdat")
    print(math);
    res = pdsql("""
          select
             math.STUDENT
          from
             math, art
          where
             math.STUDENT = art.STUDENT
        ;""")
    print(res);
    ds = pyreadstat.write_xport(res,dst_path='d:/xpt/want.xpt',table_name='WANT', file_format_version=5) ;
    ;;;;
    %utl_pyend;

    libname pyxpt xport "d:/xpt/want.xpt";

    proc contents data=pyxpt._all_;
    run;quit;

    data want;
      set pyxpt.want;
    run;quit;

    /*              _
      ___ _ __   __| |
     / _ \ `_ \ / _` |
    |  __/ | | | (_| |
     \___|_| |_|\__,_|

    */



