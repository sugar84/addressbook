package AddressBook::SQL;
use strict;
use warnings;

our %BLOCKS;

$BLOCKS{"fetch_some"} = qq/
    SELECT organization.org_id, organization.full_name, branch.branch_name, 
        branch_order FROM (organization INNER JOIN branch ON 
            organization.branch2_id = branch.branch_id)
        WHERE organization.branch2_id = 10/;
1;
