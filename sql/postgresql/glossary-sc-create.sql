-- Implement OpenFTS Search service contracts
-- Dave Bauer dave@thedesignexperience.org
-- 2001-10-27

select acs_sc_impl__new(
	'FtsContentProvider',		-- impl_contract_name
	'glossary',			-- impl_name
	'glossary'			-- impl_owner.name
);

select acs_sc_impl_alias__new(
	'FtsContentProvider',		-- impl_contract_name
	'glossary',			-- impl_name
	'datasource',			-- impl_operation_name
	'glossary__datasource',		-- impl_alias
	'TCL'				-- impl_pl
);

select acs_sc_impl_alias__new(
	'FtsContentProvider',		-- impl_contract_name
	'glossary',			-- impl_name
	'url',				-- impl_operation_name
	'glossary__url',		-- impl_alias
	'TCL'				-- impl_pl
);
