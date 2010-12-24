
{ test_select => qq/
    SELECT organization.org_id, organization.full_name, branch.branch_name, 
        branch_order FROM (organization INNER JOIN branch ON 
            organization.branch2_id = branch.branch_id)
        WHERE organization.branch2_id = 10/,
  bb => qq/
    asasdasdasdas
  /,
  test   => qq/
    select id, title, text from entries order by id desc
  /,
  schema => qq/
    create table if not exists entries (
        id integer primary key autoincrement,
        title string not null,
        text string not null
    )
  /,
}

