package AddressBook;

use Dancer ':syntax';
use Template;
use DBI;
use Carp;
use Data::Dumper;
use Encode;
use utf8;
use AddressBook::SQL;

my %sql_blocks;

# dirty utf8 hack for Dumper

$Data::Dumper::Useqq = 1;

{ no warnings 'redefine';
    sub Data::Dumper::qqoute {
        my $s = shift;
        return "'$s'";
    }
}

### Subs
#

sub init_all_sql {
    my $fh;
    
    open $fh, "<", setting("sql_schema")
        or croak "cannot open SQL schema : $!\n";
    $sql_blocks{"schema"} = do { local $/; <$fh> };
    close $fh;

    open $fh, "<", setting("sql_fetch_all")
        or croak "cannot open SQL fetch_all : $!\n";
    $sql_blocks{"fetch_all"} = do { local $/; <$fh> };
    close $fh;
}

sub init_db {
    my $db = connect_db();

    $db->do( $sql_blocks{"schema"} ) 
        or croak $db->errstr;
}

sub connect_db {
    my $dbh = DBI->connect( setting("db_dbi") . setting("db_name") )
        or croak $DBI::errstr;
    
    $dbh->{"unicode"} = 1;

    return $dbh;
}

### Handlers

get '/all_records' => sub {
    my $db = connect_db();

    my $sth = $db->prepare( $AddressBook::SQL::BLOCKS{"fetch_some"} )
        or croak $db->errstr;
    warning( $AddressBook::SQL::BLOCKS{"fetch_some"} );
    $sth->execute
        or croak $sth->errstr;

    warning join("::", @INC);

    my $entries    = $sth->fetchall_hashref("org_id")
        or croak $sth->errstr;

    template "all_records.tt", { 
        entries  => $entries,
#        test_utf => $utf_string,
    };
};

get '/' => sub {
    template 'home';
};

init_all_sql();
init_db();
true;
