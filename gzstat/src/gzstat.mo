/*
 gzstat.mo
 
 Utility for analyzing the structure of .gz files.
 For the most verbose output, use
   vessel gzstat.mo --print-block-codes --decode-blocks < your_input_file.gz


 Most of the implementation is based on the two RFC documents that describe .gz
 files and DEFLATE compression:
   - https://tools.ietf.org/html/rfc1951
   - https://tools.ietf.org/html/rfc1952
 Some details were determined by reverse engineering the gzip source code (https://www.gnu.org/software/gzip/).
*/

import Bool "mo:base/Bool";
import Nat "mo:base/Nat";
import Nat8 "mo:base/Nat8";
import Nat32 "mo:base/Nat32";
import Int "mo:base/Int";

import Iter "mo:base/Iter";

import Text "mo:base/Text";
import Time "mo:base/Time";

import Array "mo:base/Array";
import Buffer "mo:base/Buffer";

import HashMap "mo:base/HashMap";
import Hash "mo:base/Hash";

import Hex "mo:encoding/Hex";

import Debug "mo:base/Debug";

module {

public let print_gzip_headers = true ;
public let print_block_stats = true;
public let print_block_codes = true ;
public let decode_blocks = true ;

// Dictionary of possible 8 bit "compression type values" in the gzip header
public let compression_methods = [
 "store", //[0]
 "compress (lzw)",
 "pack",
 "lzh",
 "reserved",
 "reserved",
 "reserved",
 "reserved",
 "deflate"//[8]
];




public type LengthCode = {
    numBits:Nat;
    lowerBound:Nat;
};

// Class to contain Distance code numBits,lowerBound
public type DistanceCode = {
    numBits:Nat;
    lowerBound:Nat;
};

//todo:make class with init
public class CodeLib() {

////////////////////////////////
//        Length Codes        //
////////////////////////////////

     //public let ourLenghtCodes:HashMap.HashMap<Nat,LengthCode>  = getLegthCodes();
    // Compact representation of the length code value (257-285), length range and number
    // of extra bits to use in LZ77 compression (See Section 3.2.5 of RFC 1951)
    private let length_code_ranges = [
            [257,0,3,3],     [258,0,4,4],     [259,0,5,5],     [260,0,6,6],     [261,0,7,7],
            [262,0,8,8],     [263,0,9,9],     [264,0,10,10],   [265,1,11,12],   [266,1,13,14],
            [267,1,15,16],   [268,1,17,18],   [269,2,19,22],   [270,2,23,26],   [271,2,27,30],
            [272,2,31,34],   [273,3,35,42],   [274,3,43,50],   [275,3,51,58],   [276,3,59,66],
            [277,4,67,82],   [278,4,83,98],   [279,4,99,114],  [280,4,115,130], [281,5,131,162], 
            [282,5,163,194], [283,5,195,226], [284,5,227,257], [285,0,258,258]
    ];
 
   private func InitLengthCode():[LengthCode] {

        let size = length_code_ranges.size();
        let lcs = Buffer.Buffer<LengthCode>(size);


        for(i in Iter.range(0,size-1)){

            var codeL =  length_code_ranges[i];

            var lc:LengthCode = {
                    numBits = codeL[1];
                    lowerBound = codeL[2];
                };
                lcs.add(lc);
            };

        return lcs.toArray();
    };

    private let LengthCodes:[LengthCode]= InitLengthCode();

    public func GetLengthCode(code:Nat):LengthCode{
        let ourCode = code-257;
        return LengthCodes[ourCode];
    };

////////////////////////////////
//       Distance Codes       //
////////////////////////////////

    public let distance_code_ranges = [
            [0,0,1,1],         [1,0,2,2],          [2,0,3,3],           [3,0,4,4],           [4,1,5,6],
            [5,1,7,8],         [6,2,9,12],         [7,2,13,16],         [8,3,17,24],         [9,3,25,32],
            [10,4,33,48],      [11,4,49,64],       [12,5,65,96],        [13,5,97,128],       [14,6,129,192],
            [15,6,193,256],    [16,7,257,384],     [17,7,385,512],      [18,8,513,768],      [19,8,769,1024],
            [20,9,1025,1536],  [21,9,1537,2048],   [22,10,2049,3072],   [23,10,3073,4096],   [24,11,4097,6144],
            [25,11,6145,8192], [26,12,8193,12288], [27,12,12289,16384], [28,13,16385,24576], [29,13,24577,32768],
    ];

    private func InitDistanceCodes():[DistanceCode]
    {

        let size = distance_code_ranges.size();
        let dcs = Buffer.Buffer<LengthCode>(size);
        
            for (i in Iter.range(0,size-1)){
                var codeL =  distance_code_ranges[i];

                var dc:DistanceCode = {
                    numBits = codeL[1];
                    lowerBound = codeL[2];
                };
                
                dcs.add(dc);
        };

        return dcs.toArray();
    };

    private let ourDistanceCodes:[DistanceCode] = InitDistanceCodes();

    public func GetDistanceCode(code:Nat):DistanceCode{

        return ourDistanceCodes[code];
    };
    
    };

    
    public func binaryStringBigEndian(v:Nat,num_bits:Nat):Text{
        var result:Text = "";
        let bn:Nat32 = 1;
        let b:Nat32 = Nat32.fromNat(v);
        
        for(i in Iter.revRange(num_bits-1,0)){

            // Debug.print(debug_show(bn<<Nat32.fromIntWrap(i)));
            // let textA = "Hello ";
            // let textB = "World!";
            // let textOut = Text.concat(textA,textB);
            // Debug.print(debug_show(textOut));

            var c:Text = "0";
            
            if((b & bn<<Nat32.fromIntWrap(i)) != 0){
               c := "1"; 
            };
            result :=Text.concat(result,c);
        };
        return result;
    };


//Todo: How to define Exceptions in motoko

/*
class DecodingException(Exception):
    pass

class BuildHuffmanException(Exception):
    pass
*/


//Todo Create class bitstream

public calss BitStream(source_file:Text){

//Todo:class initialization 
    public func read_bit(){

    };

    public func read_bits(num_bits:Nat){

    };
    /*
    def read_byte(self):
        return self.read_bits(8)

    def read_uint16_big_endian(self):
        return (self.read_byte()<<8)|self.read_byte()
    
    def read_uint16_little_endian(self):
        return self.read_byte()|(self.read_byte()<<8)

    def read_uint32_big_endian(self):
        return (self.read_byte()<<24)|(self.read_byte()<<16)|(self.read_byte()<<8)|self.read_byte()
    
    def read_uint32_little_endian(self):
        return self.read_byte()|(self.read_byte()<<8)|(self.read_byte()<<16)|(self.read_byte()<<24)
    */
};

/*
class BitStream:
    class EndOfStream(Exception):
        pass
    buffer_size = 1024 # Number of bytes to read at a time
    def __init__(self, source_file):
        self.input_file = source_file
        self.working_bytes = bytes()
        self.working_bits_read = 0 # Number of bits already read from self.working_bytes
        self.total_bits_read = 0

    def read_bit(self):
        if self.working_bits_read//8 >= len(self.working_bytes):
            self.working_bytes = self.input_file.read(self.buffer_size)
            if len(self.working_bytes) == 0:
                raise BitStream.EndOfStream
            self.working_bits_read = 0
        byte_idx = self.working_bits_read//8
        bit_idx = self.working_bits_read%8
        self.working_bits_read += 1
        self.total_bits_read += 1
        return (self.working_bytes[byte_idx]>>bit_idx)&1
    def flush_to_byte(self):
        while self.working_bits_read%8 != 0:
            self.read_bit()



    #Read a bit sequence into an int value, with the low order bits read first
    def read_bits(self,num_bits):
        b = 0
        for i in range(num_bits):
            b = b|(self.read_bit()<<i)
        return b

    def read_byte(self):
        return self.read_bits(8)

    def read_uint16_big_endian(self):
        return (self.read_byte()<<8)|self.read_byte()
    
    def read_uint16_little_endian(self):
        return self.read_byte()|(self.read_byte()<<8)

    def read_uint32_big_endian(self):
        return (self.read_byte()<<24)|(self.read_byte()<<16)|(self.read_byte()<<8)|self.read_byte()
    
    def read_uint32_little_endian(self):
        return self.read_byte()|(self.read_byte()<<8)|(self.read_byte()<<16)|(self.read_byte()<<24)
        */
}
