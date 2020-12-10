
select 'alter table ' || table_name || ' move partition ' || partition_name|| ' tablespace '|| TABLESPACE_NAME_DECIDED ||' parallel 32;' BATCH_PROCESS from (
select * from (
select table_name, num_rows, nullif( TABLESPACE_NAME_PROPOSED, TABLESPACE_NAME_EXISTED) TABLESPACE_NAME_DECIDED, partition_name from  (
select distinct ut.table_name, ut.num_rows , 
       utb.tablespace_name TABLESPACE_NAME_EXISTED ,
       case when ut.num_rows between 0 and 3000000 then 'TBS_RC_WAC_SMALL_DATA'
            when ut.num_rows between 3000001 and 10000000 then 'TBS_RC_WAC_MEDIUM_DATA'
            when ut.num_rows > 10000000 then 'TBS_RC_WAC_LARGE_DATA'
            else 'UNKNOWN'
       end TABLESPACE_NAME_PROPOSED, 
       utb.partition_name
 from user_tables ut JOIN  user_tab_partitions utb on (ut.table_name = utb.table_name) 
 )
) where TABLESPACE_NAME_DECIDED is not null )
order by table_name;
