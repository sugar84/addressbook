package AddressBook::Plugin::MountCode;
use strict;
use warnings;

use Dancer qw(:syntax);
use Dancer::Plugin;
use Carp;
use Data::Dumper;

my $settings = plugin_setting;

register show_settings => sub {
    print Dumper($settings);
};

register mount_code => sub {
    while (my ($description, $file) = each %{$settings}) {
        open my $fh, "<", $file
            or croak "cannot open $file at $description : $!\n";
        
        my $code = do { local $/= undef; <$fh> };
        warning caller;
        eval $code;
        if ($@) {
            croak "while execution code some errors occured see the:\n" .
                "$description" . ":" . "$file";
        }
    }
#    test_select();
};


register_plugin;

1;

