package AddressBook;

use Dancer ':syntax';
use Template;
use Carp;
use Data::Dumper;
use Dancer::Plugin::Database;
use AddressBook::Plugin::MountCode;
use utf8;

my %sql_blocks;

# import sql-statements
my $sqls_file  = "SQL/sql.pl";
my $sql_blocks = do $sqls_file;


# dirty utf8 hack for Dumper

$Data::Dumper::Useqq = 1;
{ no warnings 'redefine';
    sub Data::Dumper::qqoute {
        my $s = shift;
        return "'$s'";
    }
}

warning caller;
mount_code;

### Handlers

get '/all_records' => sub {

    warning ( __PACKAGE__ );
    my $entries = test_select();

    template "all_records.tt", { 
        entries  => $entries,
#        test_utf => join "::", @{$string_ref},
    };
};

get '/' => sub {
    template 'home';
};

true;
