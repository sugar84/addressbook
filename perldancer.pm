package perldancer;
use Dancer;
use Template;
use utf8;

get '/' => sub {
    template 'home';
};

get '/donate/thanks' => sub {
    template 'thanks';
};

true;
