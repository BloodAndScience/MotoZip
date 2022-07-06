import Text "mo:base/Text";
import Bool "mo:base/Bool";
import Char "mo:base/Char";
import I "mo:base/Iter";
import List "mo:base/List";
import Nat "mo:base/Nat";
import O "mo:base/Order";
import Buffer "mo:base/Buffer";
import Map "mo:base/HashMap";
import Debug "mo:base/Debug";

module {
        func Count(input:Text):Map.HashMap<Char, Nat> {
        let counter = Map.HashMap<Char, Nat>(0, Char.equal, Char.toNat32);

        for (c : Char in input.chars()) {

            let t:?Nat = counter.get(c);
            let nc:Nat = switch t {
                case null 0;
                case (?Nat) Nat;
            };
            if(nc==0)
            {
                counter.put(c,0)

            };
            let newC = nc+1;
            let result=  counter.replace(c,newC);

        };
        return counter;
    };

    public func Encode(input:Text):Text{
        

        let counter = Count(input);
        //ToText(counter); 
        for ( e in counter.entries())
        {
            Debug.print(debug_show(e))
        };

        return "Output"

    }  

}