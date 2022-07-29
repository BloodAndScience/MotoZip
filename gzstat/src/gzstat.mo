/*
# gzstat.py
# 
# Utility for analyzing the structure of .gz files.
# For the most verbose output, use
#   python gzstat.py --print-block-codes --decode-blocks < your_input_file.gz
#
#
# Most of the implementation is based on the two RFC documents that describe .gz
# files and DEFLATE compression:
#   - https://tools.ietf.org/html/rfc1951
#   - https://tools.ietf.org/html/rfc1952
#
#
# Some details were determined by reverse engineering the gzip source code (https://www.gnu.org/software/gzip/).
#
# B. Bird - 03/12/2020

*/
//import sys, collections, datetime, binascii


import Nat "mo:base/Nat";
import Nat8 "mo:base/Nat8";
import Bool "mo:base/Bool";
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

//todo:make class with init
public class LenCodeLib() {
    
    private let LengthCodes:[LengthCode];

    public func GetLengthCode(code:Nat):LengthCode{
        let ourCode = code-257;
        return LengthCodes[ourCode];
    }
 
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
    private func InitLengthCode():[LengthCode]{

        let size = length_code_ranges.size();
        let lengthCodes = Buffer.Buffer<LengthCode>(size);


        for(i in Iter.range(0,size-1)){

            var codeL =  length_code_ranges[i];

            var lc:LengthCode = {
                    numBits = codeL[1];
                    lowerBound = codeL[2];
                };
                lenghtCodes.put(codeL[0],lc);
            };

        return c.ToArray();
    }

  

    // Create array of specific size
    // Mutable into immutable


  /*
    private func getLegthCodes():HashMap.HashMap<Nat,LengthCode> {

        let lenghtCodes = HashMap.HashMap<Nat,LengthCode>(0,Nat.equal, Hash.hash);

        let size = length_code_ranges.size();

        for(i in Iter.range(0,size-1)){

            var codeL =  length_code_ranges[i];

            var lc:LengthCode = {
                    numBits = codeL[1];
                    lowerBound = codeL[2];
                };
                lenghtCodes.put(codeL[0],lc);
            };
        return lenghtCodes;
    }; 
    */
    
    public func GetLowBountry(index:Nat):LengthCode{
        let r = ourLenghtCodes.get(index);
        return switch r { case (null) LengthCode{0,0}; …; case _ en }
    };

};

//#Construct a lookup table mapping length codes to (num_bits,lower_bound) pairs
// Dosent really metter


   


//# Compact representation of the distance code value (0-31), distance range and number
//# of extra bits to use in LZ77 compression (See Section 3.2.5 of RFC 1951)


//#Construct a lookup table mapping distance codes to (num_bits,lower_bound) pairs
public type DistanceCode = {
    numBits:Nat;
    lowerBound:Nat;
};

public class DistCodeLib() {
    
    private let ourDistanceCodes<DistanceCode>:Buffer = 29;

    public func GetDistanceCode(code:Nat):DistanceCode{
        return ourDistanceCodes[code];
    }
 
    //public let ourLenghtCodes:HashMap.HashMap<Nat,LengthCode>  = getLegthCodes();
    // Compact representation of the length code value (257-285), length range and number
    // of extra bits to use in LZ77 compression (See Section 3.2.5 of RFC 1951)
    public let distance_code_ranges = [
            [0,0,1,1],         [1,0,2,2],          [2,0,3,3],           [3,0,4,4],           [4,1,5,6],
            [5,1,7,8],         [6,2,9,12],         [7,2,13,16],         [8,3,17,24],         [9,3,25,32],
            [10,4,33,48],      [11,4,49,64],       [12,5,65,96],        [13,5,97,128],       [14,6,129,192],
            [15,6,193,256],    [16,7,257,384],     [17,7,385,512],      [18,8,513,768],      [19,8,769,1024],
            [20,9,1025,1536],  [21,9,1537,2048],   [22,10,2049,3072],   [23,10,3073,4096],   [24,11,4097,6144],
            [25,11,6145,8192], [26,12,8193,12288], [27,12,12289,16384], [28,13,16385,24576], [29,13,24577,32768],
    ];

    private func InitDistanceCode(){
        let size = distance_code_ranges.size();
            for i in Iter.range(0,size-1){
                var codeL =  distance_code_ranges[i];

                var lc:DistanceCode = {
                    numBits = codeL[1];
                    lowerBound = codeL[2];
                };
                
                ourDistanceCodes.add(lc);
            };
            }
    }
    /*
    private func InitDistanceCode():[DistanceCode]{

        let size = distance_code_ranges.size();
        let distanceCodes = Buffer.Buffer<DistanceCode>(size);


        for(i in Iter.range(0,size-1)){

            var codeL =  distance_code_ranges[i];

            var lc:DistanceCode = {
                    numBits = codeL[1];
                    lowerBound = codeL[2];
                };
                distanceCodes.put(codeL[0],lc);
            };

        return c.ToArray();
    }

  
    public func GetLowBountry(index:Nat):DistanceCode{
        let r = ourDistanceCodes.get(index);
        return switch r { case (null) DistanceCode{0,0}; …; case _ en }
    };
        */
};

/*distance_codes = {}
for code, num_bits, lower_bound, upper_bound in distance_code_ranges:
    for i in range(lower_bound, upper_bound+1):
        distance_codes[code] = (num_bits,lower_bound)








def binary_string_big_endian(v, num_bits):
    result = ''
    for i in range(num_bits-1,-1,-1):
        result += '1' if (v&(1<<i)) != 0 else '0'
    return result


class DecodingException(Exception):
    pass

class BuildHuffmanException(Exception):
    pass

*/
}