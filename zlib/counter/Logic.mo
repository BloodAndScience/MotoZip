import Debug "mo:base/Debug";
import Text "mo:base/Text";
import Bool "mo:base/Bool";
import Calc "./Calculator";

module {

    public func Calculator(){
    
        let x = 10;
        let y = 5;

        var r =  Calc.Add(x,y);
        Debug.print(debug_show("Add", r));
        r :=  Calc.Remove(x,y);
        Debug.print(debug_show("Remove", r));
        r :=  Calc.Multiply(x,y);
        Debug.print(debug_show("Multiply", r));
        r :=  Calc.Devide(x,y);
        Debug.print(debug_show("Devision", r));
    };  
     public func OurLoop() {

        var i = 0;
        while(i < 10) {
        i += 1;
        Debug.print(" I am in the fucking loop"); 
        Debug.print(debug_show(i));
        }
    };
    
    public func Main(){

        Debug.print("Hello F*cking motoko world")
    };
    

}