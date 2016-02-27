use 5.006;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Net::DNS::Reputation::TeamCymru',
    VERSION_FROM      => 'lib/Net/DNS/Reputation/TeamCymru.pm', # finds $VERSION, requires EU::MM from perl >= 5.5
    PREREQ_PM         => {Net::DNS => 0.89}, # e.g., Module::Name => 1.1
    ABSTRACT_FROM     => 'lib/Net/DNS/Reputation/TeamCymru.pm', # retrieve abstract from module
    AUTHOR            => 'Kaio Rafael <perl@kaiux.com>',
    LICENSE           => 'GPL3',
    MIN_PERL_VERSION => 5.006,
    #Value must be from legacy list of licenses here
    #http://search.cpan.org/perldoc?Module%3A%3ABuild%3A%3AAPI
);
