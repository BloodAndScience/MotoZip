import Text "mo:base/Text";
import Bool "mo:base/Bool";
import Char "mo:base/Char";

import Array "mo:base/Array";
import Order "mo:base/Order";

import Int "mo:base/Int";
import Nat "mo:base/Nat";

module {


public func _swap(array : [Nat], i : Nat, j : Nat) : [Nat] {
    // Transform our immutable array into a mutable one so we can modify values.
    let array_mutable = Array.thaw<Nat>(array);
    let tmp = array[i];
    array[i] := array[j];
    array[j] := tmp;
    // Transform our mutable array into an immutable array.
    return(Array.freeze<Nat>(array));
};


 public func swap(arr:[Nat],i:Nat,j:Nat):[Nat]{

    let mArr = Array.thaw<Nat>(arr);
    let tmp = arr[i];
    mArr[i] := mArr[j];
    mArr[j] := tmp;
    return(Array.freeze<Nat>(mArr));
};


/*
public func SelectionSort(arr:[Nat]):[Nat]
{

};

*/

}