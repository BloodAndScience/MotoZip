import Debug "mo:base/Debug";
import Text "mo:base/Text";
import Bool "mo:base/Bool";

module {

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