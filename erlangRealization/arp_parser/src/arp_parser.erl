-module(arp_parser).
-export([parse/1, print_arp/1]).

-include("include/arp_packet.hrl").

% Parser function
% Big endian format
parse(<<
    HType:16/big-unsigned-integer,
    PType:16/big-unsigned-integer,
    HSize:8/unsigned-integer,
    PSize:8/unsigned-integer,
    Op:16/big-unsigned-integer,
    SHa:6/binary,
    SPa:4/binary,
    THa:6/binary,
    TPa:4/binary
>>) ->
    case {HSize, PSize} of
        {6, 4} -> {
            ok, 
            #arp_packet{
                htype = HType,
                ptype = PType,
                hsize = HSize,
                psize = PSize,
                op = Op,
                sha = SHa,
                spa = SPa,
                tha = THa,
                tpa = TPa
            }
        };
        _ -> {error, invalid_address_sizes}
    end;
parse(_) ->
    {error, invalid_input}.


% Binary to string MAC-converter
bin_to_str_mac(Binary) when byte_size(Binary) =:= 6 ->
    [A, B, C, D, E, F] = binary_to_list(Binary),
    io_lib:format("~2.16.0B:~2.16.0B:~2.16.0B:~2.16.0B:~2.16.0B:~2.16.0B", [A, B, C, D, E, F]);
bin_to_str_mac(_) ->
    "Invalid MAC structure".


% Binary to string IP-converter
bin_to_str_ip(Binary) when byte_size(Binary) =:= 4 ->
    [A, B, C, D] = binary_to_list(Binary),
    io_lib:format("~B.~B.~B.~B", [A, B, C, D]);
bin_to_str_ip(_) ->
    "Invalid IP structure".


% #arp_packet record printer
print_arp(#arp_packet{
    htype = HType,
    ptype = PType,
    hsize = HSize,
    psize = PSize,
    op = Op,
    sha = SHa,
    spa = SPa,
    tha = THa,
    tpa = TPa
}) ->
    % Функция вывода record
    io:format("ARP Packet:~n"),
    io:format("Hardware type: ~B~n", [HType]),
    io:format("Protocol type: ~B~n", [PType]),
    io:format("Hardware size: ~B~n", [HSize]),
    io:format("Protocol size: ~B~n", [PSize]),
    io:format("Opcode: ~B~n", [Op]),
    io:format("Sender MAC: ~s~n", [bin_to_str_mac(SHa)]),
    io:format("Sender IP: ~s~n", [bin_to_str_ip(SPa)]),
    io:format("Target MAC: ~s~n", [bin_to_str_mac(THa)]),
    io:format("Target IP: ~s~n", [bin_to_str_ip(TPa)]).