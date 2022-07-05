using System;
using HuffmanEncoding;

namespace HuffmanCLI
{
    class Program
    {
        static void Main(string[] args)
        {
            HuffmanCodec codec = new HuffmanCodec();

            string text = Console.ReadLine();
            Console.WriteLine($"We input text {text}");
            Console.WriteLine();

            string output = codec.Encoder(text);
            Console.WriteLine($"Output is {output}");
            Console.WriteLine();
            Console.WriteLine("Our tree");
            foreach (var v in codec.huffmanTable)
            {
                Console.WriteLine($"{v.Key} \t:{v.Value}");
                
            }


        }
    }
}
