import M "mo:matchers/Matchers";
import T "mo:matchers/Testable";
import S "mo:matchers/Suite";
import GZS "../src/gzstat"


/*let IsFirstTest = GZS.print_gzip_headers;
let cm:Text = GZS.compression_methods[8];
let lc:Nat = GZS.length_code_ranges[9][2];

let dc:Nat = GZS.distance_code_ranges[0][0];


let codes = GZS.getLegthCodes().get(267);

var code:GZS.LengthCode =  switch (codes) {
        case null  { {
            lowerBound=0;
            numBits=0;
        };
            };
        case (?w) { w};
};*/

let lenCode:GZS.LengthCode = GZS.CodeLib().GetLengthCode(267);
let distCode:GZS.LengthCode = GZS.CodeLib().GetDistanceCode(15);

let suite = S.suite("Gzip Stat", [
    S.suite("Check static values", [

        S.test("",lenCode.lowerBound,M.equals(T.nat(15))),
        S.test("",distCode.lowerBound,M.equals(T.nat(193)))

    /*  S.test("read GZIP header", IsFirstTest, M.equals(T.bool(true))),
        S.test("Comrpession method deflate", cm, M.equals(T.text("deflate"))),
        S.test("Array of lenght", lc, M.equals(T.nat(13))),
        S.test("Array of distance", dc, M.equals(T.nat(0))),

        S.test("Length Code NumBit", code.numBits, M.equals(T.nat(1))),
        S.test("Length Code Base lower bound", code.lowerBound, M.equals(T.nat(15))),

        S.test("5 is greater than three", 5, M.greaterThan<Nat>(3)),*/

    ])
]);
S.run(suite)
//assertThat(5 + 5, M.allOf<Nat>([M.greaterThan(8), M.lessThan(12)]));
//assertThat([1, 2], M.array([M.equals(T.nat(1)), M.equals(T.nat(2))]));