-module(arp_parser_tests).
-include_lib("eunit/include/eunit.hrl").

-include("include/arp_packet.hrl").

% Correct test
correct_response_test() ->
    TestPacket = <<
    16#00, 16#01, 16#08, 16#00, 16#06, 16#04, 16#00, 16#01,
    16#08, 16#00, 16#27, 16#12, 16#34, 16#56, 16#C0, 16#A8,
    16#01, 16#01, 16#00, 16#00, 16#00, 16#00, 16#00, 16#00,
    16#C0, 16#A8, 16#01, 16#02
    >>,

    {ok, Record} = arp_parser:parse(TestPacket),

    ?assertEqual(1, Record#arp_packet.htype),
    ?assertEqual(2048, Record#arp_packet.ptype),
    ?assertEqual(6, Record#arp_packet.hsize),
    ?assertEqual(4, Record#arp_packet.psize),
    ?assertEqual(1, Record#arp_packet.op),
    ?assertEqual(<<16#08,16#00,16#27,16#12,16#34,16#56>>, Record#arp_packet.sha),
    ?assertEqual(<<192,168,1,1>>, Record#arp_packet.spa),
    ?assertEqual(<<16#00,16#00,16#00,16#00,16#00,16#00>>, Record#arp_packet.tha),
    ?assertEqual(<<192,168,1,2>>, Record#arp_packet.tpa).


% Short packet test (missed 4 last bytes)
short_packet_test() -> 
    TestPacket = <<
    16#00, 16#01, 16#08, 16#00, 16#06, 16#04, 16#00, 16#01,
    16#08, 16#00, 16#27, 16#12, 16#34, 16#56, 16#C0, 16#A8,
    16#01, 16#01, 16#00, 16#00, 16#00, 16#00, 16#00, 16#00
    >>,
    ?assertEqual({error, invalid_input}, arp_parser:parse(TestPacket)).

% Invalid  hardware size (hsize=8)
invalid_address_sizes_test() ->
    TestPacket = <<
    16#00, 16#01, 16#08, 16#00, 16#08, 16#04, 16#00, 16#01,
    16#08, 16#00, 16#27, 16#12, 16#34, 16#56, 16#C0, 16#A8,
    16#01, 16#01, 16#00, 16#00, 16#00, 16#00, 16#00, 16#00,
    16#C0, 16#A8, 16#01, 16#02
    >>,
    ?assertEqual({error, invalid_address_sizes}, arp_parser:parse(TestPacket)).