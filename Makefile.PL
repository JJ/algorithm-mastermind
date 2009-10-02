use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Algorithm::MasterMind',
    AUTHOR              => 'JJ Merelo <jj@merelo.net>',
    VERSION_FROM        => 'lib/Algorithm/MasterMind.pm',
    ABSTRACT_FROM       => 'lib/Algorithm/MasterMind.pm',
    PL_FILES            => {},
    PREREQ_PM => {
		  'Test::More' => 0,
		  'version'    => 0,
		  'Algorithm::Evolutionary' => 0.71,
		  'Algorithm::Combinatorics' => 0
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Algorithm-MasterMind-*' },
);
