insert into dgf.node_ref (NODE_ID, GRAPH_ID, NODE_TYPE_ID, NAME, DESCRIPTION, NOTE, SYSTEM_ID)
values (100150, 100001, 100000, 'PGW', 'DS70', '', null);

insert into dgf.node_ref (NODE_ID, GRAPH_ID, NODE_TYPE_ID, NAME, DESCRIPTION, NOTE, SYSTEM_ID)
values (100151, 100001, 100000, 'SGW', 'DS71', '', null);

insert into dgf.node_ref (NODE_ID, GRAPH_ID, NODE_TYPE_ID, NAME, DESCRIPTION, NOTE, SYSTEM_ID)
values (100152, 100001, 100000, 'SGSN', 'DS72', '', null);



insert into dgf.edge_ref (EDGE_ID, I_NODE_ID, J_NODE_ID, EDGE_TYPE_ID, NAME, DESCRIPTION, NOTE)
values (100120, 100150, 100152, 1, 'PGW to SGSN', 'PGW to SGSN', '');

insert into dgf.edge_ref (EDGE_ID, I_NODE_ID, J_NODE_ID, EDGE_TYPE_ID, NAME, DESCRIPTION, NOTE)
values (100121, 100150, 100151, 1, 'PGW to SGW', 'PGW to SGW', '');

insert into dgf.edge_ref (EDGE_ID, I_NODE_ID, J_NODE_ID, EDGE_TYPE_ID, NAME, DESCRIPTION, NOTE)
values (100122, 100150, 100107, 1, 'PGW to EMM data', 'PGW to EMM data', '');




insert into dgf.node_group_jn (NODE_GROUP_ID, NODE_ID)
values (100107, 100150);

insert into dgf.node_group_jn (NODE_GROUP_ID, NODE_ID)
values (100106, 100150);

insert into dgf.node_group_jn (NODE_GROUP_ID, NODE_ID)
values (100107, 100151);

insert into dgf.node_group_jn (NODE_GROUP_ID, NODE_ID)
values (100106, 100151);

insert into dgf.node_group_jn (NODE_GROUP_ID, NODE_ID)
values (100107, 100152);

insert into dgf.node_group_jn (NODE_GROUP_ID, NODE_ID)
values (100106, 100152);


commit;
exit;
