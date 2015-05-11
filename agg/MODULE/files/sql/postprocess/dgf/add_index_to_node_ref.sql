------------------------------------------
-- A unique index to stop duplicate node
-- names which would break the data load 
-- process.
------------------------------------------

create unique index dgf.node_ref_desc_unique_idx on dgf.node_ref (description)
/

exit
