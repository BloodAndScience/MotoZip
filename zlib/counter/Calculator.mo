import Debug "mo:base/Debug";
import Text "mo:base/Text";
import Bool "mo:base/Bool";
import Nat "mo:base/Nat";

module{

    

    public func Add(a:Nat, b:Nat):Nat{
           a+b
    };
    public func Remove(a:Nat, b:Nat):Nat{ 
            a-b 
    };
    public func Multiply(a:Nat, b:Nat):Nat{  
            a*b
    };
    public func Devide(a:Nat, b:Nat):Nat{    
            a/b
    };
}
