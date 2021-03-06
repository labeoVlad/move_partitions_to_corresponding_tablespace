/*check if TABLESPACE_NAME_EXISTED equals TABLESPACE_NAME_PROPOSED*/

select distinct ut.table_name, ut.num_rows , 
       utb.tablespace_name TABLESPACE_NAME_EXISTED ,
       case when ut.num_rows between 0 and 3000000 then 'TBS_RC_WAC_SMALL_DATA'
            when ut.num_rows between 3000001 and 10000000 then 'TBS_RC_WAC_MEDIUM_DATA'
            when ut.num_rows > 10000000 then 'TBS_RC_WAC_LARGE_DATA'
            else 'UNKNOWN'
       end TABLESPACE_NAME_PROPOSED
 from user_tables ut JOIN  user_tab_partitions utb on (ut.table_name = utb.table_name) ; 
 
