import Debug "mo:base/Debug";
import Logic "./Logic";
import Calc "./Calculator";

import Text "mo:base/Text";
import Bool "mo:base/Bool";
import Char "mo:base/Char";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Sort "./Sorting";
//import Huffman "./Huffman";
//import Test "./Test"

/*
var input = "Huffman is fucking suffering";
var out = Huffman.Encode(input);
Debug.print(debug_show(out));
*/

func days_to_second(days:Nat):Nat{
    return days*86400;
};  

var numbers:[Nat] = [0,1,2,3];
numbers :=  Sort.swap(numbers,0,1);

Debug.print(debug_show(numbers[0]));
/*
let words = ["0","1","2","3"];

let x =10;
Debug.print(Nat.toText(x));

Debug.print(debug_show(words[2]));
Debug.print(debug_show(words.size()));
*/
/*
let age : Nat = 2;
let balance : Int = 2;
Debug.print(debug_show(age-3));
Debug.print(debug_show(balance-3));
*/

//Logic.Calculator();
//Logic.Main();
//Logic.OurLoop();  




