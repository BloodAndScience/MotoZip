import Debug "mo:base/Debug";
import Logic "./Logic";
import Calc "./Calculator";


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




//Logic.Main();
//Logic.OurLoop();  




