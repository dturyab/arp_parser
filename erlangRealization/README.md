arp_parser
=====

An OTP application


Make tests
-----

    $rebar3 do clean, compile, eunit



Structure
-----
    include directory contains arp_packet.hrl with record(arp_packet) declaration.

    src directory contains arp_parser.erl with parse/1 realization (other files required for build).

    test directory contains arp_parser_tests.erl with eunit tests.